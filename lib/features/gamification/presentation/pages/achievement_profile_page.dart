import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/gamification/data/services/gamification_service.dart';
import 'dart:math' as math;

@RoutePage()
class AchievementProfilePage extends StatefulWidget {
  const AchievementProfilePage({super.key});

  @override
  State<AchievementProfilePage> createState() => _AchievementProfilePageState();
}

class _AchievementProfilePageState extends State<AchievementProfilePage>
    with SingleTickerProviderStateMixin {
  late final GamificationService _gamification;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _gamification = sl<GamificationService>();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.navSettings), centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(isDark),
            const SizedBox(height: 24),
            _buildStatsRow(isDark),
            const SizedBox(height: 24),
            _buildStreakCard(isDark),
            const SizedBox(height: 24),
            _buildBadgesSection(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic)),
      child: FadeTransition(
        opacity: _animController,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.accent.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              // Level Badge
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Lv${_gamification.level}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _gamification.levelTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_gamification.totalXP} XP',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              // XP Progress Bar
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.tr.achLevel(_gamification.level),
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
                      Text(context.tr.achLevel(_gamification.level + 1),
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _gamification.levelProgress),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 10,
                          backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            Color.lerp(AppColors.primary, AppColors.success, value)!,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_gamification.totalXP - _gamification.xpForCurrentLevel} / '
                    '${_gamification.xpForNextLevel - _gamification.xpForCurrentLevel} ${context.tr.achXpToNext}',
                    style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Row(
      children: [
        _StatCard('🏆', context.tr.achSessions, '${_gamification.totalSessions}', AppColors.primary, isDark),
        const SizedBox(width: 10),
        _StatCard('🔥', context.tr.achStreak, '${_gamification.currentStreak}d', AppColors.warning, isDark),
        const SizedBox(width: 10),
        _StatCard('⭐', context.tr.achBest, '${_gamification.bestStreak}d', AppColors.success, isDark),
        const SizedBox(width: 10),
        _StatCard('🏅', context.tr.achBadges, '${_gamification.unlockedBadges.length}', AppColors.accent, isDark),
      ],
    );
  }

  Widget _buildStreakCard(bool isDark) {
    final streak = _gamification.currentStreak;
    final fireColor = streak >= 7 ? AppColors.error : (streak >= 3 ? AppColors.warning : Colors.grey);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [fireColor.withValues(alpha: 0.12), fireColor.withValues(alpha: 0.03)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: fireColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Text('🔥', style: TextStyle(fontSize: streak > 0 ? 40 : 30)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streak > 0 ? context.tr.achDayStreak(streak) : context.tr.achStartStreak,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                Text(
                  streak > 0
                      ? context.tr.achStreakKeep
                      : context.tr.achStreakStart,
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection(bool isDark) {
    final unlockedBadges = _gamification.unlockedBadges;
    final allBadges = GamificationService.allBadges;

    // Localized badge titles & descriptions
    final localizedTitles = {
      'first_interview': context.tr.badgeFirstSteps,
      'five_sessions': context.tr.badgeGettingSerious,
      'ten_sessions': context.tr.badgeDedicated,
      'twenty_five_sessions': context.tr.badgeCommitted,
      'fifty_sessions': context.tr.badgeInterviewKing,
      'score_90': context.tr.badgeHighAchiever,
      'score_95': context.tr.badgeExcellence,
      'perfect_score': context.tr.badgePerfection,
      'streak_3': context.tr.badge3DayStreak,
      'streak_7': context.tr.badgeWeekWarrior,
      'streak_30': context.tr.badgeMonthlyMaster,
    };
    final localizedDescs = {
      'first_interview': context.tr.badgeFirstStepsDesc,
      'five_sessions': context.tr.badgeGettingSeriousDesc,
      'ten_sessions': context.tr.badgeDedicatedDesc,
      'twenty_five_sessions': context.tr.badgeCommittedDesc,
      'fifty_sessions': context.tr.badgeInterviewKingDesc,
      'score_90': context.tr.badgeHighAchieverDesc,
      'score_95': context.tr.badgeExcellenceDesc,
      'perfect_score': context.tr.badgePerfectionDesc,
      'streak_3': context.tr.badge3DayStreakDesc,
      'streak_7': context.tr.badgeWeekWarriorDesc,
      'streak_30': context.tr.badgeMonthlyMasterDesc,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr.achievements,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(context.tr.achUnlocked(unlockedBadges.length, allBadges.length),
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
        const SizedBox(height: 12),
        ...allBadges.asMap().entries.map((entry) {
          final i = entry.key;
          final badge = entry.value;
          final isUnlocked = unlockedBadges.contains(badge.id);
          final title = localizedTitles[badge.id] ?? badge.title;
          final desc = localizedDescs[badge.id] ?? badge.description;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.3, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animController,
                curve: Interval(
                  (i * 0.05 + 0.2).clamp(0, 0.8),
                  (i * 0.05 + 0.5).clamp(0.3, 1),
                  curve: Curves.easeOutCubic,
                ),
              )),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppColors.success.withValues(alpha: isDark ? 0.1 : 0.05)
                      : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[50]),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isUnlocked
                        ? AppColors.success.withValues(alpha: 0.2)
                        : (isDark ? Colors.white10 : Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      isUnlocked ? badge.emoji : '🔒',
                      style: TextStyle(fontSize: 24, color: isUnlocked ? null : Colors.grey),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isUnlocked ? null : (isDark ? Colors.white38 : Colors.grey[400]),
                              )),
                          Text(desc,
                              style: TextStyle(
                                fontSize: 12,
                                color: isUnlocked
                                    ? (isDark ? Colors.white54 : Colors.grey[600])
                                    : (isDark ? Colors.white24 : Colors.grey[300]),
                              )),
                        ],
                      ),
                    ),
                    if (isUnlocked)
                      const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatCard(this.emoji, this.label, this.value, this.color, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.12 : 0.06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}
