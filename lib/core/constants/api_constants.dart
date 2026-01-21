class ApiConstants {
  // Mock API Base URL - In production, this would be your actual backend
  static const String baseUrl = 'https://api.ottplatform.demo';
  
  // Auth Endpoints
  static const String loginPhone = '/auth/login/phone';
  static const String verifyOtp = '/auth/verify-otp';
  static const String loginGoogle = '/auth/login/google';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  
  // Content Endpoints
  static const String homeContent = '/content/home';
  static const String searchContent = '/content/search';
  static const String contentDetail = '/content/detail';
  static const String categories = '/content/categories';
  
  // Playback Endpoints
  static const String getPlaybackUrl = '/playback/url';
  static const String updateWatchProgress = '/playback/progress';
  static const String getWatchHistory = '/playback/history';
  
  // Subscription Endpoints
  static const String getSubscriptionStatus = '/subscription/status';
  static const String getPlans = '/subscription/plans';
  static const String verifyPurchase = '/subscription/verify';
  
  // User Endpoints
  static const String getUserProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static const String authHeader = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
}