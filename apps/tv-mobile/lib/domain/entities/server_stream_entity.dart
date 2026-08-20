import 'package:equatable/equatable.dart';

class EpisodeEntity extends Equatable {
  final String name;
  final String slug;
  final String embed;
  final String m3u8;

  const EpisodeEntity({
    required this.name,
    required this.slug,
    required this.embed,
    required this.m3u8,
  });

  @override
  List<Object?> get props => [name, slug, embed, m3u8];
}

class ServerStreamEntity extends Equatable {
  final String serverName;
  final List<EpisodeEntity> episodes;

  const ServerStreamEntity({
    required this.serverName,
    required this.episodes,
  });

  @override
  List<Object?> get props => [serverName, episodes];
}
