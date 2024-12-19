import 'package:flutter/material.dart';
import 'package:learning_assistant/ui/blog/blog_category_screen.dart';
import 'package:learning_assistant/ui/blog/blog_subfolder_screen.dart';
import 'package:learning_assistant/ui/blog/blog_view.dart';

class BlogViewNavigator extends StatefulWidget {
  const BlogViewNavigator({required this.navigatorKey, super.key});

  final GlobalKey navigatorKey;

  @override
  BlogViewNavigatorState createState() => BlogViewNavigatorState();
}

class BlogViewNavigatorState extends State<BlogViewNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return const BlogCategoryScreen();
                case '/blog-category-screen-new':
                  final Map<String, dynamic> arguments =
                      settings.arguments as Map<String, dynamic>;
                  final parentPath = arguments['parentPath'] as String;
                  final subFolders =
                      arguments['subFolders'] as List<Map<String, dynamic>>;
                  final folderId = arguments['folderId'] as String;

                  return BlogSubfolderScreen(
                    parentFolderName: folderId,
                    parentPath: parentPath,
                    subFolders: subFolders,
                  );

                case '/blog':
                  final blog = settings.arguments as BlogData;
                  return BlogView(blogData: blog);
                default:
                  return Container();
              }
            });
      },
    );
  }
}
