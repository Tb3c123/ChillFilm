import '../repositories/movie_repository.dart';

class ManageBookmarkUseCase {
  final MovieRepository repository;

  ManageBookmarkUseCase(this.repository);

  Future<void> toggleBookmark(String slug) {
    return repository.toggleBookmark(slug);
  }

  Future<List<String>> getBookmarks() {
    return repository.getBookmarks();
  }
}
