import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:learning_assistant/ui/cloud/category_card.dart';
import 'package:learning_assistant/ui/cloud/deck_card.dart';

class CategoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> decks;
  final List<String> categoryList;

  const CategoryScreen({super.key, required this.decks, required this.categoryList});

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
        child: () {
          // Filter decks that belong to the current category/subcategories
          final relevantDecks = widget.decks.where((deck) {
            final tags = List<String>.from(deck['tags']);
            // Check if the deck's categories match up to the current category list
            return tags.take(widget.categoryList.length).toList().join(',') ==
                widget.categoryList.join(',');
          }).toList();

          // Group remaining decks by their next subcategory
          final subcategoryGroups =
              SplayTreeMap<String, List<Map<String, dynamic>>>();
          for (var deck in relevantDecks) {
            final tags = List<String>.from(deck['tags']);
            // Remove the current category path to find potential subcategories
            final remainingTags =
                tags.skip(widget.categoryList.length).toList();
            if (remainingTags.isNotEmpty) {
              final subcategory = remainingTags.first;
              subcategoryGroups.putIfAbsent(subcategory, () => []).add(deck);
            }
          }

          List<Widget> children = [];

          // Create a CategoryCard for each subcategory group
          subcategoryGroups.forEach((subcategory, decks) {
            final updatedCategoryList = List<String>.from(widget.categoryList);
            children.add(CategoryCard(
              categoryList: updatedCategoryList,
              category: subcategory,
              deck: decks,
            ));
          });

          // Add DeckCards for decks without further subcategories
          final noSubcategoryDecks = relevantDecks.where((deck) {
            final remainingTags = List<String>.from(deck['tags'])
                .skip(widget.categoryList.length)
                .toList();
            return remainingTags.isEmpty;
          }).toList();
          for (var deck in noSubcategoryDecks) {
            children.add(DeckCard(deck: deck));
          }

          return ListView(children: children);
        }(),
      ),
    );
  }
}
