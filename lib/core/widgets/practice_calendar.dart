import 'package:flutter/material.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/gamification/data/services/gamification_service.dart';

/// GitHub-style Practice Calendar — shows practice days as colored squares
class PracticeCalendar extends StatelessWidget {
  const PracticeCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gamification = sl<GamificationService>();
    final today = DateTime.now();

    // Get practice dates from the last 12 weeks (84 days)
    final weeks = 12;
    final startDate = today.subtract(Duration(days: weeks * 7 - 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'Practice Calendar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const Spacer(),
            Text(
              '${gamification.currentStreak} day streak 🔥',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: gamification.currentStreak > 0 ? AppColors.success : (isDark ? Colors.white38 : Colors.grey[400]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Day labels
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 24),
            ...['', 'Mon', '', 'Wed', '', 'Fri', ''].map((d) => SizedBox(
                  width: (MediaQuery.of(context).size.width - 80) / weeks,
                  child: Text(d, style: TextStyle(fontSize: 8, color: isDark ? Colors.white24 : Colors.grey[400])),
                )),
          ],
        ),
        const SizedBox(height: 4),
        // Calendar grid
        SizedBox(
          height: 7 * 14.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(weeks, (weekIndex) {
              return Expanded(
                child: Column(
                  children: List.generate(7, (dayIndex) {
                    final date = startDate.add(Duration(days: weekIndex * 7 + dayIndex));
                    if (date.isAfter(today)) {
                      return Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.all(1.5),
                      );
                    }

                    // Check if this date was a practice day
                    final dateStr = date.toIso8601String().substring(0, 10);
                    final todayStr = today.toIso8601String().substring(0, 10);
                    final lastPractice = gamification.lastPracticeDate;

                    // Simple check: today and recent streak days are highlighted
                    final isPracticeDay = _isPracticeDay(dateStr, todayStr, lastPractice, gamification.currentStreak);
                    final isToday = dateStr == todayStr;

                    return Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        color: isPracticeDay
                            ? AppColors.success.withValues(alpha: 0.7 + (isToday ? 0.3 : 0))
                            : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[200]),
                        borderRadius: BorderRadius.circular(2),
                        border: isToday
                            ? Border.all(color: AppColors.primary, width: 1)
                            : null,
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Less', style: TextStyle(fontSize: 9, color: isDark ? Colors.white24 : Colors.grey[400])),
            const SizedBox(width: 4),
            ...List.generate(4, (i) => Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: i == 0
                        ? (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[200])
                        : AppColors.success.withValues(alpha: 0.3 + i * 0.23),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )),
            const SizedBox(width: 4),
            Text('More', style: TextStyle(fontSize: 9, color: isDark ? Colors.white24 : Colors.grey[400])),
          ],
        ),
      ],
    );
  }

  bool _isPracticeDay(String dateStr, String todayStr, String? lastPractice, int streak) {
    if (lastPractice == null) return false;

    // The last practice date and streak consecutive days before it
    final lastDate = DateTime.parse(lastPractice);
    final checkDate = DateTime.parse(dateStr);
    final diff = lastDate.difference(checkDate).inDays;

    return diff >= 0 && diff < streak;
  }
}
