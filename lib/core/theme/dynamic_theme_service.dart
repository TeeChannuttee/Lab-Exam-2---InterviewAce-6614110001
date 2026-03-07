import 'package:flutter/material.dart';
import 'package:interview_ace/core/constants/app_colors.dart';

/// Dynamic Theme — changes primary color based on user's gamification level
class DynamicThemeService {
  /// Returns the accent color for a given level
  static Color accentForLevel(int level) {
    switch (level) {
      case 1: return const Color(0xFF3B82F6);  // Blue — Beginner
      case 2: return const Color(0xFF06B6D4);  // Cyan — Learner
      case 3: return const Color(0xFF10B981);  // Green — Intermediate
      case 4: return const Color(0xFF22D3EE);  // Teal — Skilled
      case 5: return const Color(0xFF8B5CF6);  // Purple — Advanced
      case 6: return const Color(0xFFEC4899);  // Pink — Expert
      case 7: return const Color(0xFFF59E0B);  // Amber — Master
      case 8: return const Color(0xFFEF4444);  // Red — Guru
      case 9: return const Color(0xFFFF6B35);  // Orange — Legend
      case 10: return const Color(0xFFFFD700); // Gold — Interview God
      default: return AppColors.primary;
    }
  }

  /// Returns gradient colors for a given level
  static List<Color> gradientForLevel(int level) {
    final primary = accentForLevel(level);
    return [primary, primary.withValues(alpha: 0.7)];
  }

  /// Returns level-specific icon
  static String emojiForLevel(int level) {
    const emojis = ['🌱', '📚', '⭐', '🎯', '🔥', '💎', '👑', '⚡', '🏆', '🧠'];
    return emojis[(level - 1).clamp(0, 9)];
  }

  /// Returns level title for a given level
  static String titleForLevel(int level) {
    const titles = ['Beginner', 'Learner', 'Intermediate', 'Skilled', 'Advanced', 'Expert', 'Master', 'Guru', 'Legend', 'Interview God'];
    return titles[(level - 1).clamp(0, 9)];
  }
}
