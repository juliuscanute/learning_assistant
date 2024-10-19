import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class BlogData {
  final String? blogId;
  final String? initialTitle;
  final String? initialContent;

  BlogData({this.blogId, this.initialTitle, this.initialContent});
}

class BlogView extends StatefulWidget {
  final BlogData? blogData;

  BlogView({this.blogData});

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blogData?.initialTitle ?? 'Untitled Blog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          data: widget.blogData?.initialContent ?? '',
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
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
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
      ),
    );
  }
}
