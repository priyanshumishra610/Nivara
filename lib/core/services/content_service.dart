import '../errors/app_exceptions.dart';
import '../utils/logger.dart';
import '../utils/result.dart';
import 'api_service.dart';
import 'cache_service.dart';

class ContentItem {
  final String id;
  final String title;
  final String description;
  final String type;
  final String? thumbnailUrl;
  final String? contentUrl;
  final DateTime createdAt;
  final bool isDownloaded;
  
  ContentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.thumbnailUrl,
    this.contentUrl,
    required this.createdAt,
    required this.isDownloaded,
  });
}

abstract class ContentService {
  Future<Result<List<ContentItem>>> getContent(String category);
  Future<Result<ContentItem>> downloadContent(String contentId);
  Future<Result<List<ContentItem>>> getDownloadedContent();
  Future<Result<void>> deleteDownloadedContent(String contentId);
}

class ContentServiceImpl implements ContentService {
  final ApiService _apiService;
  final CacheService _cacheService;
  static const String _downloadedKey = 'downloaded_content';
  
  ContentServiceImpl(this._apiService, this._cacheService);
  
  @override
  Future<Result<List<ContentItem>>> getContent(String category) async {
    try {
      final cacheKey = 'content_$category';
      final cached = await _cacheService.get<List<dynamic>>(cacheKey);
      if (cached != null) {
        final items = cached.map((e) => _parseContentItem(e as Map<String, dynamic>)).toList();
        return Success(items);
      }
      
      final result = await _apiService.get(
        '/content',
        queryParameters: {'category': category},
      );
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as List<dynamic>;
      final items = data.map((e) => _parseContentItem(e as Map<String, dynamic>)).toList();
      
      await _cacheService.put(cacheKey, data, expiration: const Duration(hours: 24));
      
      return Success(items);
    } catch (e) {
      AppLogger.e('Failed to get content', e);
      return Failure(UnknownException('Failed to load content'));
    }
  }
  
  @override
  Future<Result<ContentItem>> downloadContent(String contentId) async {
    try {
      final result = await _apiService.get('/content/$contentId/download');
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as Map<String, dynamic>;
      final item = _parseContentItem(data);
      
      final downloaded = await getDownloadedContent();
      final items = downloaded.dataOrNull ?? [];
      items.add(item);
      await _cacheService.put(_downloadedKey, items.map((i) => i.toJson()).toList());
      
      return Success(item);
    } catch (e) {
      AppLogger.e('Failed to download content', e);
      return Failure(UnknownException('Failed to download content'));
    }
  }
  
  @override
  Future<Result<List<ContentItem>>> getDownloadedContent() async {
    try {
      final cached = await _cacheService.get<List<dynamic>>(_downloadedKey);
      if (cached == null) return Success([]);
      
      final items = cached.map((e) => _parseContentItem(e as Map<String, dynamic>)).toList();
      return Success(items);
    } catch (e) {
      AppLogger.e('Failed to get downloaded content', e);
      return Success([]);
    }
  }
  
  @override
  Future<Result<void>> deleteDownloadedContent(String contentId) async {
    try {
      final downloaded = await getDownloadedContent();
      final items = downloaded.dataOrNull ?? [];
      items.removeWhere((item) => item.id == contentId);
      await _cacheService.put(_downloadedKey, items.map((i) => i.toJson()).toList());
      return const Success(null);
    } catch (e) {
      AppLogger.e('Failed to delete downloaded content', e);
      return Failure(CacheException('Failed to delete content'));
    }
  }
  
  ContentItem _parseContentItem(Map<String, dynamic> json) => ContentItem(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    type: json['type'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String?,
    contentUrl: json['contentUrl'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    isDownloaded: json['isDownloaded'] as bool? ?? false,
  );
}

extension ContentItemExtension on ContentItem {
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type,
    'thumbnailUrl': thumbnailUrl,
    'contentUrl': contentUrl,
    'createdAt': createdAt.toIso8601String(),
    'isDownloaded': isDownloaded,
  };
}

