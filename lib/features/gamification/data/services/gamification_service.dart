import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math' as math;

/// Gamification Service — Badges, Streak, Level, XP
class GamificationService {
  static const _boxName = 'gamification';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  // ─────────── XP & LEVEL ───────────

  int get totalXP => _box.get('totalXP', defaultValue: 0);

  int get level {
    final xp = totalXP;
    if (xp >= 5000) return 10;
    if (xp >= 3500) return 9;
    if (xp >= 2500) return 8;
    if (xp >= 1800) return 7;
    if (xp >= 1200) return 6;
    if (xp >= 800) return 5;
    if (xp >= 500) return 4;
    if (xp >= 300) return 3;
    if (xp >= 150) return 2;
    return 1;
  }

  String get levelTitle {
    switch (level) {
      case 1: return 'Beginner';
      case 2: return 'Learner';
      case 3: return 'Practitioner';
      case 4: return 'Skilled';
      case 5: return 'Advanced';
      case 6: return 'Expert';
      case 7: return 'Master';
      case 8: return 'Guru';
      case 9: return 'Legend';
      case 10: return 'Interview God';
      default: return 'Beginner';
    }
  }

  int get xpForNextLevel {
    switch (level) {
      case 1: return 150;
      case 2: return 300;
      case 3: return 500;
      case 4: return 800;
      case 5: return 1200;
      case 6: return 1800;
      case 7: return 2500;
      case 8: return 3500;
      case 9: return 5000;
      default: return 5000;
    }
  }

  int get xpForCurrentLevel {
    switch (level) {
      case 1: return 0;
      case 2: return 150;
      case 3: return 300;
      case 4: return 500;
      case 5: return 800;
      case 6: return 1200;
      case 7: return 1800;
      case 8: return 2500;
      case 9: return 3500;
      default: return 5000;
    }
  }

  double get levelProgress {
    final range = xpForNextLevel - xpForCurrentLevel;
    if (range <= 0) return 1.0;
    return ((totalXP - xpForCurrentLevel) / range).clamp(0.0, 1.0);
  }

  Future<void> addXP(int xp) async {
    await _box.put('totalXP', totalXP + xp);
  }

  // ─────────── STREAK ───────────

  int get currentStreak => _box.get('currentStreak', defaultValue: 0);
  int get bestStreak => _box.get('bestStreak', defaultValue: 0);

  String? get lastPracticeDate => _box.get('lastPracticeDate');

  Future<void> recordPractice() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = lastPracticeDate;

    if (lastDate == today) return; // Already practiced today

    final yesterday = DateTime.now().subtract(const Duration(days: 1))
        .toIso8601String().substring(0, 10);

    int newStreak;
    if (lastDate == yesterday) {
      newStreak = currentStreak + 1;
    } else {
      newStreak = 1;
    }

    await _box.put('currentStreak', newStreak);
    await _box.put('lastPracticeDate', today);

    if (newStreak > bestStreak) {
      await _box.put('bestStreak', newStreak);
    }

    // XP for daily practice
    await addXP(25);
  }

  // ─────────── BADGES ───────────

  List<String> get unlockedBadges {
    return List<String>.from(_box.get('unlockedBadges', defaultValue: <String>[]));
  }

  Future<void> unlockBadge(String badgeId) async {
    final badges = unlockedBadges;
    if (!badges.contains(badgeId)) {
      badges.add(badgeId);
      await _box.put('unlockedBadges', badges);
      await addXP(50); // XP for badge
    }
  }

  int get totalSessions => _box.get('totalSessions', defaultValue: 0);

  Future<void> recordSession({required double score}) async {
    final sessions = totalSessions + 1;
    await _box.put('totalSessions', sessions);
    await recordPractice();

    // XP for completing session
    await addXP(50 + (score * 0.5).toInt());

    // Check badge unlocks
    if (sessions >= 1) await unlockBadge('first_interview');
    if (sessions >= 5) await unlockBadge('five_sessions');
    if (sessions >= 10) await unlockBadge('ten_sessions');
    if (sessions >= 25) await unlockBadge('twenty_five_sessions');
    if (sessions >= 50) await unlockBadge('fifty_sessions');
    if (score >= 90) await unlockBadge('score_90');
    if (score >= 95) await unlockBadge('score_95');
    if (score == 100) await unlockBadge('perfect_score');
    if (currentStreak >= 3) await unlockBadge('streak_3');
    if (currentStreak >= 7) await unlockBadge('streak_7');
    if (currentStreak >= 30) await unlockBadge('streak_30');
  }

  static List<BadgeInfo> get allBadges => [
    BadgeInfo('first_interview', '🎯', 'First Steps', 'Complete your first interview'),
    BadgeInfo('five_sessions', '⭐', 'Getting Serious', 'Complete 5 interviews'),
    BadgeInfo('ten_sessions', '🔥', 'Dedicated', 'Complete 10 interviews'),
    BadgeInfo('twenty_five_sessions', '💎', 'Committed', 'Complete 25 interviews'),
    BadgeInfo('fifty_sessions', '👑', 'Interview King', 'Complete 50 interviews'),
    BadgeInfo('score_90', '🏅', 'High Achiever', 'Score 90% or higher'),
    BadgeInfo('score_95', '🏆', 'Excellence', 'Score 95% or higher'),
    BadgeInfo('perfect_score', '💯', 'Perfection', 'Achieve a perfect score'),
    BadgeInfo('streak_3', '🔥', '3-Day Streak', 'Practice 3 days in a row'),
    BadgeInfo('streak_7', '⚡', 'Week Warrior', 'Practice 7 days in a row'),
    BadgeInfo('streak_30', '🌟', 'Monthly Master', 'Practice 30 days in a row'),
  ];
}

class BadgeInfo {
  final String id;
  final String emoji;
  final String title;
  final String description;

  const BadgeInfo(this.id, this.emoji, this.title, this.description);
}
