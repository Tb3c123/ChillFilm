import '../../core/errors/failures.dart';
import '../entities/movie_entity.dart';
import '../entities/movie_detail_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getRecentMovies({int page = 1});
  Future<MovieDetailEntity> getMovieDetail(String slug);
  Future<List<MovieEntity>> searchMovies(String keyword, {int page = 1});
  Future<List<MovieEntity>> getMoviesByCategory(String categorySlug, {int page = 1});
  
  // Watch history & Bookmarks
  Future<void> saveWatchProgress(String slug, String episodeName, int positionSeconds);
  Future<Map<String, dynamic>?> getWatchProgress(String slug);
  Future<void> toggleBookmark(String slug);
  Future<List<String>> getBookmarks();
}
