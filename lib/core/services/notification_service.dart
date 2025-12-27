import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../errors/app_exceptions.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';

class NotificationPayload {
  final String id;
  final String title;
  final String body;
  final String? payload;
  final NotificationCategory category;
  
  NotificationPayload({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.category = NotificationCategory.general,
  });
}

enum NotificationCategory {
  general,
  moodReminder,
  therapySession,
  meditation,
  community,
  achievement,
  wellness,
}

abstract class NotificationService {
  Future<void> initialize();
  Future<void> requestPermissions();
  Future<bool> hasPermission();
  Future<void> showNotification(NotificationPayload notification);
  Future<void> scheduleNotification(
    NotificationPayload notification,
    DateTime scheduledTime,
  );
  Future<void> cancelNotification(String id);
  Future<void> cancelAllNotifications();
  Future<void> cancelByCategory(NotificationCategory category);
  Stream<NotificationResponse> get notificationStream;
}

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  bool _initialized = false;
  
  InitializationSettings get _initSettings {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    return InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
  }
  
  @override
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await _notifications.initialize(
        _initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      
      await requestPermissions();
      _initialized = true;
      AppLogger.i('Notification service initialized');
    } catch (e) {
      AppLogger.e('Failed to initialize notifications', e);
      throw CacheException('Failed to initialize notification service');
    }
  }
  
  @override
  Future<void> requestPermissions() async {
    if (AppConfig.environment.isProduction) {
      final android = AndroidFlutterLocalNotificationsPlugin();
      await android.requestNotificationsPermission();
    }
  }
  
  @override
  Future<bool> hasPermission() async {
    if (AppConfig.environment.isProduction) {
      final android = AndroidFlutterLocalNotificationsPlugin();
      return await android.areNotificationsEnabled() ?? false;
    }
    return true;
  }
  
  @override
  Future<void> showNotification(NotificationPayload notification) async {
    if (!_initialized) await initialize();
    
    final androidDetails = AndroidNotificationDetails(
      _getChannelId(notification.category),
      _getChannelName(notification.category),
      channelDescription: 'Nivara ${_getChannelName(notification.category)} notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    final iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      details,
      payload: notification.payload,
    );
  }
  
  @override
  Future<void> scheduleNotification(
    NotificationPayload notification,
    DateTime scheduledTime,
  ) async {
    if (!_initialized) await initialize();
    
    final androidDetails = AndroidNotificationDetails(
      _getChannelId(notification.category),
      _getChannelName(notification.category),
      channelDescription: 'Nivara ${_getChannelName(notification.category)} notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    final iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.zonedSchedule(
      notification.id.hashCode,
      notification.title,
      notification.body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      payload: notification.payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  
  @override
  Future<void> cancelNotification(String id) async {
    await _notifications.cancel(id.hashCode);
  }
  
  @override
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
  
  @override
  Future<void> cancelByCategory(NotificationCategory category) async {
    final pending = await _notifications.pendingNotificationRequests();
    for (final notification in pending) {
      if (notification.payload?.contains(_getChannelId(category)) ?? false) {
        await _notifications.cancel(notification.id);
      }
    }
  }
  
  @override
  Stream<NotificationResponse> get notificationStream =>
      _notifications.notificationStream;
  
  void _onNotificationTapped(NotificationResponse response) {
    AppLogger.d('Notification tapped: ${response.payload}');
  }
  
  String _getChannelId(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.moodReminder:
        return 'mood_reminders';
      case NotificationCategory.therapySession:
        return 'therapy_sessions';
      case NotificationCategory.meditation:
        return 'meditation';
      case NotificationCategory.community:
        return 'community';
      case NotificationCategory.achievement:
        return 'achievements';
      case NotificationCategory.wellness:
        return 'wellness';
      default:
        return 'general';
    }
  }
  
  String _getChannelName(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.moodReminder:
        return 'Mood Reminders';
      case NotificationCategory.therapySession:
        return 'Therapy Sessions';
      case NotificationCategory.meditation:
        return 'Meditation';
      case NotificationCategory.community:
        return 'Community';
      case NotificationCategory.achievement:
        return 'Achievements';
      case NotificationCategory.wellness:
        return 'Wellness';
      default:
        return 'General';
    }
  }
}

