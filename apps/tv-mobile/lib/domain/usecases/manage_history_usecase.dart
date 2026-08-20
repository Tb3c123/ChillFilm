import '../repositories/movie_repository.dart';

class ManageHistoryUseCase {
  final MovieRepository repository;

  ManageHistoryUseCase(this.repository);

  Future<void> saveProgress(String slug, String episodeName, int positionSeconds) {
    return repository.saveWatchProgress(slug, episodeName, positionSeconds);
  }

  Future<Map<String, dynamic>?> getProgress(String slug) {
    return repository.getWatchProgress(slug);
  }
}
