import 'package:equatable/equatable.dart';

class WatchHistoryModel extends Equatable {
  final String contentId;
  final String contentTitle;
  final String thumbnailUrl;
  final Duration watchedDuration;
  final Duration totalDuration;
  final DateTime lastWatched;
  
  const WatchHistoryModel({
    required this.contentId,
    required this.contentTitle,
    required this.thumbnailUrl,
    required this.watchedDuration,
    required this.totalDuration,
    required this.lastWatched,
  });
  
  double get progressPercentage {
    if (totalDuration.inSeconds == 0) return 0;
    return (watchedDuration.inSeconds / totalDuration.inSeconds) * 100;
  }
  
  factory WatchHistoryModel.fromJson(Map<String, dynamic> json) {
    return WatchHistoryModel(
      contentId: json['content_id'] ?? '',
      contentTitle: json['content_title'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      watchedDuration: Duration(seconds: json['watched_duration'] ?? 0),
      totalDuration: Duration(seconds: json['total_duration'] ?? 0),
      lastWatched: DateTime.parse(json['last_watched'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'content_id': contentId,
      'content_title': contentTitle,
      'thumbnail_url': thumbnailUrl,
      'watched_duration': watchedDuration.inSeconds,
      'total_duration': totalDuration.inSeconds,
      'last_watched': lastWatched.toIso8601String(),
    };
  }
  
  @override
  List<Object?> get props => [
    contentId, contentTitle, thumbnailUrl, 
    watchedDuration, totalDuration, lastWatched
  ];
}