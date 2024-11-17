import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_assistant/data/service/analytics_service.dart'
    if (dart.library.io) 'package:learning_assistant/data/service/analytics_service_stub.dart';
import 'package:learning_assistant/di/injection_container.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AnalyticsService _analyticsService = sl<AnalyticsService>();

  Future<Map<String, dynamic>> getDeckData(String deckId) async {
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

      // Track event
      await _analyticsService.logEvent(
        'get_deck_data',
        parameters: {'deck_id': deckId, 'deck_title': deckData['title'] ?? ''},
      );
      return deckData;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getFoldersStream() {
    // Track event
    _analyticsService.logEvent('get_folders_stream');

    return _firestore.collection('folder').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, 'name': data['name'] ?? ''};
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getFolders() async {
    // Track event
    await _analyticsService.logEvent('get_folders');

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
    await _analyticsService.logEvent(
      'get_sub_folders',
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

      // Ensure all names and titles are strings and handle null values
      subFolders.sort((a, b) {
        String nameA = (a['name'] ?? '').toString().toLowerCase();
        String nameB = (b['name'] ?? '').toString().toLowerCase();
        int nameComparison = nameA.compareTo(nameB);
        if (nameComparison != 0) {
          return nameComparison;
        }
        String titleA = (a['title'] ?? '').toString().toLowerCase();
        String titleB = (b['title'] ?? '').toString().toLowerCase();
        return titleA.compareTo(titleB);
      });

      return subFolders;
    } catch (error) {
      print('Error reading subfolders from Firestore: $error');
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getDecksList() async* {
    // Track event
    _analyticsService.logEvent('get_decks_list');

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
