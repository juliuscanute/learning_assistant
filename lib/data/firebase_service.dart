import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_assistant/data/cache_service.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CacheService _cacheService = CacheService();

  static const String deckCachePrefix = 'deck_cache_';
  static const String decksListCacheKey = 'decks_list_cache';
  static const Duration cacheDuration = Duration(hours: 24);
  StreamSubscription<QuerySnapshot>? _changeListener;

  FirebaseService() {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    _setupChangeListener();
  }

  // Listen for changes to invalidate caches
  void _setupChangeListener() {
    _changeListener = _firestore
        .collection('decks')
        .where('isPublic', isEqualTo: true)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) async {
      if (!snapshot.metadata.isFromCache &&
          !snapshot.metadata.hasPendingWrites) {
        await _cacheService.invalidateAllCaches();
      }
    });
  }

  // Fetch deck data with caching
  Future<Map<String, dynamic>> getDeckData(String deckId) async {
    final cacheKey = '$deckCachePrefix$deckId';

    // Check if cached data is valid
    if (await _cacheService.isCacheValid(cacheKey, cacheDuration)) {
      final cachedData = await _cacheService.getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Fetch from Firestore
    try {
      var deckRef = _firestore.collection('decks').doc(deckId);
      var deckSnapshot = await deckRef.get();

      if (!deckSnapshot.exists) {
        throw Exception("Deck not found");
      }

      var deckData = deckSnapshot.data()!;
      deckData['id'] = deckSnapshot.id;

      // Fetch cards
      var cardsSnapshot =
          await deckRef.collection('cards').orderBy('position').get();
      var cards = cardsSnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      deckData['cards'] = cards;

      // Save to cache
      await _cacheService.saveToCache(cacheKey, deckData);

      return deckData;
    } catch (e) {
      // On error, return cached data if available
      final cachedData = await _cacheService.getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getFoldersStream() {
    return _firestore.collection('folder').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, 'name': data['name'] ?? ''};
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getFolders() async {
    try {
      var folders = <Map<String, dynamic>>[];
      var folderSnapshot = await _firestore.collection('folder').get();
      for (var folder in folderSnapshot.docs) {
        folders.add({
          'id': folder.id,
          'name': folder.data()['name'] ?? '',
        });
      }
      return folders;
    } catch (error) {
      print('Error reading folders from Firestore: $error');
      return [];
    }
  }

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
            'name': folderData['name'] ?? '',
            'deckId': folderData['deckId'] ?? '',
            'title': folderData['title'] ?? '',
            'isPublic': folderData['isPublic'] ?? false,
            'type': 'card',
            'hasSubfolders': false,
          });
        }
      }

      return subFolders;
    } catch (error) {
      print('Error reading subfolders from Firestore: $error');
      return [];
    }
  }

  // Fetch list of decks with caching
  Stream<List<Map<String, dynamic>>> getDecksList() async* {
    // Check if cached data is valid
    if (await _cacheService.isCacheValid(decksListCacheKey, cacheDuration)) {
      final cachedData = await _cacheService.getFromCache(decksListCacheKey);
      if (cachedData != null) {
        yield List<Map<String, dynamic>>.from(cachedData);
      }
    }

    // Fetch from Firestore
    try {
      var querySnapshotStream = _firestore
          .collection('decks')
          .where('isPublic', isEqualTo: true)
          .snapshots();

      await for (var querySnapshot in querySnapshotStream) {
        var decks = querySnapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        // Save to cache
        await _cacheService.saveToCache(decksListCacheKey, decks);

        yield decks;
      }
    } catch (e) {
      // On error, return cached data if available
      final cachedData = await _cacheService.getFromCache(decksListCacheKey);
      if (cachedData != null) {
        yield List<Map<String, dynamic>>.from(cachedData);
      } else {
        rethrow;
      }
    }
  }
}
