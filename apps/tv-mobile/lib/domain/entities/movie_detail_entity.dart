import 'package:equatable/equatable.dart';
import 'server_stream_entity.dart';

class MovieDetailEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String originalName;
  final String thumbUrl;
  final String posterUrl;
  final String description;
  final int totalEpisodes;
  final String duration;
  final String director;
  final String casts;
  final String genre;
  final String year;
  final String country;
  final List<ServerStreamEntity> servers;

  const MovieDetailEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.originalName,
    required this.thumbUrl,
    required this.posterUrl,
    required this.description,
    required this.totalEpisodes,
    required this.duration,
    required this.director,
    required this.casts,
    required this.genre,
    required this.year,
    required this.country,
    required this.servers,
  });

  @override
  List<Object?> get props => [
        id,
        slug,
        name,
        originalName,
        totalEpisodes,
        duration,
        director,
        casts,
        genre,
        year,
        country,
        servers,
      ];
}
