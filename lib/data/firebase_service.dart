import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getDeckData(String deckId) async {
    var deckData = <String, dynamic>{};

    var deckRef = _firestore.collection('decks').doc(deckId);
    var deckSnapshot = await deckRef.get();
    if (!deckSnapshot.exists) {
      throw Exception("Deck not found");
    }
    deckData['title'] = deckSnapshot.data()?['title'] ?? '';
    deckData['videoUrl'] = deckSnapshot.data()?['videoUrl'] ?? '';
    deckData['tags'] =
        List.from(deckSnapshot.data()?['tags'] ?? []); // Add tags here
    deckData['mapUrl'] = deckSnapshot.data()?['mapUrl'] ?? '';
    deckData['exactMatch'] = deckSnapshot.data()?['exactMatch'] ?? true;
    deckData['isPublic'] =
        deckSnapshot.data()?['isPublic'] ?? false; // Add isPublic here

    // Fetch the cards ordered by 'position'
    var cardsSnapshot =
        await deckRef.collection('cards').orderBy('position').get();
    var cards = cardsSnapshot.docs
        .asMap() // Convert to map to access index
        .map((index, doc) => MapEntry(index, {
              'id': doc.id,
              'front': doc.data()['front'] ?? '',
              'front_tex': doc.data()['front_tex'] ?? '',
              'back': doc.data()['back'] ?? '',
              'back_tex': doc.data()['back_tex'] ?? '',
              'imageUrl': doc.data()['imageUrl'] ?? '',
              'position':
                  doc.data()['position'] ?? index, // Use map index as fallback
              'mcq': doc.data()['mcq'] ?? {},
              'explanation': doc.data()['explanation'] ?? '',
              'explanation_tex': doc.data()['explanation_tex'] ?? '',
              'mnemonic': doc.data()['mnemonic'] ?? '',
            }))
        .values // Convert back to iterable
        .toList();
    deckData['cards'] = cards;
    return deckData;
  }

  Stream<List<Map<String, dynamic>>> getDecksStream() {
    return _firestore
        .collection('decks')
        .where('isPublic', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'title': doc.data()['title'],
                'videoUrl': doc.data()['videoUrl'] ??
                    '', // Include videoUrl in the stream
                'mapUrl': doc.data()['mapUrl'] ?? '',
                'tags': doc.data()['tags'] ?? [],
              })
          .toList();
    });
  }
}
