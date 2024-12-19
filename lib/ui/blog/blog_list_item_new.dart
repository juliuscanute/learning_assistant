import 'package:flutter/material.dart';
import 'package:learning_assistant/ui/blog/blog_category_bloc.dart';
import 'package:learning_assistant/ui/blog/blog_view.dart';

class BlogListItemNew extends StatelessWidget {
  final Map<String, dynamic> blog;
  final BlogCategoryBloc categoryBloc;

  BlogListItemNew({required this.blog, required this.categoryBloc});

  @override
  Widget build(BuildContext context) {
    final String markdown = blog['markdown'] ?? '';

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(blog['title'] ?? 'Untitled',
            style: const TextStyle(fontSize: 18.0)),
        subtitle: Text(
          markdown,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            '/blog',
            arguments: BlogData(blogId: blog['blogId']),
          );
        },
      ),
    );
  }
}
