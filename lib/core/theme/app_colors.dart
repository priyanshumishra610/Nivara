import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6B9F78);
  static const Color primaryDark = Color(0xFF5A8A66);
  static const Color primaryLight = Color(0xFF8FB99A);
  
  static const Color secondary = Color(0xFFA8D5BA);
  static const Color accent = Color(0xFFE8F5E9);
  
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);
  
  static const Color moodHappy = Color(0xFFFCD34D);
  static const Color moodNeutral = Color(0xFFFBBF24);
  static const Color moodSad = Color(0xFFF59E0B);
  static const Color moodAnxious = Color(0xFFEF4444);
  static const Color moodCalm = Color(0xFF6B9F78);
  
  static const Color lavender = Color(0xFFB794F6);
  static const Color peach = Color(0xFFFFB3BA);
  static const Color mint = Color(0xFFBAFFC9);
  static const Color sky = Color(0xFFBAE1FF);
  static const Color rose = Color(0xFFFFDFBA);
  
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static LinearGradient get wellnessGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mint, sky, lavender],
  );
  
  static LinearGradient get calmGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [moodCalm, primaryLight, secondary],
  );
  
  static LinearGradient get energyGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [moodHappy, rose, peach],
  );
  
  static LinearGradient get moodRingGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lavender, sky, mint, moodCalm],
  );
  
  static BoxShadow get softShadow => BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 20,
    offset: const Offset(0, 4),
  );
  
  static BoxShadow get cardShadow => BoxShadow(
    color: Colors.black.withOpacity(0.06),
    blurRadius: 15,
    offset: const Offset(0, 2),
  );
  
  static BoxShadow get floatingShadow => BoxShadow(
    color: primary.withOpacity(0.3),
    blurRadius: 25,
    offset: const Offset(0, 8),
    spreadRadius: 2,
  );
}

