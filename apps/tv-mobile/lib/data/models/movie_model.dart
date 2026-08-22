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
      name: (json['name'] ?? json['filename'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      embed: (json['link_embed'] ?? json['embed'] ?? '').toString(),
      m3u8: (json['link_m3u8'] ?? json['m3u8'] ?? '').toString(),
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
    var rawItems = (json['server_data'] ?? json['items'] ?? json['episodes']) as List? ?? [];
    List<EpisodeModel> epList = rawItems.map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>)).toList();
    return ServerStreamModel(
      serverName: (json['server_name'] ?? json['name'] ?? 'Server #1').toString(),
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

  factory MovieModel.fromJson(Map<String, dynamic> json, {List? episodesJson}) {
    List<String> genres = [];
    List<String> countries = [];

    final rawCat = json['category'];
    if (rawCat is List) {
      for (var item in rawCat) {
        if (item is Map && item['name'] != null) genres.add(item['name'].toString());
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
                  countries.add(item['name'].toString());
                } else {
                  genres.add(item['name'].toString());
                }
              }
            }
          }
        }
      });
    }

    String genreText = genres.isNotEmpty ? genres.join(', ') : 'Hành Động, Viễn Tưởng';
    String countryText = countries.isNotEmpty ? countries.join(', ') : 'Âu Mỹ';

    var rawEpisodes = episodesJson ?? (json['episodes'] as List? ?? []);
    List<ServerStreamModel> serverList = rawEpisodes.map((s) => ServerStreamModel.fromJson(s as Map<String, dynamic>)).toList();

    return MovieModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      originalName: (json['origin_name'] ?? json['original_name'] ?? '').toString(),
      thumbUrl: (json['thumb_url'] ?? '').toString(),
      posterUrl: (json['poster_url'] ?? json['thumb_url'] ?? '').toString(),
      description: (json['content'] ?? json['description'] ?? '').toString(),
      totalEpisodes: int.tryParse((json['episode_total'] ?? json['total_episodes'] ?? '1').toString()) ?? 1,
      quality: (json['quality'] ?? 'HD - Vietsub').toString(),
      duration: (json['time'] ?? '45 phút / tập').toString(),
      director: (json['director'] ?? 'Đang cập nhật').toString(),
      casts: (json['actor'] ?? json['casts'] ?? 'Đang cập nhật').toString(),
      genre: genreText,
      year: (json['year'] ?? '2026').toString(),
      country: countryText,
      servers: serverList,
    );
  }

  @override
  List<Object?> get props => [id, slug, name, thumbUrl, posterUrl];
}
