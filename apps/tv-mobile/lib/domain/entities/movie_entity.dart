import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String originalName;
  final String thumbUrl;
  final String posterUrl;
  final String quality;
  final String year;
  final String genre;

  const MovieEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.originalName,
    required this.thumbUrl,
    required this.posterUrl,
    required this.quality,
    required this.year,
    required this.genre,
  });

  @override
  List<Object?> get props => [id, slug, name, thumbUrl, posterUrl, quality, year, genre];
}
