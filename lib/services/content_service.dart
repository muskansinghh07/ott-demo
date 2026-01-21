import '../core/storage/hive_service.dart';
import '../models/content_model.dart';

class ContentService {
  /// Get home page content with mock data
  Future<Map<String, dynamic>> getHomeContent({bool forceRefresh = false}) async {
    try {
      // Check cache first
      if (!forceRefresh) {
        final cached = HiveService.getCachedContent('home_content');
        if (cached != null) {
          return _parseHomeData(cached);
        }
      }
      
      // Mock API call - replace with actual endpoint in production
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockData = _getMockHomeData();
      await HiveService.cacheContent('home_content', mockData);
      
      return _parseHomeData(mockData);
    } catch (e) {
      throw Exception('Failed to load home content: $e');
    }
  }
  
  Map<String, dynamic> _parseHomeData(Map<String, dynamic> data) {
    return {
      'featured': (data['featured'] as List?)
          ?.map((e) => ContentModel.fromJson(e))
          .toList() ?? [],
      'categories': (data['categories'] as Map?)?.map(
        (key, value) => MapEntry(
          key.toString(),
          (value as List).map((e) => ContentModel.fromJson(e)).toList(),
        ),
      ) ?? {},
    };
  }
  
  /// Search content with debounce
  Future<List<ContentModel>> searchContent(String query, {int page = 1}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock search results
      final allContent = _getAllMockContent();
      final filtered = allContent.where((content) =>
        content.title.toLowerCase().contains(query.toLowerCase()) ||
        content.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
      final startIndex = (page - 1) * 20;
      final endIndex = startIndex + 20;
      
      return filtered.sublist(
        startIndex,
        endIndex > filtered.length ? filtered.length : endIndex,
      );
    } catch (e) {
      throw Exception('Failed to search content: $e');
    }
  }
  
  /// Get content details
  Future<ContentModel> getContentDetail(String contentId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _getAllMockContent().firstWhere((c) => c.id == contentId);
    } catch (e) {
      throw Exception('Failed to load content detail: $e');
    }
  }
  
  // Mock data generators
  Map<String, dynamic> _getMockHomeData() {
    return {
      'featured': [
        _createMockContent('1', 'Stranger Things', ContentType.series, isPremium: true),
        _createMockContent('2', 'The Witcher', ContentType.series),
        _createMockContent('3', 'Breaking Bad', ContentType.series, isPremium: true),
      ].map((e) => e.toJson()).toList(),
      'categories': {
        'Trending Now': [
          _createMockContent('4', 'Money Heist', ContentType.series),
          _createMockContent('5', 'Dark', ContentType.series),
        ].map((e) => e.toJson()).toList(),
        'Action': [
          _createMockContent('6', 'The Dark Knight', ContentType.movie),
          _createMockContent('7', 'John Wick', ContentType.movie),
        ].map((e) => e.toJson()).toList(),
        'Drama': [
          _createMockContent('8', 'The Shawshank Redemption', ContentType.movie),
          _createMockContent('9', 'Forrest Gump', ContentType.movie),
        ].map((e) => e.toJson()).toList(),
      },
    };
  }
  
  List<ContentModel> _getAllMockContent() {
    return [
      _createMockContent('1', 'Stranger Things', ContentType.series, isPremium: true),
      _createMockContent('2', 'The Witcher', ContentType.series),
      _createMockContent('3', 'Breaking Bad', ContentType.series, isPremium: true),
      _createMockContent('4', 'Money Heist', ContentType.series),
      _createMockContent('5', 'Dark', ContentType.series),
      _createMockContent('6', 'The Dark Knight', ContentType.movie),
      _createMockContent('7', 'John Wick', ContentType.movie),
      _createMockContent('8', 'The Shawshank Redemption', ContentType.movie),
      _createMockContent('9', 'Forrest Gump', ContentType.movie),
      _createMockContent('10', 'Inception', ContentType.movie, isPremium: true),
    ];
  }
  
  ContentModel _createMockContent(String id, String title, ContentType type, {bool isPremium = false}) {
    final episodeId = '${id}_s1_e1'; // Fixed: removed string interpolation
    
    return ContentModel(
      id: id,
      title: title,
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      thumbnailUrl: 'https://via.placeholder.com/300x450',
      bannerUrl: 'https://via.placeholder.com/1920x1080',
      type: type,
      genres: const ['Action', 'Drama'],
      rating: 4.5,
      releaseYear: 2023,
      duration: type == ContentType.movie ? const Duration(hours: 2) : null,
      isPremium: isPremium,
      seasons: type == ContentType.series ? [
        Season(seasonNumber: 1, episodes: [
          Episode(
            id: episodeId,
            episodeNumber: 1,
            title: 'Pilot',
            description: 'The beginning',
            thumbnailUrl: 'https://via.placeholder.com/300x169',
            duration: const Duration(minutes: 45),
          ),
        ]),
      ] : null,
    );
  }
}