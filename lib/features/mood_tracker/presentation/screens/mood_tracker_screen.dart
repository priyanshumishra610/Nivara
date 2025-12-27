import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/mood_ring.dart';
import '../../../../widgets/wellness_card.dart';
import '../../../../widgets/animated_button.dart';
import '../../../../widgets/streak_indicator.dart';

class MoodTrackerScreen extends ConsumerStatefulWidget {
  const MoodTrackerScreen({super.key});
  
  @override
  ConsumerState<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends ConsumerState<MoodTrackerScreen> {
  double _selectedMood = 5.0;
  
  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😢', 'label': 'Very Low', 'value': 1.0, 'color': AppColors.moodAnxious},
    {'emoji': '😔', 'label': 'Low', 'value': 3.0, 'color': AppColors.moodSad},
    {'emoji': '😐', 'label': 'Neutral', 'value': 5.0, 'color': AppColors.moodNeutral},
    {'emoji': '🙂', 'label': 'Good', 'value': 7.0, 'color': AppColors.moodHappy},
    {'emoji': '😊', 'label': 'Great', 'value': 9.0, 'color': AppColors.moodCalm},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStreakSection(context),
            const SizedBox(height: AppSpacing.lg),
            _buildMoodSelector(context),
            const SizedBox(height: AppSpacing.lg),
            _buildMoodRing(context),
            const SizedBox(height: AppSpacing.lg),
            _buildNotesSection(context),
            const SizedBox(height: AppSpacing.lg),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStreakSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StreakIndicator(
            streak: 7,
            label: 'Day Streak',
            icon: Icons.local_fire_department,
            color: AppColors.moodHappy,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: StreakIndicator(
            streak: 28,
            label: 'Total Entries',
            icon: Icons.mood,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMoodSelector(BuildContext context) {
    return WellnessCard(
      gradient: AppColors.calmGradient,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text(
            'How are you feeling?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _moods.map((mood) {
              final isSelected = (_selectedMood - mood['value'] as double).abs() < 0.5;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = mood['value'] as double;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        mood['emoji'] as String,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        mood['label'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMoodRing(BuildContext context) {
    return WellnessCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const MoodRing(
            moodValue: 7.5,
            size: 150,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Your Mood Today',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'You\'re feeling good today!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotesSection(BuildContext context) {
    return WellnessCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add a Note (Optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSaveButton(BuildContext context) {
    return AnimatedButton(
      label: 'Save Mood Entry',
      icon: Icons.check,
      gradient: AppColors.primaryGradient,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mood entry saved!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
      width: double.infinity,
    );
  }
}
