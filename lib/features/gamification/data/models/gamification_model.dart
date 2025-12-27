import 'package:equatable/equatable.dart';

class Badge extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final DateTime? unlockedAt;
  final bool isUnlocked;
  
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    this.unlockedAt,
    required this.isUnlocked,
  });
  
  @override
  List<Object?> get props => [id, name, description, iconUrl, unlockedAt, isUnlocked];
}

class Challenge extends Equatable {
  final String id;
  final String title;
  final String description;
  final int targetValue;
  final int currentValue;
  final String category;
  final DateTime? completedAt;
  final bool isCompleted;
  final DateTime? expiresAt;
  
  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.currentValue,
    required this.category,
    this.completedAt,
    required this.isCompleted,
    this.expiresAt,
  });
  
  double get progress => targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;
  
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    targetValue,
    currentValue,
    category,
    completedAt,
    isCompleted,
    expiresAt,
  ];
}

class LeaderboardEntry extends Equatable {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int points;
  final int rank;
  
  const LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.points,
    required this.rank,
  });
  
  @override
  List<Object?> get props => [userId, userName, avatarUrl, points, rank];
}

class GamificationStats extends Equatable {
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final int badgesUnlocked;
  final int challengesCompleted;
  final int rank;
  
  const GamificationStats({
    required this.totalPoints,
    required this.currentStreak,
    required this.longestStreak,
    required this.badgesUnlocked,
    required this.challengesCompleted,
    required this.rank,
  });
  
  @override
  List<Object?> get props => [
    totalPoints,
    currentStreak,
    longestStreak,
    badgesUnlocked,
    challengesCompleted,
    rank,
  ];
}

