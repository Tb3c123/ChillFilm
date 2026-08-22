import 'package:dio/dio.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getRecentMovies({int page = 1});
  Future<MovieModel> getMovieDetail(String slug);
  Future<List<MovieModel>> searchMovies(String keyword, {int page = 1});
  Future<List<MovieModel>> getMoviesByCategory(String categorySlug, {int page = 1});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient apiClient;

  MovieRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<MovieModel>> getRecentMovies({int page = 1}) async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.recentMovies(page));
      if (response.statusCode == 200 && response.data != null) {
        final List items = response.data['items'] ?? [];
        return items.map((e) => MovieModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw ServerException('Lỗi phản hồi dữ liệu API');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Lỗi mạng kết nối API');
    }
  }

  @override
  Future<MovieModel> getMovieDetail(String slug) async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.filmDetail(slug));
      if (response.statusCode == 200 && response.data != null && response.data['movie'] != null) {
        final movieJson = response.data['movie'] as Map<String, dynamic>;
        final episodesJson = response.data['episodes'] as List?;
        return MovieModel.fromJson(movieJson, episodesJson: episodesJson);
      }
      throw ServerException('Không tìm thấy chi tiết phim $slug');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Lỗi kết nối máy chủ');
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String keyword, {int page = 1}) async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.searchMovies(keyword, page));
      if (response.statusCode == 200 && response.data != null) {
        final List items = response.data['items'] ?? [];
        return items.map((e) => MovieModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Lỗi tìm kiếm phim');
    }
  }

  @override
  Future<List<MovieModel>> getMoviesByCategory(String categorySlug, {int page = 1}) async {
    try {
      final response = await apiClient.dio.get('/films/danh-sach/$categorySlug?page=$page');
      if (response.statusCode == 200 && response.data != null) {
        final List items = response.data['items'] ?? [];
        return items.map((e) => MovieModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Lỗi danh mục phim');
    }
  }
}
