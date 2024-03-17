import 'package:flutter/material.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/ui/cloud/category_card.dart';
import 'package:learning_assistant/ui/cloud/deck_card.dart';

class DecksScreen extends StatefulWidget {
  final firebaseService = ServiceLocator.instance.get<FirebaseService>();
  DecksScreen({Key? key}) : super(key: key);

  @override
  _DecksScreenState createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Decks')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: widget.firebaseService.getDecksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> decks = snapshot.data!;
            decks.sort((a, b) => a['tags'].isEmpty ? 1 : -1);
            return ListView.builder(
              itemCount: decks.length,
              itemBuilder: (context, index) {
                var deck = decks[index];
                if (deck['tags'].isNotEmpty) {
                  final category = deck['tags'][0];
                  final matchingDecks = decks.where((deck) {
                    return deck['tags'].isNotEmpty &&
                        deck['tags'][0].startsWith(category);
                  }).toList();
                  return CategoryCard(
                      categoryList: [],
                      category: category,
                      deck: matchingDecks);
                } else {
                  return DeckCard(deck: deck);
                }
              },
            );
          } else {
            return const Center(child: Text('No decks found'));
          }
        },
      ),
    );
  }
}
