import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/theme/app_colors.dart';

class MoodRing extends StatelessWidget {
  final double moodValue;
  final double size;
  final double strokeWidth;
  final String? label;
  
  const MoodRing({
    required this.moodValue,
    this.size = 120,
    this.strokeWidth = 12,
    this.label,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final normalizedValue = moodValue.clamp(0.0, 10.0) / 10.0;
    final angle = 2 * math.pi * normalizedValue;
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _MoodRingPainter(
              progress: normalizedValue,
              strokeWidth: strokeWidth,
            ),
          ),
          if (label != null)
            Text(
              label!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getMoodColor(normalizedValue),
              ),
            )
          else
            Text(
              '${(normalizedValue * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getMoodColor(normalizedValue),
              ),
            ),
        ],
      ),
    );
  }
  
  Color _getMoodColor(double value) {
    if (value < 0.3) return AppColors.moodAnxious;
    if (value < 0.5) return AppColors.moodSad;
    if (value < 0.7) return AppColors.moodNeutral;
    if (value < 0.9) return AppColors.moodHappy;
    return AppColors.moodCalm;
  }
}

class _MoodRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  
  _MoodRingPainter({
    required this.progress,
    required this.strokeWidth,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final backgroundPaint = Paint()
      ..color = AppColors.border.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    final progressPaint = Paint()
      ..shader = AppColors.moodRingGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

