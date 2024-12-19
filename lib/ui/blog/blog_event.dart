abstract class BlogEvent {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

class FetchBlog extends BlogEvent {
  final String blogId;

  const FetchBlog(this.blogId);

  @override
  List<Object> get props => [blogId];
}
