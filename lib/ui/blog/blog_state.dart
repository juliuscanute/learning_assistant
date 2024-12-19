abstract class BlogState {
  const BlogState();

  @override
  List<Object> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogLoaded extends BlogState {
  final String title;
  final String content;

  const BlogLoaded(this.title, this.content);

  @override
  List<Object> get props => [title, content];
}

class BlogError extends BlogState {
  final String message;

  const BlogError(this.message);

  @override
  List<Object> get props => [message];
}
