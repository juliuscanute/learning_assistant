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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            child: SizedBox(
              height: 56.0,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Search here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Icon(Icons.search, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _firebaseService.getFoldersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No folders found'));
                }

                final folders = snapshot.data
                        ?.where((folder) => folder['isPublic'] == true)
                        .toList() ??
                    [];

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

                    return SingleChildScrollView(
                      child: Wrap(
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
