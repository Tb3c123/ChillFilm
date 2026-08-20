import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetRecentMoviesUseCase {
  final MovieRepository repository;

  GetRecentMoviesUseCase(this.repository);

  Future<List<MovieEntity>> execute({int page = 1}) {
    return repository.getRecentMovies(page: page);
  }
}
