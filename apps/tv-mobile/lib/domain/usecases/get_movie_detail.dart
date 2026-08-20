import '../entities/movie_detail_entity.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetailUseCase {
  final MovieRepository repository;

  GetMovieDetailUseCase(this.repository);

  Future<MovieDetailEntity> execute(String slug) {
    return repository.getMovieDetail(slug);
  }
}
