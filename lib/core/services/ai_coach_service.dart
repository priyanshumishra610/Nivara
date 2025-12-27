import '../errors/app_exceptions.dart';
import '../utils/logger.dart';
import '../utils/result.dart';
import 'api_service.dart';
import 'cache_service.dart';

class AICoachMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? context;
  
  AICoachMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.context,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'context': context,
  };
  
  factory AICoachMessage.fromJson(Map<String, dynamic> json) => AICoachMessage(
    id: json['id'] as String,
    content: json['content'] as String,
    isUser: json['isUser'] as bool,
    timestamp: DateTime.parse(json['timestamp'] as String),
    context: json['context'] as String?,
  );
}

class GuidedSession {
  final String id;
  final String title;
  final String description;
  final String category;
  final int duration;
  final String? audioUrl;
  final List<String> steps;
  
  GuidedSession({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    this.audioUrl,
    required this.steps,
  });
}

abstract class AICoachService {
  Future<Result<AICoachMessage>> sendMessage(String message, {String? context});
  Future<Result<List<GuidedSession>>> getGuidedSessions(String category);
  Future<Result<GuidedSession>> startGuidedSession(String sessionId);
  Future<Result<void>> saveConversationHistory(List<AICoachMessage> messages);
  Future<Result<List<AICoachMessage>>> getConversationHistory();
}

class AICoachServiceImpl implements AICoachService {
  final ApiService _apiService;
  final CacheService _cacheService;
  static const String _cacheKey = 'ai_coach_history';
  
  AICoachServiceImpl(this._apiService, this._cacheService);
  
  @override
  Future<Result<AICoachMessage>> sendMessage(String message, {String? context}) async {
    try {
      final result = await _apiService.post(
        '/ai-coach/chat',
        data: {
          'message': message,
          'context': context,
        },
      );
      
      if (result.isFailure) {
        final cached = await _getCachedResponse(message);
        if (cached != null) {
          return Success(cached);
        }
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as Map<String, dynamic>;
      final response = AICoachMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: data['response'] as String? ?? 'I understand. How can I help you further?',
        isUser: false,
        timestamp: DateTime.now(),
        context: context,
      );
      
      await _saveToHistory(AICoachMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: message,
        isUser: true,
        timestamp: DateTime.now(),
        context: context,
      ));
      await _saveToHistory(response);
      
      return Success(response);
    } catch (e) {
      AppLogger.e('AI Coach error', e);
      return Failure(UnknownException('Failed to get AI response'));
    }
  }
  
  @override
  Future<Result<List<GuidedSession>>> getGuidedSessions(String category) async {
    try {
      final cacheKey = 'guided_sessions_$category';
      final cached = await _cacheService.get<List<GuidedSession>>(cacheKey);
      if (cached != null) {
        return Success(cached);
      }
      
      final result = await _apiService.get(
        '/ai-coach/guided-sessions',
        queryParameters: {'category': category},
      );
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as List<dynamic>;
      final sessions = data.map((e) => _parseGuidedSession(e as Map<String, dynamic>)).toList();
      
      await _cacheService.put(cacheKey, sessions, expiration: const Duration(hours: 24));
      
      return Success(sessions);
    } catch (e) {
      AppLogger.e('Failed to get guided sessions', e);
      return Failure(UnknownException('Failed to load guided sessions'));
    }
  }
  
  @override
  Future<Result<GuidedSession>> startGuidedSession(String sessionId) async {
    try {
      final result = await _apiService.post(
        '/ai-coach/guided-sessions/$sessionId/start',
      );
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as Map<String, dynamic>;
      return Success(_parseGuidedSession(data));
    } catch (e) {
      AppLogger.e('Failed to start guided session', e);
      return Failure(UnknownException('Failed to start session'));
    }
  }
  
  @override
  Future<Result<void>> saveConversationHistory(List<AICoachMessage> messages) async {
    try {
      final json = messages.map((m) => m.toJson()).toList();
      await _cacheService.put(_cacheKey, json, expiration: const Duration(days: 30));
      return const Success(null);
    } catch (e) {
      AppLogger.e('Failed to save conversation history', e);
      return Failure(CacheException('Failed to save history'));
    }
  }
  
  @override
  Future<Result<List<AICoachMessage>>> getConversationHistory() async {
    try {
      final cached = await _cacheService.get<List<dynamic>>(_cacheKey);
      if (cached == null) return Success([]);
      
      final messages = cached.map((e) => AICoachMessage.fromJson(e as Map<String, dynamic>)).toList();
      return Success(messages);
    } catch (e) {
      AppLogger.e('Failed to get conversation history', e);
      return Success([]);
    }
  }
  
  Future<AICoachMessage?> _getCachedResponse(String message) async {
    final history = await getConversationHistory();
    if (history.isSuccess && history.dataOrNull!.isNotEmpty) {
      return history.dataOrNull!.last;
    }
    return null;
  }
  
  Future<void> _saveToHistory(AICoachMessage message) async {
    final history = await getConversationHistory();
    final messages = history.dataOrNull ?? [];
    messages.add(message);
    await saveConversationHistory(messages);
  }
  
  GuidedSession _parseGuidedSession(Map<String, dynamic> json) => GuidedSession(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    category: json['category'] as String,
    duration: json['duration'] as int? ?? 0,
    audioUrl: json['audioUrl'] as String?,
    steps: (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  );
}

