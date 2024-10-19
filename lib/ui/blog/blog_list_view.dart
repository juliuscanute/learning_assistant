import 'package:flutter/material.dart';
import 'package:learning_assistant/data/blog_repository.dart';
import 'package:learning_assistant/ui/blog/blog_view.dart';

class BlogListView extends StatelessWidget {
  final BlogRepository blogRepository;

  BlogListView({required this.blogRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: blogRepository.getBlogStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final blogs = snapshot.data ?? [];

          if (blogs.isEmpty) {
            return const Center(
              child: Text("No blogs available"),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 800 ? 4 : 1;
                double width =
                    (constraints.maxWidth - (crossAxisCount - 1) * 10) /
                        crossAxisCount;

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(blogs.length, (index) {
                    final blog = blogs[index];
                    final title = blog['title'] ?? 'Untitled';
                    final markdown = blog['markdown'] ?? '';

                    return SizedBox(
                      width: width,
                      child: Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(title),
                          trailing: const Row(
                            mainAxisSize: MainAxisSize.min,
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/blog',
                                arguments: BlogData(
                                  blogId: blog['id'],
                                  initialTitle: title,
                                  initialContent: markdown,
                                ));
                          },
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
