/// OTT Video Streaming Constants
/// 
/// This class contains configuration for adaptive bitrate streaming
/// In a production OTT platform:
/// - MPEG-DASH is primary format (better adaptation, codec flexibility)
/// - HLS is fallback for iOS devices
/// - Content is encoded at multiple resolutions for ABR
/// - CDN delivers closest server based on geo-location
class VideoConstants {
  // Supported Resolutions (Adaptive Bitrate Ladder)
  static const List<String> supportedResolutions = [
    '240p',  // 426x240,  ~400 kbps  - for slow connections
    '360p',  // 640x360,  ~800 kbps  - for mobile data
    '480p',  // 854x480,  ~1.2 Mbps  - SD quality
    '720p',  // 1280x720, ~2.5 Mbps  - HD quality
    '1080p', // 1920x1080,~5.0 Mbps  - Full HD
  ];
  
  // Video Codec: H.264 (AVC) - widely supported
  // Audio Codec: AAC - standard for streaming
  static const String videoCodec = 'H.264';
  static const String audioCodec = 'AAC';
  
  // Streaming Protocols
  static const String dashProtocol = 'MPEG-DASH';
  static const String hlsProtocol = 'HLS';
  
  // Sample DASH URLs (Big Buck Bunny test content)
  static const String sampleDashUrl = 
      'https://dash.akamaized.net/akamai/bbb_30fps/bbb_30fps.mpd';
  
  // Sample HLS URL (fallback)
  static const String sampleHlsUrl = 
      'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';
  
  // DRM Configuration (Widevine for Android, FairPlay for iOS)
  // In production, each video URL would include DRM license server
  static const String widevineLicenseUrl = 'https://widevine.license.server/';
  static const String fairplayLicenseUrl = 'https://fairplay.license.server/';
  
  // Buffer Configuration
  static const Duration minBufferDuration = Duration(seconds: 10);
  static const Duration maxBufferDuration = Duration(seconds: 30);
  
  // Playback
  static const Duration seekInterval = Duration(seconds: 10);
  static const Duration saveProgressInterval = Duration(seconds: 5);
  
  // Quality Selection
  static const String autoQuality = 'auto';
  
  /// Generates a mock signed playback URL
  /// In production, backend signs URLs with:
  /// - Expiry timestamp
  /// - User authentication token
  /// - DRM license token
  /// - CDN signature
  static String generateSignedUrl(String contentId, String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final signature = 'mock_sig_${contentId}_${userId}_$timestamp';
    return '$sampleDashUrl?token=$signature&exp=$timestamp';
  }
}