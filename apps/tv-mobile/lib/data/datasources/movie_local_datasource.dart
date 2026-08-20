import '../../core/storage/local_storage.dart';

abstract class MovieLocalDataSource {
  Future<void> saveWatchProgress(String slug, String episodeName, int positionSeconds);
  Future<Map<String, dynamic>?> getWatchProgress(String slug);
  Future<void> toggleBookmark(String slug);
  Future<List<String>> getBookmarks();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final LocalStorage localStorage;

  MovieLocalDataSourceImpl(this.localStorage);

  @override
  Future<void> saveWatchProgress(String slug, String episodeName, int positionSeconds) async {
    localStorage.saveWatchHistory(slug, episodeName, positionSeconds);
  }

  @override
  Future<Map<String, dynamic>?> getWatchProgress(String slug) async {
    return localStorage.getWatchHistory(slug);
  }

  @override
  Future<void> toggleBookmark(String slug) async {
    final bookmarks = await getBookmarks();
    if (bookmarks.contains(slug)) {
      bookmarks.remove(slug);
    } else {
      bookmarks.add(slug);
    }
    localStorage.setString('bookmarks', bookmarks.join(','));
  }

  @override
  Future<List<String>> getBookmarks() async {
    final raw = localStorage.getString('bookmarks');
    if (raw == null || raw.isEmpty) return [];
    return raw.split(',');
  }
}
