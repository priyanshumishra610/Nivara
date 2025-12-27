import 'package:equatable/equatable.dart';

class MoodDataPoint {
  final DateTime date;
  final double moodValue;
  final String? note;
  
  MoodDataPoint({
    required this.date,
    required this.moodValue,
    this.note,
  });
}

class WellnessMetric {
  final String id;
  final String name;
  final double value;
  final double? target;
  final String unit;
  final DateTime updatedAt;
  
  WellnessMetric({
    required this.id,
    required this.name,
    required this.value,
    this.target,
    required this.unit,
    required this.updatedAt,
  });
}

class DashboardData extends Equatable {
  final List<MoodDataPoint> moodHistory;
  final List<WellnessMetric> metrics;
  final int currentStreak;
  final int totalSessions;
  final double averageMood;
  final List<String> recentAchievements;
  
  const DashboardData({
    required this.moodHistory,
    required this.metrics,
    required this.currentStreak,
    required this.totalSessions,
    required this.averageMood,
    required this.recentAchievements,
  });
  
  @override
  List<Object?> get props => [
    moodHistory,
    metrics,
    currentStreak,
    totalSessions,
    averageMood,
    recentAchievements,
  ];
  
  DashboardData copyWith({
    List<MoodDataPoint>? moodHistory,
    List<WellnessMetric>? metrics,
    int? currentStreak,
    int? totalSessions,
    double? averageMood,
    List<String>? recentAchievements,
  }) {
    return DashboardData(
      moodHistory: moodHistory ?? this.moodHistory,
      metrics: metrics ?? this.metrics,
      currentStreak: currentStreak ?? this.currentStreak,
      totalSessions: totalSessions ?? this.totalSessions,
      averageMood: averageMood ?? this.averageMood,
      recentAchievements: recentAchievements ?? this.recentAchievements,
    );
  }
}

