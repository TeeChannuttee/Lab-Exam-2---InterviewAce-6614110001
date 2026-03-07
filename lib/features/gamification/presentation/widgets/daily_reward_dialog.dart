import 'package:flutter/material.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/gamification/data/services/gamification_service.dart';

/// Daily Rewards popup — shows XP earned and streak bonus
class DailyRewardDialog extends StatelessWidget {
  final int xpEarned;
  final int streakDays;
  final int bonusXP;

  const DailyRewardDialog({
    super.key,
    required this.xpEarned,
    required this.streakDays,
    required this.bonusXP,
  });

  static Future<void> showIfEligible(BuildContext context) async {
    final gamification = sl<GamificationService>();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (gamification.lastPracticeDate != today) {
      // Show daily reward!
      final streakBonus = gamification.currentStreak * 5;
      final baseXP = 10;

      await gamification.addXP(baseXP + streakBonus);

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => DailyRewardDialog(
            xpEarned: baseXP,
            streakDays: gamification.currentStreak,
            bonusXP: streakBonus,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.05),
              AppColors.accent.withValues(alpha: 0.03),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎁', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text(
              'Daily Reward!',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome back, champion!',
              style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500], fontSize: 13),
            ),
            const SizedBox(height: 20),

            // XP breakdown
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _RewardRow('📅 Daily Login', '+$xpEarned XP'),
                  if (bonusXP > 0) ...[
                    const SizedBox(height: 8),
                    _RewardRow('🔥 Streak Bonus (${streakDays}d)', '+$bonusXP XP'),
                  ],
                  const SizedBox(height: 8),
                  Divider(color: isDark ? Colors.white10 : Colors.grey[200]),
                  _RewardRow('Total', '+${xpEarned + bonusXP} XP', isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Claim Reward! 🎉', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _RewardRow(this.label, this.value, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(
          fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          fontSize: isTotal ? 14 : 13,
        )),
        Text(value, style: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          fontSize: isTotal ? 16 : 13,
        )),
      ],
    );
  }
}
