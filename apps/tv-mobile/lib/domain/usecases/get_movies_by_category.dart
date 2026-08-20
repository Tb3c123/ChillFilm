import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetMoviesByCategoryUseCase {
  final MovieRepository repository;

  GetMoviesByCategoryUseCase(this.repository);

  Future<List<MovieEntity>> execute(String categorySlug, {int page = 1}) {
    return repository.getMoviesByCategory(categorySlug, page: page);
  }
}
