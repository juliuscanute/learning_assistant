import 'package:flutter/material.dart';
import 'package:learning_assistant/data/fash_card.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class DeckCard extends StatelessWidget {
  final firebaseService = ServiceLocator.instance.get<FirebaseService>();
  final Map<String, dynamic> deck;

  DeckCard({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum space
        children: [
          ListTile(
            title: Text(deck['title'], style: const TextStyle(fontSize: 18.0)),
            onTap: () async {
              var group = await fetchCompleteDeck(deck['id']);
              Navigator.pushNamed(context, '/train', arguments: group);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (deck['videoUrl'] != null && deck['videoUrl'].isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.play_circle_filled),
                  onPressed: () async {
                    var url = Uri.parse(deck['videoUrl']);
                    if (!await launchUrl(url)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $url')),
                      );
                    }
                  },
                ),
              if (deck['mapUrl'] != null && deck['mapUrl'].isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () async {
                    _showDialog(context, deck['mapUrl']);
                  },
                ),
              IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/results', arguments: deck['title']);
                },
              ),
              IconButton(
                  icon: const Icon(Icons.timer),
                  onPressed: () async {
                    var group = await fetchCompleteDeck(deck['id']);
                    Navigator.of(context)
                        .popAndPushNamed('/exam', arguments: group);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20.0),
            minScale: 0.5,
            maxScale: 4,
            child: Image.network(imageUrl),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to fetch complete deck
  Future<FlashCardDeck> fetchCompleteDeck(String deckId) async {
    var deckData = await firebaseService.getDeckData(deckId);
    List<FlashCard> cards =
        List<FlashCard>.generate(deckData['cards'].length, (index) {
      var card = deckData['cards'][index];
      return FlashCard(
          index: index,
          front: card['front'],
          frontTex: card['front_tex'],
          back: card['back'],
          backTex: card['back_tex'],
          imageUrl: card['imageUrl'],
          mcqOptions: card['mcq']['options']
                  ?.map<String>((e) => e.toString())
                  .toList() ??
              [],
          mcqOptionsTex: card['mcq']['options_tex']
                  ?.map<String>((e) => e.toString())
                  .toList() ??
              [],
          correctOptionIndex: card['mcq']['answer_index']);
    });
    return FlashCardDeck(
      title: deckData['title'],
      tags: [],
      cards: cards,
      exactMatch: deckData['exactMatch'] ?? true,
    );
  }
}
