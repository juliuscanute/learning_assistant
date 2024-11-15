import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Fetch deck data with caching
  Future<Map<String, dynamic>> getDeckData(String deckId) async {
    // Track event
    await _analytics.logEvent(
      name: 'get_deck_data',
      parameters: {'deck_id': deckId},
    );
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

      return deckData;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getFoldersStream() {
    // Track event
    _analytics.logEvent(name: 'get_folders_stream');
    return _firestore.collection('folder').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, 'name': data['name'] ?? ''};
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getFolders() async {
    // Track event
    await _analytics.logEvent(name: 'get_folders');
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
    // Track event
    await _analytics.logEvent(
      name: 'get_sub_folders',
      parameters: {'parent_path': parentPath},
    );
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

        yield decks;
      }
    } catch (e) {
      rethrow;
    }
  }
}
