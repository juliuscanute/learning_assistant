import 'package:flutter/material.dart';
import 'package:learning_assistant/ui/cloud/category_card.dart';
import 'package:learning_assistant/ui/cloud/deck_card.dart';

class CategoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> decks;
  final List<String> categoryList;

  CategoryScreen({required this.decks, required this.categoryList});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryList.last),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: widget.decks.length,
          itemBuilder: (context, index) {
            final deck = widget.decks[index];
            final updatedTags = List<String>.from(deck['tags']);
            for (var category in widget.categoryList) {
              updatedTags.remove(category);
            }
            if (updatedTags.isEmpty) {
              return DeckCard(deck: deck);
            } else {
              // final matchingDecks = widget.decks.where((deck) {
              //   return deck['tags'].isNotEmpty &&
              //       deck['tags'][0].startsWith(category);
              // }).toList();
              return CategoryCard(
                categoryList: widget.categoryList,
                category: updatedTags[0],
                deck: widget.decks,
              );
            }
          },
        ),
      ),
    );
  }
}
