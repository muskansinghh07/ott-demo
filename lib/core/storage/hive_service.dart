import 'package:flutter/foundation.dart' show kIsWeb;

class HiveService {
  static const String contentBox = 'content_cache';
  static const String watchHistoryBox = 'watch_history';
  static const String downloadsBox = 'downloads';
  
  // In-memory storage for web
  static final Map<String, dynamic> _webStorage = {};
  
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Web uses in-memory storage
      return;
    }
    
    // Mobile uses Hive
    // await Hive.openBox(contentBox);
    // await Hive.openBox(watchHistoryBox);
    // await Hive.openBox(downloadsBox);
  }
  
  // Content Cache
  static Future<void> cacheContent(String key, Map<String, dynamic> data) async {
    if (kIsWeb) {
      _webStorage['content_$key'] = data;
    } else {
      // final box = Hive.box(contentBox);
      // await box.put(key, data);
    }
  }
  
  static Map<String, dynamic>? getCachedContent(String key) {
    if (kIsWeb) {
      return _webStorage['content_$key'];
    } else {
      // final box = Hive.box(contentBox);
      // return box.get(key);
      return null;
    }
  }
  
  static Future<void> clearContentCache() async {
    if (kIsWeb) {
      _webStorage.removeWhere((key, value) => key.startsWith('content_'));
    } else {
      // final box = Hive.box(contentBox);
      // await box.clear();
    }
  }
  
  // Watch History
  static Future<void> saveWatchProgress(String contentId, Duration position) async {
    if (kIsWeb) {
      _webStorage['watch_$contentId'] = {
        'content_id': contentId,
        'position': position.inSeconds,
        'updated_at': DateTime.now().toIso8601String(),
      };
    } else {
      // final box = Hive.box(watchHistoryBox);
      // await box.put(contentId, {...});
    }
  }
  
  static Duration? getWatchProgress(String contentId) {
    if (kIsWeb) {
      final data = _webStorage['watch_$contentId'];
      if (data != null && data['position'] != null) {
        return Duration(seconds: data['position']);
      }
      return null;
    } else {
      // final box = Hive.box(watchHistoryBox);
      // final data = box.get(contentId);
      return null;
    }
  }
  
  static List<Map<String, dynamic>> getAllWatchHistory() {
    if (kIsWeb) {
      return _webStorage.entries
          .where((e) => e.key.startsWith('watch_'))
          .map((e) => e.value as Map<String, dynamic>)
          .toList();
    } else {
      return [];
    }
  }
  
  static Future<void> clearWatchHistory() async {
    if (kIsWeb) {
      _webStorage.removeWhere((key, value) => key.startsWith('watch_'));
    }
  }
  
  static Future<void> saveDownload(String contentId, Map<String, dynamic> data) async {
    // Not supported on web
  }
  
  static Map<String, dynamic>? getDownload(String contentId) {
    return null;
  }
  
  static List<Map<String, dynamic>> getAllDownloads() {
    return [];
  }
  
  static Future<void> deleteDownload(String contentId) async {}
  
  static Future<void> clearAllData() async {
    if (kIsWeb) {
      _webStorage.clear();
    }
  }
}