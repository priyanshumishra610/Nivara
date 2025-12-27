import '../config/app_config.dart';
import '../utils/logger.dart';

abstract class AnalyticsService {
  void logEvent(String name, {Map<String, dynamic>? parameters});
  void logScreenView(String screenName, {Map<String, dynamic>? parameters});
  void logError(String error, {StackTrace? stackTrace, Map<String, dynamic>? parameters});
  void logUserAction(String action, {Map<String, dynamic>? parameters});
  void setUserProperty(String name, String value);
  void setUserId(String userId);
  void reset();
  void setEnabled(bool enabled);
}

class AnalyticsServiceImpl implements AnalyticsService {
  bool _enabled = AppConfig.enableAnalytics;
  String? _userId;
  final Map<String, String> _userProperties = {};
  
  @override
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }
  
  @override
  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    if (!_enabled) return;
    
    final eventData = <String, dynamic>{
      'event_name': name,
      'timestamp': DateTime.now().toIso8601String(),
      if (_userId != null) 'user_id': _userId,
      ...?parameters,
    };
    
    AppLogger.d('Analytics Event: $name', eventData);
  }
  
  @override
  void logScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    logEvent(
      'screen_view',
      parameters: {
        'screen_name': screenName,
        ...?parameters,
      },
    );
  }
  
  @override
  void logError(String error, {StackTrace? stackTrace, Map<String, dynamic>? parameters}) {
    logEvent(
      'error',
      parameters: {
        'error_message': error,
        if (stackTrace != null) 'stack_trace': stackTrace.toString(),
        ...?parameters,
      },
    );
  }
  
  @override
  void logUserAction(String action, {Map<String, dynamic>? parameters}) {
    logEvent(
      'user_action',
      parameters: {
        'action': action,
        ...?parameters,
      },
    );
  }
  
  @override
  void setUserProperty(String name, String value) {
    _userProperties[name] = value;
    AppLogger.d('Analytics User Property: $name = $value');
  }
  
  @override
  void setUserId(String userId) {
    _userId = userId;
    AppLogger.d('Analytics User ID: $userId');
  }
  
  @override
  void reset() {
    _userId = null;
    _userProperties.clear();
    AppLogger.d('Analytics reset');
  }
}

