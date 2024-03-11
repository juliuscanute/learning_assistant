import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getDeckData(String deckId) async {
    var deckData = <String, dynamic>{};

    // Fetch the deck document
    var deckRef = _firestore.collection('decks').doc(deckId);
    var deckSnapshot = await deckRef.get();
    if (!deckSnapshot.exists) {
      throw Exception("Deck not found");
    }
    deckData['title'] = deckSnapshot.data()?['title'] ?? '';
    deckData['videoUrl'] =
        deckSnapshot.data()?['videoUrl'] ?? ''; // Fetching videoUrl
    deckData['tags'] = deckSnapshot.data()?['tags'] ?? []; // Adding tags

    // Fetch the cards ordered by 'position'
    var cardsSnapshot =
        await deckRef.collection('cards').orderBy('position').get();
    var cards = cardsSnapshot.docs
        .asMap() // Convert to map to access index
        .map((index, doc) => MapEntry(index, {
              'front': doc.data()['front'] ?? '',
              'back': doc.data()['back'] ?? '',
              'imageUrl': doc.data()['imageUrl'] ?? '',
              'position':
                  doc.data()['position'] ?? index, // Use map index as fallback
            }))
        .values // Convert back to iterable
        .toList();
    deckData['cards'] = cards;

    return deckData;
  }

  Stream<List<Map<String, dynamic>>> getDecksStream() {
    return _firestore.collection('decks').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'title': doc.data()['title'],
                'videoUrl': doc.data()['videoUrl'] ??
                    '' // Include videoUrl in the stream
              })
          .toList();
    });
  }
}
