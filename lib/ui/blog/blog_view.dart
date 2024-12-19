import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:learning_assistant/di/injection_container.dart';
import 'package:learning_assistant/ui/blog/blog_bloc.dart';
import 'package:learning_assistant/ui/blog/blog_event.dart';
import 'package:learning_assistant/ui/blog/blog_state.dart';

class BlogData {
  final String? blogId;

  BlogData({this.blogId});
}

class BlogView extends StatefulWidget {
  final BlogData? blogData;

  BlogView({this.blogData});

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  late BlogBloc _blogBloc;

  @override
  void initState() {
    super.initState();
    _blogBloc = sl<BlogBloc>();
    if (widget.blogData?.blogId != null) {
      _blogBloc.add(FetchBlog(widget.blogData!.blogId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<BlogBloc, BlogState>(
          bloc: _blogBloc,
          builder: (context, state) {
            if (state is BlogLoaded) {
              return Text(state.title);
            } else {
              return const Text('Loading...');
            }
          },
        ),
      ),
      body: BlocBuilder<BlogBloc, BlogState>(
        bloc: _blogBloc,
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BlogLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Markdown(
                data: state.content,
                selectable: true,
                imageBuilder: (uri, title, alt) {
                  print("Image URI: $uri");
                  String modifiedUri = uri
                      .toString()
                      .replaceFirst("blob:", "")
                      .replaceFirst('blog_images/', 'blog_images%2F');
                  return Image.network(
                    modifiedUri,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(height: 8),
                            Text('Failed to load image',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is BlogError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No blog data available.'));
          }
        },
      ),
    );
  }
}
