import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_assistant/data/cache_service.dart';

class BlogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CacheService _cacheService = CacheService();

  static const String blogCacheKey = 'blog_cache';
  static const Duration cacheDuration = Duration(hours: 24);

  Future<List<Map<String, dynamic>>> getFolders() async {
    try {
      final snapshot = await _firestore.collection('blogFolders').get();
      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, 'name': data['name'] ?? ''};
      }).toList();
      items.sort((a, b) => a['name'].compareTo(b['name']));
      return items;
    } catch (e) {
      print('Error getting folders: $e');
      return [];
    }
  }

  // Method to read subfolders of a folder from Firestore
  // /folder/{folderId}/subfolder/ - Returns subfolder in this collection
  // /folder/{folderId}/subfolder/{subfolderId}/subfolder - Returns subfolder in this collection
  // Input will contain the parent path with id
  Future<List<Map<String, dynamic>>> getSubFolders(String parentPath) async {
    try {
      var subFolders = <Map<String, dynamic>>[];
      var subFolderSnapshot = await _firestore.collection(parentPath).get();

      for (var subFolder in subFolderSnapshot.docs) {
        var folderData = subFolder.data();
        if (folderData['hasSubfolders'] == true) {
          subFolders.add({
            'id': subFolder.id,
            'name': folderData['name'] ?? '',
            'hasSubfolders': true,
          });
        } else {
          subFolders.add({
            'id': subFolder.id,
            'blogId': folderData['blogId'] ?? '',
            'title': folderData['title'] ?? '',
            'type': 'card',
            'hasSubfolders': false,
          });
        }
      }

      // Ensure all names and titles are strings and handle null values
      subFolders.sort((a, b) {
        bool hasABlogId = a.containsKey('blogId') && a['blogId'] != null;
        bool hasBBlockId = b.containsKey('blogId') && b['blogId'] != null;

        if (hasABlogId && hasBBlockId) {
          String titleA = (a['title'] ?? '').toString().toLowerCase();
          String titleB = (b['title'] ?? '').toString().toLowerCase();
          return titleA.compareTo(titleB);
        } else if (hasABlogId && !hasBBlockId) {
          return 1;
        } else if (!hasABlogId && hasBBlockId) {
          return -1;
        } else {
          String idA = (a['id'] ?? '').toString().toLowerCase();
          String idB = (b['id'] ?? '').toString().toLowerCase();
          return idA.compareTo(idB);
        }
      });

      return subFolders;
    } catch (error) {
      print('Error reading subfolders from Firestore: $error');
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getBlogStream() async* {
    // Check if cached data is valid
    if (await _cacheService.isCacheValid(blogCacheKey, cacheDuration)) {
      final cachedData = await _cacheService.getFromCache(blogCacheKey);
      if (cachedData != null) {
        yield List<Map<String, dynamic>>.from(cachedData);
      }
    }

    // Fetch from Firestore
    try {
      var querySnapshotStream = _firestore
          .collection('blogs')
          .orderBy('created_at', descending: true)
          .snapshots();

      await for (var querySnapshot in querySnapshotStream) {
        var blogs = querySnapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;

          // Convert Timestamp to milliseconds since epoch
          data.forEach((key, value) {
            if (value is Timestamp) {
              data[key] = value.millisecondsSinceEpoch;
            }
          });

          return data;
        }).toList();

        // Save to cache
        await _cacheService.saveToCache(blogCacheKey, blogs);

        yield blogs;
      }
    } catch (e) {
      // On error, return cached data if available
      final cachedData = await _cacheService.getFromCache(blogCacheKey);
      if (cachedData != null) {
        yield List<Map<String, dynamic>>.from(cachedData);
      } else {
        rethrow;
      }
    }
  }

  Future<Map<String, dynamic>?> getBlogPostById(String id) async {
    try {
      final DocumentSnapshot docSnapshot =
          await _firestore.collection('blogs').doc(id).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting blog post by ID: $e');
      return null;
    }
  }
}
