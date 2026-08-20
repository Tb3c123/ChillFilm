import '../../domain/entities/movie_entity.dart';
import '../../domain/entities/movie_detail_entity.dart';
import '../../domain/entities/server_stream_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';
import '../datasources/movie_local_datasource.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  MovieEntity _mapModelToEntity(MovieModel model) {
    return MovieEntity(
      id: model.id,
      name: model.name,
      slug: model.slug,
      originalName: model.originalName,
      thumbUrl: model.thumbUrl,
      posterUrl: model.posterUrl,
      quality: model.quality,
      year: model.year,
      genre: model.genre,
    );
  }

  MovieDetailEntity _mapModelToDetailEntity(MovieModel model) {
    List<ServerStreamEntity> serverEntities = model.servers.map((serverModel) {
      List<EpisodeEntity> epEntities = serverModel.episodes.map((epModel) {
        return EpisodeEntity(
          name: epModel.name,
          slug: epModel.slug,
          embed: epModel.embed,
          m3u8: epModel.m3u8,
        );
      }).toList();

      return ServerStreamEntity(
        serverName: serverModel.serverName,
        episodes: epEntities,
      );
    }).toList();

    return MovieDetailEntity(
      id: model.id,
      name: model.name,
      slug: model.slug,
      originalName: model.originalName,
      thumbUrl: model.thumbUrl,
      posterUrl: model.posterUrl,
      description: model.description ?? '',
      totalEpisodes: model.totalEpisodes,
      duration: model.duration,
      director: model.director,
      casts: model.casts,
      genre: model.genre,
      year: model.year,
      country: model.country,
      servers: serverEntities,
    );
  }

  @override
  Future<List<MovieEntity>> getRecentMovies({int page = 1}) async {
    final models = await remoteDataSource.getRecentMovies(page: page);
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<MovieDetailEntity> getMovieDetail(String slug) async {
    final model = await remoteDataSource.getMovieDetail(slug);
    return _mapModelToDetailEntity(model);
  }

  @override
  Future<List<MovieEntity>> searchMovies(String keyword, {int page = 1}) async {
    final models = await remoteDataSource.searchMovies(keyword, page: page);
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<List<MovieEntity>> getMoviesByCategory(String categorySlug, {int page = 1}) async {
    final models = await remoteDataSource.getMoviesByCategory(categorySlug, page: page);
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<void> saveWatchProgress(String slug, String episodeName, int positionSeconds) async {
    await localDataSource.saveWatchProgress(slug, episodeName, positionSeconds);
  }

  @override
  Future<Map<String, dynamic>?> getWatchProgress(String slug) async {
    return await localDataSource.getWatchProgress(slug);
  }

  @override
  Future<void> toggleBookmark(String slug) async {
    await localDataSource.toggleBookmark(slug);
  }

  @override
  Future<List<String>> getBookmarks() async {
    return await localDataSource.getBookmarks();
  }
}
