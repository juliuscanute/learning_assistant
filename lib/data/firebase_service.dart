import 'package:cloud_firestore/cloud_firestore.dart';

class Deck {
  final String id;
  final String title;
  final List<Map<String, dynamic>> cards;

  Deck({required this.id, required this.title, required this.cards});
}


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

    // Fetch the cards
    var cardsSnapshot = await deckRef.collection('cards').get();
    var cards = cardsSnapshot.docs
        .map((doc) => {
              'front': doc.data()['front'] ?? '',
              'back': doc.data()['back'] ?? '',
            })
        .toList();
    deckData['cards'] = cards;

    return deckData;
  }


  Stream<List<Map<String, dynamic>>> getDecksStream() {
    return _firestore.collection('decks').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, 'title': doc.data()['title']})
          .toList();
    });
  }
}
