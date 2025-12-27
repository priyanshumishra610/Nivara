import '../../../../core/utils/result.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/utils/logger.dart';
import '../models/dashboard_model.dart';

abstract class DashboardRepository {
  Future<Result<DashboardData>> getDashboardData();
  Future<Result<List<MoodDataPoint>>> getMoodHistory({int days = 30});
  Future<Result<List<WellnessMetric>>> getWellnessMetrics();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiService _apiService;
  final CacheService _cacheService;
  static const String _cacheKey = 'dashboard_data';
  
  DashboardRepositoryImpl(this._apiService, this._cacheService);
  
  @override
  Future<Result<DashboardData>> getDashboardData() async {
    try {
      final cached = await _cacheService.get<Map<String, dynamic>>(_cacheKey);
      if (cached != null) {
        return Success(_parseDashboardData(cached));
      }
      
      final result = await _apiService.get('/dashboard');
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as Map<String, dynamic>;
      final dashboardData = _parseDashboardData(data);
      
      await _cacheService.put(_cacheKey, data, expiration: const Duration(minutes: 15));
      
      return Success(dashboardData);
    } catch (e) {
      AppLogger.e('Failed to get dashboard data', e);
      return Failure(UnknownException('Failed to load dashboard'));
    }
  }
  
  @override
  Future<Result<List<MoodDataPoint>>> getMoodHistory({int days = 30}) async {
    try {
      final result = await _apiService.get(
        '/dashboard/mood-history',
        queryParameters: {'days': days},
      );
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as List<dynamic>;
      final history = data.map((e) => _parseMoodDataPoint(e as Map<String, dynamic>)).toList();
      
      return Success(history);
    } catch (e) {
      AppLogger.e('Failed to get mood history', e);
      return Failure(UnknownException('Failed to load mood history'));
    }
  }
  
  @override
  Future<Result<List<WellnessMetric>>> getWellnessMetrics() async {
    try {
      final result = await _apiService.get('/dashboard/wellness-metrics');
      
      if (result.isFailure) {
        return Failure(result.errorOrNull!);
      }
      
      final data = result.dataOrNull!.data as List<dynamic>;
      final metrics = data.map((e) => _parseWellnessMetric(e as Map<String, dynamic>)).toList();
      
      return Success(metrics);
    } catch (e) {
      AppLogger.e('Failed to get wellness metrics', e);
      return Failure(UnknownException('Failed to load metrics'));
    }
  }
  
  DashboardData _parseDashboardData(Map<String, dynamic> json) {
    final moodHistory = (json['moodHistory'] as List<dynamic>?)
        ?.map((e) => _parseMoodDataPoint(e as Map<String, dynamic>))
        .toList() ?? [];
    
    final metrics = (json['metrics'] as List<dynamic>?)
        ?.map((e) => _parseWellnessMetric(e as Map<String, dynamic>))
        .toList() ?? [];
    
    return DashboardData(
      moodHistory: moodHistory,
      metrics: metrics,
      currentStreak: json['currentStreak'] as int? ?? 0,
      totalSessions: json['totalSessions'] as int? ?? 0,
      averageMood: (json['averageMood'] as num?)?.toDouble() ?? 0.0,
      recentAchievements: (json['recentAchievements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }
  
  MoodDataPoint _parseMoodDataPoint(Map<String, dynamic> json) => MoodDataPoint(
    date: DateTime.parse(json['date'] as String),
    moodValue: (json['moodValue'] as num).toDouble(),
    note: json['note'] as String?,
  );
  
  WellnessMetric _parseWellnessMetric(Map<String, dynamic> json) => WellnessMetric(
    id: json['id'] as String,
    name: json['name'] as String,
    value: (json['value'] as num).toDouble(),
    target: (json['target'] as num?)?.toDouble(),
    unit: json['unit'] as String? ?? '',
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}

