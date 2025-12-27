import 'dart:async';
import '../config/app_config.dart';
import '../utils/logger.dart';

class PerformanceMonitor {
  static final Map<String, Stopwatch> _timers = {};
  static final Map<String, List<Duration>> _metrics = {};
  
  static void startTimer(String key) {
    if (!AppConfig.enablePerformanceMonitoring) return;
    _timers[key] = Stopwatch()..start();
  }
  
  static void stopTimer(String key) {
    if (!AppConfig.enablePerformanceMonitoring) return;
    final timer = _timers.remove(key);
    if (timer != null) {
      timer.stop();
      final duration = timer.elapsed;
      _metrics.putIfAbsent(key, () => []).add(duration);
      
      if (duration.inMilliseconds > 100) {
        AppLogger.w('Performance: $key took ${duration.inMilliseconds}ms');
      }
    }
  }
  
  static Duration? getAverageDuration(String key) {
    final durations = _metrics[key];
    if (durations == null || durations.isEmpty) return null;
    
    final total = durations.fold<int>(
      0,
      (sum, duration) => sum + duration.inMilliseconds,
    );
    return Duration(milliseconds: total ~/ durations.length);
  }
  
  static void clearMetrics() {
    _metrics.clear();
    _timers.clear();
  }
  
  static Future<T> measureAsync<T>(
    String key,
    Future<T> Function() operation,
  ) async {
    startTimer(key);
    try {
      return await operation();
    } finally {
      stopTimer(key);
    }
  }
  
  static T measure<T>(String key, T Function() operation) {
    startTimer(key);
    try {
      return operation();
    } finally {
      stopTimer(key);
    }
  }
}

