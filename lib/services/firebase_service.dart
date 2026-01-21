import 'package:flutter/foundation.dart';

/// Firebase Service - Web Compatible Mock Implementation
class FirebaseService {
  static Future<void> initialize() async {
    if (kIsWeb) {
      debugPrint('Firebase services limited on web');
      return;
    }
  }
  
  // Analytics Events
  static Future<void> logLogin(String method) async {
    debugPrint('Analytics: Login with $method');
  }
  
  static Future<void> logContentView(String contentId, String contentType) async {
    debugPrint('Analytics: Content view - $contentId');
  }
  
  static Future<void> logVideoPlay(String contentId, String title) async {
    debugPrint('Analytics: Video play - $title');
  }
  
  static Future<void> logVideoComplete(String contentId, Duration watchTime) async {
    debugPrint('Analytics: Video complete - ${watchTime.inMinutes} mins');
  }
  
  static Future<void> logSearch(String query) async {
    debugPrint('Analytics: Search - $query');
  }
  
  static Future<void> logSubscription(String plan, double price) async {
    debugPrint('Analytics: Subscription - $plan (\$$price)');
  }
  
  // Crashlytics
  static Future<void> logError(dynamic error, StackTrace? stackTrace) async {
    debugPrint('Error: $error');
  }
  
  static Future<void> setUserId(String userId) async {
    debugPrint('User ID set: $userId');
  }
  
  static Future<void> log(String message) async {
    debugPrint('Log: $message');
  }
}