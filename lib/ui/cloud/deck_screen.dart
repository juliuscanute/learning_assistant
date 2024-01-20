import 'package:flutter/material.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/di/service_locator.dart';

class DecksScreen extends StatefulWidget {
  final firebaseService = ServiceLocator.instance.get<FirebaseService>();
  DecksScreen({Key? key}) : super(key: key);

  @override
  _DecksScreenState createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> {

  // Add this method to FirebaseService
Future<FlashCardGroup> fetchCompleteDeck(String deckId) async {
  // Fetch deck data
  var deckData = await widget.firebaseService.getDeckData(deckId);

  // Create FlashCardGroup
  List<CardEmbedded> cards = List<CardEmbedded>.generate(
    deckData['cards'].length,
    (index) {
      var card = deckData['cards'][index];
      return CardEmbedded()
        ..index = index // Use the current position in the list as index
        ..front = card['front']
        ..back = card['back'];
    },
  );
  return FlashCardGroup(deckData['title'], cards);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Decks')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: widget.firebaseService.getDecksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var decks = snapshot.data!;
            return ListView.builder(
              itemCount: decks.length,
              itemBuilder: (context, index) {
                var deck = decks[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(deck['title'], style: TextStyle(fontSize: 18.0)),
                    onTap: () async {
                      var group = await fetchCompleteDeck(deck['id']);
                      Navigator.pushNamed(context, '/train', arguments: group);
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No decks found'));
          }
        },
      ),
    );
  }
}
