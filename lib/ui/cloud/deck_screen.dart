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
            // Sort decks if necessary or perform other preprocessing

            // Group decks by their first tag
            var categories = <String, List<Map<String, dynamic>>>{};
            for (var deck in decks) {
              if (deck['tags'].isNotEmpty) {
                String category = deck['tags'][0];
                categories.putIfAbsent(category, () => []).add(deck);
              }
            }

            List<Widget> children = [];

            // For categories with decks, create a CategoryCard
            categories.forEach((category, decksInCategory) {
              children.add(CategoryCard(
                  categoryList: [], // Assuming you have logic to populate this
                  category: category,
                  deck: decksInCategory));
            });

            // Add DeckCards for decks without a category directly to the list
            decks.where((deck) => deck['tags'].isEmpty).forEach((deck) {
              children.add(DeckCard(deck: deck));
            });

            return ListView(children: children);
          } else {
            return const Center(child: Text('No decks found'));
          }
        },
      ),
    );
  }
}
