import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/data/blog_repository.dart';
import 'package:learning_assistant/ui/blog/blog_event.dart';
import 'package:learning_assistant/ui/blog/blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository blogRepository;

  BlogBloc(this.blogRepository) : super(BlogInitial()) {
    on<FetchBlog>(_onFetchBlog);
  }

  Future<void> _onFetchBlog(FetchBlog event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    try {
      final blogPost = await blogRepository.getBlogPostById(event.blogId);
      if (blogPost != null) {
        emit(BlogLoaded(
            blogPost['title'] ?? 'Untitled Blog', blogPost['markdown'] ?? ''));
      } else {
        emit(BlogError('Blog post not found'));
      }
    } catch (e) {
      emit(BlogError(e.toString()));
    }
  }
}
