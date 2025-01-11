import 'package:flutter/material.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/data/flash_card.dart';
import 'package:learning_assistant/di/injection_container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dialogs/test_preference_dialog.dart';

class DeckCardNew extends StatefulWidget {
  final Map<String, dynamic> deck;

  DeckCardNew({required this.deck});

  @override
  _DeckCardNewState createState() => _DeckCardNewState();
}

class _DeckCardNewState extends State<DeckCardNew> {
  final FirebaseService _firebaseService = sl<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum space
        children: [
          ListTile(
            leading: Icon(Icons.library_books,
                color: Theme.of(context).iconTheme.color),
            title: Text(widget.deck['title'],
                style: const TextStyle(fontSize: 18.0)),
            onTap: () async {
              try {
                var group = await fetchCompleteDeck(widget.deck['deckId']);
                Navigator.pushNamed(context, '/train', arguments: group);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('This deck is not public yet')),
                );
              }
            },
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.start,
            children: [
              if (widget.deck['videoUrl'] != null &&
                  widget.deck['videoUrl'].isNotEmpty)
                TextButton.icon(
                  icon: Icon(
                    Icons.play_circle_filled,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  label: Text(
                    'Play Video',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: () async {
                    var url = Uri.parse(widget.deck['videoUrl']);
                    if (!await launchUrl(url)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $url')),
                      );
                    }
                  },
                ),
              if (widget.deck['mapUrl'] != null &&
                  widget.deck['mapUrl'].isNotEmpty)
                TextButton.icon(
                  icon: Icon(
                    Icons.map,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  label: Text(
                    'View Map',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: () async {
                    _showDialog(context, widget.deck['mapUrl']);
                  },
                ),
              TextButton.icon(
                icon: Icon(
                  Icons.visibility,
                  color: Theme.of(context).iconTheme.color,
                ),
                label: Text(
                  'Results',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/results', arguments: widget.deck['title']);
                },
              ),
              TextButton.icon(
                icon: Icon(
                  Icons.timer,
                  color: Theme.of(context).iconTheme.color,
                ),
                label: Text(
                  'Start Exam',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () async {
                  var group = await fetchCompleteDeck(widget.deck['deckId']);
                  showTestPreferenceDialog(context, (preference) {
                    Navigator.of(context).pushNamed(
                      '/exam',
                      arguments: {
                        'group': group,
                        'preference': preference,
                      },
                    );
                  });
                },
              ),
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
    var deckData = await _firebaseService.getDeckData(deckId);
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
          mcqOptions: (card['mcq']?['options'] as List<dynamic>?)
                  ?.map<String>((e) => e.toString())
                  .toList() ??
              [],
          mcqOptionsTex: (card['mcq']?['options_tex'] as List<dynamic>?)
                  ?.map<String>((e) => e.toString())
                  .toList() ??
              [],
          correctOptionIndex: card['mcq']?['answer_index'],
          explanation: card['explanation'],
          explanationTex: card['explanation_tex'],
          mnemonic: card['mnemonic']);
    });
    return FlashCardDeck(
      id: deckId,
      title: deckData['title'],
      tags: [],
      cards: cards,
      exactMatch: deckData['exactMatch'] ?? true,
    );
  }
}
