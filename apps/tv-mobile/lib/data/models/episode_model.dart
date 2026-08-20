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

  Map<String, dynamic> toJson() => {
        'name': name,
        'slug': slug,
        'embed': embed,
        'm3u8': m3u8,
      };

  @override
  List<Object?> get props => [name, slug, embed, m3u8];
}
