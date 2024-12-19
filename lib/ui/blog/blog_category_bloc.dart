import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/data/blog_repository.dart';
import 'package:learning_assistant/ui/blog/blog_category_event.dart';
import 'package:learning_assistant/ui/blog/blog_category_state.dart';

class BlogCategoryBloc extends Bloc<BlogCategoryEvent, BlogCategoryState> {
  final BlogRepository _blogRepository;

  BlogCategoryBloc(this._blogRepository) : super(BlogCategoriesLoading()) {
    on<BlogFetchCategoriesEvent>(_onFetchCategories);
    on<BlogFetchBlogsEvent>(_onFetchSubFolders);
  }

  Future<void> _onFetchCategories(
      BlogFetchCategoriesEvent event, Emitter<BlogCategoryState> emit) async {
    emit(BlogCategoriesLoading());
    try {
      final categories = await _blogRepository.getFolders();
      emit(BlogCategoriesLoaded(categories));
    } catch (e) {
      emit(BlogCategoriesError(e.toString()));
    }
  }

  Future<void> _onFetchSubFolders(
      BlogFetchBlogsEvent event, Emitter<BlogCategoryState> emit) async {
    emit(BlogCategoriesLoading());
    try {
      final subFolders = await _blogRepository.getSubFolders(event.parentPath);
      emit(BlogCategoriesLoaded(subFolders));
    } catch (e) {
      emit(BlogCategoriesError(e.toString()));
    }
  }
}
