import 'package:flutter/material.dart';
import 'package:learning_assistant/data/blog_repository.dart';
import 'package:learning_assistant/data/flash_card.dart';
import 'package:learning_assistant/ui/blog/blog_list_view.dart';
import 'package:learning_assistant/ui/blog/blog_view.dart';
import 'package:learning_assistant/ui/cloud/deck_screen.dart';
import 'package:learning_assistant/ui/cloud/train_view_mcq.dart';

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
                  return BlogListView(
                    blogRepository: BlogRepository(),
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
