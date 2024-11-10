import 'package:flutter/material.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/ui/cloud/category_card_new.dart';
import 'package:learning_assistant/di/injection_container.dart';
import 'package:learning_assistant/ui/cloud/deck_list_item_new.dart';

class CategoryScreenNew extends StatefulWidget {
  const CategoryScreenNew();

  @override
  _CategoryScreenNewState createState() => _CategoryScreenNewState();
}

class _CategoryScreenNewState extends State<CategoryScreenNew> {
  final FirebaseService _firebaseService = sl<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Decks'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.getFoldersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No folders found'));
          }

          final folders = snapshot.data ?? [];

          return LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the number of columns based on screen width
              int crossAxisCount = constraints.maxWidth > 600
                  ? 4
                  : 1; // Example breakpoint at 600px

              // Calculate the width of each child based on the number of columns
              double width =
                  (constraints.maxWidth - (crossAxisCount - 1) * 10) /
                      crossAxisCount;

              return Wrap(
                spacing: 10, // Horizontal space between items
                runSpacing: 10, // Vertical space between items
                children: List.generate(folders.length, (index) {
                  final folder = folders[index];
                  if (folder['type'] != 'card') {
                    return SizedBox(
                      width: width,
                      child: CategoryCardNew(
                        category: folder['id'],
                        parentPath: 'folder/${folder['id']}',
                        subFolders: folder['subFolders'] ?? [],
                        folderId: folder['id'],
                      ),
                    );
                  } else {
                    final leafNode = {
                      'title': folder['title'] ?? 'Untitled',
                      'deckId': folder['deckId'],
                      'videoUrl': folder['videoUrl'],
                      'mapUrl': folder['mapUrl'],
                      'type': 'card',
                      'isPublic': folder['isPublic'] ?? false,
                    };
                    return SizedBox(
                      width: width,
                      child: DeckCardNew(deck: leafNode),
                    );
                  }
                }),
              );
            },
          );
        },
      ),
    );
  }
}
