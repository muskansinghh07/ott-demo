import 'package:equatable/equatable.dart';

class ContentModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String bannerUrl;
  final ContentType type;
  final List<String> genres;
  final double rating;
  final int releaseYear;
  final Duration? duration;
  final List<Season>? seasons; // For series
  final bool isPremium;
  
  const ContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.bannerUrl,
    required this.type,
    required this.genres,
    required this.rating,
    required this.releaseYear,
    this.duration,
    this.seasons,
    this.isPremium = false,
  });
  
  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      bannerUrl: json['banner_url'] ?? '',
      type: ContentType.values.firstWhere(
        (e) => e.toString() == 'ContentType.${json['type']}',
        orElse: () => ContentType.movie,
      ),
      genres: List<String>.from(json['genres'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      releaseYear: json['release_year'] ?? 0,
      duration: json['duration'] != null 
          ? Duration(seconds: json['duration']) 
          : null,
      seasons: json['seasons'] != null
          ? (json['seasons'] as List).map((s) => Season.fromJson(s)).toList()
          : null,
      isPremium: json['is_premium'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'banner_url': bannerUrl,
      'type': type.toString().split('.').last,
      'genres': genres,
      'rating': rating,
      'release_year': releaseYear,
      'duration': duration?.inSeconds,
      'seasons': seasons?.map((s) => s.toJson()).toList(),
      'is_premium': isPremium,
    };
  }
  
  @override
  List<Object?> get props => [
    id, title, description, thumbnailUrl, bannerUrl, 
    type, genres, rating, releaseYear, duration, seasons, isPremium
  ];
}

enum ContentType { movie, series, documentary, kids }

class Season extends Equatable {
  final int seasonNumber;
  final List<Episode> episodes;
  
  const Season({
    required this.seasonNumber,
    required this.episodes,
  });
  
  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonNumber: json['season_number'] ?? 1,
      episodes: (json['episodes'] as List)
          .map((e) => Episode.fromJson(e))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'season_number': seasonNumber,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
  
  @override
  List<Object?> get props => [seasonNumber, episodes];
}

class Episode extends Equatable {
  final String id;
  final int episodeNumber;
  final String title;
  final String description;
  final String thumbnailUrl;
  final Duration duration;
  
  const Episode({
    required this.id,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.duration,
  });
  
  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? '',
      episodeNumber: json['episode_number'] ?? 1,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      duration: Duration(seconds: json['duration'] ?? 0),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'episode_number': episodeNumber,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'duration': duration.inSeconds,
    };
  }
  
  @override
  List<Object?> get props => [id, episodeNumber, title, description, thumbnailUrl, duration];
}