abstract class BlogCategoryEvent {}

class BlogFetchCategoriesEvent extends BlogCategoryEvent {}

class BlogFetchBlogsEvent extends BlogCategoryEvent {
  final String parentPath;
  final String folderId;

  BlogFetchBlogsEvent(this.parentPath, this.folderId);
}
