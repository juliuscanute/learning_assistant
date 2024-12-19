abstract class BlogCategoryState {}

class BlogCategoriesLoading extends BlogCategoryState {}

class BlogCategoriesLoaded extends BlogCategoryState {
  final List<Map<String, dynamic>> categories;

  BlogCategoriesLoaded(this.categories);
}

class BlogCategoriesError extends BlogCategoryState {
  final String error;

  BlogCategoriesError(this.error);
}
