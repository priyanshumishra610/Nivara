import '../../../../core/utils/result.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/utils/logger.dart';
import '../models/gamification_model.dart';

abstract class GamificationRepository {
  Future<Result<GamificationStats>> getStats();
  Future<Result<List<Badge>>> getBadges();
  Future<Result<List<Challenge>>> getActiveChallenges();
  Future<Result<List<LeaderboardEntry>>> getLeaderboard({int limit = 10});
  Future<Result<Badge>> unlockBadge(String badgeId);
  Future<Result<Challenge>> completeChallenge(String challengeId);
}

class GamificationRepositoryImpl implements GamificationRepository {
  final ApiService _apiService;
  final CacheService _cacheService;
  
  GamificationRepositoryImpl(this._apiService, this._cacheService);
  
  @override
  Future<Result<GamificationStats>> getStats() async {
    try {
      final result = await _apiService.get('/gamification/stats');
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as Map<String, dynamic>;
      return Success(_parseStats(data));
    } catch (e) {
      AppLogger.e('Failed to get gamification stats', e);
      return Failure(UnknownException('Failed to load stats'));
    }
  }
  
  @override
  Future<Result<List<Badge>>> getBadges() async {
    try {
      final cached = await _cacheService.get<List<dynamic>>('badges');
      if (cached != null) {
        final badges = cached.map((e) => _parseBadge(e as Map<String, dynamic>)).toList();
        return Success(badges);
      }
      
      final result = await _apiService.get('/gamification/badges');
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as List<dynamic>;
      final badges = data.map((e) => _parseBadge(e as Map<String, dynamic>)).toList();
      
      await _cacheService.put('badges', data, expiration: const Duration(hours: 1));
      
      return Success(badges);
    } catch (e) {
      AppLogger.e('Failed to get badges', e);
      return Failure(UnknownException('Failed to load badges'));
    }
  }
  
  @override
  Future<Result<List<Challenge>>> getActiveChallenges() async {
    try {
      final result = await _apiService.get('/gamification/challenges/active');
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as List<dynamic>;
      final challenges = data.map((e) => _parseChallenge(e as Map<String, dynamic>)).toList();
      
      return Success(challenges);
    } catch (e) {
      AppLogger.e('Failed to get challenges', e);
      return Failure(UnknownException('Failed to load challenges'));
    }
  }
  
  @override
  Future<Result<List<LeaderboardEntry>>> getLeaderboard({int limit = 10}) async {
    try {
      final result = await _apiService.get(
        '/gamification/leaderboard',
        queryParameters: {'limit': limit},
      );
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as List<dynamic>;
      final entries = data.asMap().entries.map((e) {
        return _parseLeaderboardEntry(e.value as Map<String, dynamic>, e.key + 1);
      }).toList();
      
      return Success(entries);
    } catch (e) {
      AppLogger.e('Failed to get leaderboard', e);
      return Failure(UnknownException('Failed to load leaderboard'));
    }
  }
  
  @override
  Future<Result<Badge>> unlockBadge(String badgeId) async {
    try {
      final result = await _apiService.post('/gamification/badges/$badgeId/unlock');
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as Map<String, dynamic>;
      return Success(_parseBadge(data));
    } catch (e) {
      AppLogger.e('Failed to unlock badge', e);
      return Failure(UnknownException('Failed to unlock badge'));
    }
  }
  
  @override
  Future<Result<Challenge>> completeChallenge(String challengeId) async {
    try {
      final result = await _apiService.post('/gamification/challenges/$challengeId/complete');
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as Map<String, dynamic>;
      return Success(_parseChallenge(data));
    } catch (e) {
      AppLogger.e('Failed to complete challenge', e);
      return Failure(UnknownException('Failed to complete challenge'));
    }
  }
  
  GamificationStats _parseStats(Map<String, dynamic> json) => GamificationStats(
    totalPoints: json['totalPoints'] as int? ?? 0,
    currentStreak: json['currentStreak'] as int? ?? 0,
    longestStreak: json['longestStreak'] as int? ?? 0,
    badgesUnlocked: json['badgesUnlocked'] as int? ?? 0,
    challengesCompleted: json['challengesCompleted'] as int? ?? 0,
    rank: json['rank'] as int? ?? 0,
  );
  
  Badge _parseBadge(Map<String, dynamic> json) => Badge(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    iconUrl: json['iconUrl'] as String? ?? '',
    unlockedAt: json['unlockedAt'] != null
        ? DateTime.parse(json['unlockedAt'] as String)
        : null,
    isUnlocked: json['isUnlocked'] as bool? ?? false,
  );
  
  Challenge _parseChallenge(Map<String, dynamic> json) => Challenge(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    targetValue: json['targetValue'] as int? ?? 0,
    currentValue: json['currentValue'] as int? ?? 0,
    category: json['category'] as String? ?? '',
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'] as String)
        : null,
    isCompleted: json['isCompleted'] as bool? ?? false,
    expiresAt: json['expiresAt'] != null
        ? DateTime.parse(json['expiresAt'] as String)
        : null,
  );
  
  LeaderboardEntry _parseLeaderboardEntry(Map<String, dynamic> json, int rank) =>
      LeaderboardEntry(
    userId: json['userId'] as String,
    userName: json['userName'] as String,
    avatarUrl: json['avatarUrl'] as String?,
    points: json['points'] as int? ?? 0,
    rank: rank,
  );
}

