import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_assistant/data/cache_service.dart';

class BlogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CacheService _cacheService = CacheService();

  static const String blogCacheKey = 'blog_cache';
  static const Duration cacheDuration = Duration(hours: 24);

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
}
