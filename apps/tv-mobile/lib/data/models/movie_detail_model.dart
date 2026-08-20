import 'movie_model.dart';

class MovieDetailModel {
  final MovieModel movie;

  MovieDetailModel({required this.movie});

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      movie: MovieModel.fromJson(json['movie'] ?? json),
    );
  }
}
