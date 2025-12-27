import 'package:equatable/equatable.dart';

class MoodTrend extends Equatable {
  final DateTime date;
  final double averageMood;
  final int entryCount;
  
  const MoodTrend({
    required this.date,
    required this.averageMood,
    required this.entryCount,
  });
  
  @override
  List<Object?> get props => [date, averageMood, entryCount];
}

class TherapyEffectiveness extends Equatable {
  final String therapistId;
  final String therapistName;
  final int sessionCount;
  final double averageRating;
  final double moodImprovement;
  final DateTime lastSession;
  
  const TherapyEffectiveness({
    required this.therapistId,
    required this.therapistName,
    required this.sessionCount,
    required this.averageRating,
    required this.moodImprovement,
    required this.lastSession,
  });
  
  @override
  List<Object?> get props => [
    therapistId,
    therapistName,
    sessionCount,
    averageRating,
    moodImprovement,
    lastSession,
  ];
}

class AppUsageStats extends Equatable {
  final int totalSessions;
  final Duration totalTimeSpent;
  final Map<String, int> featureUsage;
  final DateTime mostActiveDay;
  final int averageDailyUsage;
  
  const AppUsageStats({
    required this.totalSessions,
    required this.totalTimeSpent,
    required this.featureUsage,
    required this.mostActiveDay,
    required this.averageDailyUsage,
  });
  
  @override
  List<Object?> get props => [
    totalSessions,
    totalTimeSpent,
    featureUsage,
    mostActiveDay,
    averageDailyUsage,
  ];
}

class WellnessInsight extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  final InsightType type;
  
  const WellnessInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.type,
  });
  
  @override
  List<Object?> get props => [id, title, description, category, createdAt, type];
}

enum InsightType {
  positive,
  warning,
  neutral,
  achievement,
}

