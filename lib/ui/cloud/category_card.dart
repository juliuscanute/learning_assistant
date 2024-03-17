import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final List<String> categoryList;
  final String category;
  final List<Map<String, dynamic>> deck;

  CategoryCard(
      {required this.categoryList, required this.category, required this.deck});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(category, style: const TextStyle(fontSize: 18.0)),
        onTap: () async {
          Navigator.pushNamed(context, '/category-screen', arguments: {
            'categoryList': List<String>.from(categoryList)..add(category),
            'decks': deck,
          });
        },
      ),
    );
  }
}
