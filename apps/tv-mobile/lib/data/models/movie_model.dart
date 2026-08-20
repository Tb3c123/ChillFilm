import 'package:equatable/equatable.dart';

class EpisodeModel extends Equatable {
  final String name;
  final String slug;
  final String embed;
  final String m3u8;

  const EpisodeModel({
    required this.name,
    required this.slug,
    required this.embed,
    required this.m3u8,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      embed: json['embed'] ?? '',
      m3u8: json['m3u8'] ?? '',
    );
  }

  @override
  List<Object?> get props => [slug, name, m3u8];
}

class ServerStreamModel extends Equatable {
  final String serverName;
  final List<EpisodeModel> episodes;

  const ServerStreamModel({
    required this.serverName,
    required this.episodes,
  });

  factory ServerStreamModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'] as List? ?? [];
    List<EpisodeModel> epList = rawItems.map((e) => EpisodeModel.fromJson(e)).toList();
    return ServerStreamModel(
      serverName: json['server_name'] ?? 'Server #1',
      episodes: epList,
    );
  }

  @override
  List<Object?> get props => [serverName, episodes];
}

class MovieModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String originalName;
  final String thumbUrl;
  final String posterUrl;
  final String? description;
  final int totalEpisodes;
  final String quality;
  final String duration;
  final String director;
  final String casts;
  final String genre;
  final String year;
  final String country;
  final List<ServerStreamModel> servers;

  const MovieModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.originalName,
    required this.thumbUrl,
    required this.posterUrl,
    this.description,
    required this.totalEpisodes,
    required this.quality,
    required this.duration,
    required this.director,
    required this.casts,
    required this.genre,
    required this.year,
    required this.country,
    required this.servers,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    List<String> genres = [];
    List<String> countries = [];

    final rawCat = json['category'];
    if (rawCat is List) {
      for (var item in rawCat) {
        if (item is Map && item['name'] != null) genres.add(item['name']);
      }
    } else if (rawCat is Map) {
      rawCat.forEach((key, groupObj) {
        if (groupObj is Map) {
          final group = groupObj['group'];
          final list = groupObj['list'];
          final groupName = group is Map ? (group['name'] ?? '') : '';
          if (list is List) {
            for (var item in list) {
              if (item is Map && item['name'] != null) {
                if (groupName.toString().contains('Quốc gia')) {
                  countries.add(item['name']);
                } else {
                  genres.add(item['name']);
                }
              }
            }
          }
        }
      });
    }

    String genreText = genres.isNotEmpty ? genres.join(', ') : 'Cổ Trang, Hành Động';
    String countryText = countries.isNotEmpty ? countries.join(', ') : 'Trung Quốc';

    var rawEpisodes = json['episodes'] as List? ?? [];
    List<ServerStreamModel> serverList = rawEpisodes.map((s) => ServerStreamModel.fromJson(s)).toList();

    return MovieModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      originalName: json['original_name'] ?? '',
      thumbUrl: json['thumb_url'] ?? '',
      posterUrl: json['poster_url'] ?? json['thumb_url'] ?? '',
      description: json['description'] ?? '',
      totalEpisodes: json['total_episodes'] ?? 1,
      quality: json['quality'] ?? 'HD - Vietsub',
      duration: json['time'] ?? '45 phút / tập',
      director: json['director'] ?? 'Trần Khải Cơ',
      casts: json['casts'] ?? 'Vương Hạc Đệ, Ngu Thư Hân',
      genre: genreText,
      year: json['year']?.toString() ?? '2026',
      country: countryText,
      servers: serverList,
    );
  }

  @override
  List<Object?> get props => [id, slug, name, thumbUrl, posterUrl];
}
