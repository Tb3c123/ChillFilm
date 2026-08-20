import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class SearchMoviesUseCase {
  final MovieRepository repository;

  SearchMoviesUseCase(this.repository);

  Future<List<MovieEntity>> execute(String keyword, {int page = 1}) {
    return repository.searchMovies(keyword, page: page);
  }
}
