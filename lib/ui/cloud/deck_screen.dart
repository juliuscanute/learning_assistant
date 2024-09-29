import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/theme_notifier.dart';
import 'package:learning_assistant/ui/cloud/category_card.dart';
import 'package:learning_assistant/ui/cloud/deck_card.dart';
import 'package:provider/provider.dart';

class DecksScreen extends StatefulWidget {
  final firebaseService = ServiceLocator.instance.get<FirebaseService>();
  DecksScreen({Key? key}) : super(key: key);

  @override
  _DecksScreenState createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Decks',
        ),
      ),
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
            decks.sort((a, b) => a['title'].compareTo(b['title']));

            // Group decks by their first tag
            var categories = SplayTreeMap<String, List<Map<String, dynamic>>>();
            for (var deck in decks) {
              if (deck['tags'].isNotEmpty) {
                String category = deck['tags'][0];
                categories.putIfAbsent(category, () => []).add(deck);
              }
            }

            List<Widget> children = [];

            // Add the image at the top of the list
            children.add(
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height /
                      2, // Set your desired maximum height here
                ),
                child: Image.asset(
                  brightness == Brightness.light
                      ? 'assets/images/light/illustration_study.webp'
                      : 'assets/images/dark/illustration_study.webp',
                  fit: BoxFit.cover, // Adjust the fit as needed
                  width: double
                      .infinity, // Ensure the image fills the available width
                ),
              ),
            );

            // For categories with decks, create a CategoryCard
            categories.forEach((category, decksInCategory) {
              children.add(CategoryCard(
                  categoryList: const [], // Assuming you have logic to populate this
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
