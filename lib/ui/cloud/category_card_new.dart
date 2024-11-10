import 'package:flutter/material.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/di/injection_container.dart';

class CategoryCardNew extends StatefulWidget {
  final String parentPath;
  final List<Map<String, dynamic>> subFolders;
  final String folderId;
  final String category;

  CategoryCardNew({
    required this.parentPath,
    required this.subFolders,
    required this.folderId,
    required this.category,
  });

  @override
  _CategoryCardNewState createState() => _CategoryCardNewState();
}

class _CategoryCardNewState extends State<CategoryCardNew> {
  final FirebaseService _firebaseService = sl<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(Icons.folder, color: Theme.of(context).iconTheme.color),
        title: Text(widget.category, style: const TextStyle(fontSize: 18.0)),
        onTap: () async {
          final nextPath = '${widget.parentPath}/subfolders';
          final subFolders = await _firebaseService.getSubFolders(nextPath);
          Navigator.pushNamed(
            context,
            "/category-screen-new",
            arguments: {
              'parentPath': nextPath,
              'subFolders': subFolders,
              'folderId': widget.folderId,
            },
          );
        },
      ),
    );
  }
}
