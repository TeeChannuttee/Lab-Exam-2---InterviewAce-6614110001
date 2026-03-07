import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/history/presentation/bloc/history_bloc.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:io';

@RoutePage()
class AnalyticsDashboardPage extends StatefulWidget {
  const AnalyticsDashboardPage({super.key});

  @override
  State<AnalyticsDashboardPage> createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage>
    with SingleTickerProviderStateMixin {
  late final HistoryBloc _historyBloc;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _historyBloc = sl<HistoryBloc>()..add(LoadHistoryEvent());
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _historyBloc.close();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _historyBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.tr.analytics),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download_outlined),
              onPressed: () => _showExportDialog(context, isDark),
            ),
          ],
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HistoryLoaded && state.sessions.isEmpty) {
              return _buildEmptyState(isDark);
            }

            if (state is HistoryLoaded) {
              return _buildDashboard(state, isDark);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64,
              color: isDark ? Colors.white24 : Colors.grey[300]),
          const SizedBox(height: 16),
          Text(context.tr.noData,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white38 : Colors.grey[500])),
          const SizedBox(height: 6),
          Text(context.tr.noSessionsYet,
              style: TextStyle(color: isDark ? Colors.white24 : Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildDashboard(HistoryLoaded state, bool isDark) {
    final sessions = state.sessions;
    final scoredSessions = sessions.where((s) => s.totalScore != null).toList();
    final avgScore = scoredSessions.isEmpty
        ? 0.0
        : scoredSessions.map((s) => s.totalScore!).reduce((a, b) => a + b) /
            scoredSessions.length;
    final bestScore = scoredSessions.isEmpty
        ? 0.0
        : scoredSessions.map((s) => s.totalScore!).reduce(math.max);
    final totalQuestions = sessions.fold<int>(0, (sum, s) => sum + s.questionCount);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Cards
          _buildAnimated(0, _buildOverviewCards(
            totalSessions: sessions.length,
            avgScore: avgScore,
            bestScore: bestScore,
            totalQuestions: totalQuestions,
            isDark: isDark,
          )),
          const SizedBox(height: 24),

          // Score Trend Chart
          _buildAnimated(0.15, _buildSectionHeader(context.tr.anScoreTrend, context)),
          const SizedBox(height: 12),
          _buildAnimated(0.2, _buildScoreTrendChart(scoredSessions, isDark)),
          const SizedBox(height: 24),

          // Category Distribution
          _buildAnimated(0.3, _buildSectionHeader(context.tr.anQuestionTypes, context)),
          const SizedBox(height: 12),
          _buildAnimated(0.35, _buildCategoryPieChart(sessions, isDark)),
          const SizedBox(height: 24),

          // Performance by Level
          _buildAnimated(0.45, _buildSectionHeader(context.tr.anByLevel, context)),
          const SizedBox(height: 12),
          _buildAnimated(0.5, _buildLevelBarChart(sessions, isDark)),
          const SizedBox(height: 24),

          // Insights
          _buildAnimated(0.6, _buildInsightsCard(
            avgScore: avgScore,
            sessions: sessions,
            isDark: isDark,
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAnimated(double delay, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animController,
        curve: Interval(delay, (delay + 0.4).clamp(0, 1), curve: Curves.easeOutCubic),
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animController,
          curve: Interval(delay, (delay + 0.4).clamp(0, 1)),
        ),
        child: child,
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }

  Widget _buildOverviewCards({
    required int totalSessions,
    required double avgScore,
    required double bestScore,
    required int totalQuestions,
    required bool isDark,
  }) {
    return Row(
      children: [
        Expanded(child: _OverviewCard(
          label: context.tr.anSessions,
          value: '$totalSessions',
          icon: Icons.video_camera_front_outlined,
          color: AppColors.primary,
          isDark: isDark,
        )),
        const SizedBox(width: 10),
        Expanded(child: _OverviewCard(
          label: context.tr.anAvgScore,
          value: '${avgScore.toInt()}%',
          icon: Icons.trending_up_rounded,
          color: AppColors.success,
          isDark: isDark,
        )),
        const SizedBox(width: 10),
        Expanded(child: _OverviewCard(
          label: context.tr.anBest,
          value: '${bestScore.toInt()}%',
          icon: Icons.emoji_events_outlined,
          color: AppColors.warning,
          isDark: isDark,
        )),
        const SizedBox(width: 10),
        Expanded(child: _OverviewCard(
          label: context.tr.anQuestions,
          value: '$totalQuestions',
          icon: Icons.quiz_outlined,
          color: AppColors.accent,
          isDark: isDark,
        )),
      ],
    );
  }

  // ─────────── SCORE TREND (LINE CHART) ───────────
  Widget _buildScoreTrendChart(List<dynamic> scoredSessions, bool isDark) {
    if (scoredSessions.isEmpty) {
      return _buildChartPlaceholder(context.tr.anCompleteToSee, isDark);
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < scoredSessions.length; i++) {
      spots.add(FlSpot(i.toDouble(), scoredSessions[i].totalScore!));
    }

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? Colors.white10 : Colors.grey[200]!,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 25,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  '#${value.toInt() + 1}',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, p, bar, i) => FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primary,
                  strokeWidth: 2,
                  strokeColor: isDark ? Colors.grey[900]! : Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────── CATEGORY PIE CHART ───────────
  Widget _buildCategoryPieChart(List<dynamic> sessions, bool isDark) {
    final typeCounts = <String, int>{};
    for (final s in sessions) {
      final type = s.questionType ?? 'General';
      typeCounts[type] = (typeCounts[type] ?? 0) + 1;
    }

    if (typeCounts.isEmpty) {
      return _buildChartPlaceholder(context.tr.anNoCategoryData, isDark);
    }

    final colors = [AppColors.primary, AppColors.success, AppColors.accent, AppColors.warning];
    final entries = typeCounts.entries.toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 30,
                sections: entries.asMap().entries.map((e) {
                  final i = e.key;
                  final entry = e.value;
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    color: colors[i % colors.length],
                    radius: 40,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                    title: '${entry.value}',
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entries.asMap().entries.map((e) {
                final i = e.key;
                final entry = e.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.key,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${entry.value}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────── LEVEL BAR CHART ───────────
  Widget _buildLevelBarChart(List<dynamic> sessions, bool isDark) {
    final levelScores = <String, List<double>>{};
    for (final s in sessions) {
      final level = s.level ?? '-';
      if (s.totalScore != null) {
        levelScores.putIfAbsent(level, () => []);
        levelScores[level]!.add(s.totalScore!);
      }
    }

    if (levelScores.isEmpty) {
      return _buildChartPlaceholder(context.tr.anNoLevelData, isDark);
    }

    final levelAvgs = levelScores.entries.map((e) {
      final avg = e.value.reduce((a, b) => a + b) / e.value.length;
      return MapEntry(e.key, avg);
    }).toList();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? Colors.white10 : Colors.grey[200]!,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 25,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < levelAvgs.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        levelAvgs[value.toInt()].key,
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey[600],
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: levelAvgs.asMap().entries.map((e) {
            final i = e.key;
            final avg = e.value.value;
            final color = avg >= 80
                ? AppColors.success
                : avg >= 50
                    ? AppColors.warning
                    : AppColors.error;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: avg,
                  color: color,
                  width: 24,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─────────── INSIGHTS CARD ───────────
  Widget _buildInsightsCard({
    required double avgScore,
    required List<dynamic> sessions,
    required bool isDark,
  }) {
    final insights = <String>[];

    if (avgScore >= 80) {
      insights.add(context.tr.anInsightExcellent);
    } else if (avgScore >= 60) {
      insights.add(context.tr.anInsightGood);
    } else {
      insights.add(context.tr.anInsightKeep);
    }

    if (sessions.length >= 5) {
      insights.add('${sessions.length} sessions — ${context.tr.anInsightConsistent}');
    } else {
      insights.add(context.tr.anInsightMore);
    }

    insights.add(context.tr.anInsightTip);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.primary.withValues(alpha: 0.12), Colors.transparent]
              : [AppColors.primary.withValues(alpha: 0.06), Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(context.tr.anAiInsights, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          ...insights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  insight,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey[700],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder(String message, bool isDark) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(message,
            style: TextStyle(color: isDark ? Colors.white24 : Colors.grey[400])),
      ),
    );
  }

  void _showExportDialog(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(context.tr.exportData,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 20),
            _ExportOption(
              icon: Icons.description_outlined,
              title: context.tr.anExportCsv,
              subtitle: context.tr.anExportCsvSub,
              onTap: () {
                Navigator.pop(ctx);
                _exportData('csv');
              },
            ),
            const SizedBox(height: 10),
            _ExportOption(
              icon: Icons.code_outlined,
              title: context.tr.anExportJson,
              subtitle: context.tr.anExportJsonSub,
              onTap: () {
                Navigator.pop(ctx);
                _exportData('json');
              },
            ),
            const SizedBox(height: 10),
            _ExportOption(
              icon: Icons.picture_as_pdf_outlined,
              title: context.tr.shareSummary,
              subtitle: context.tr.anShareSub,
              onTap: () {
                Navigator.pop(ctx);
                final state = _historyBloc.state;
                if (state is HistoryLoaded && state.sessions.isNotEmpty) {
                  final sessions = state.sessions;
                  final scored = sessions.where((s) => s.totalScore != null);
                  final avg = scored.isNotEmpty
                      ? scored.map((s) => s.totalScore!).reduce((a, b) => a + b) / scored.length
                      : 0.0;
                  final best = scored.isNotEmpty
                      ? scored.map((s) => s.totalScore!).reduce((a, b) => a > b ? a : b)
                      : 0.0;

                  final summary = 'InterviewAce Progress Report\n'
                      '━━━━━━━━━━━━━━━━━━━\n'
                      '${context.tr.anSessions}: ${sessions.length}\n'
                      '${context.tr.anAvgScore}: ${avg.toStringAsFixed(1)}%\n'
                      '${context.tr.anBest}: ${best.toStringAsFixed(1)}%\n'
                      '━━━━━━━━━━━━━━━━━━━\n'
                      'InterviewAce';

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr.anSummaryCopied),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr.noSessionsYet),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(String format) async {
    final state = _historyBloc.state;
    if (state is! HistoryLoaded || state.sessions.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr.noSessionsYet),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
      return;
    }

    try {
      final sessions = state.sessions;
      String content;
      String filename;

      if (format == 'csv') {
        final buffer = StringBuffer();
        buffer.writeln('ID,Position,Company,Level,Type,Score,Questions,Date');
        for (final s in sessions) {
          buffer.writeln(
            '${s.id},"${s.position}","${s.company}","${s.level}","${s.questionType}",'
            '${s.totalScore?.toStringAsFixed(1) ?? "N/A"},${s.questionCount},'
            '${s.createdAt.toIso8601String()}',
          );
        }
        content = buffer.toString();
        filename = 'interview_data.csv';
      } else {
        final data = sessions.map((s) => {
          'id': s.id,
          'position': s.position,
          'company': s.company,
          'level': s.level,
          'questionType': s.questionType,
          'totalScore': s.totalScore,
          'questionCount': s.questionCount,
          'overallFeedback': s.overallFeedback,
          'strengths': s.strengths,
          'weaknesses': s.weaknesses,
          'createdAt': s.createdAt.toIso8601String(),
        }).toList();
        content = const JsonEncoder.withIndent('  ').convert(data);
        filename = 'interview_data.json';
      }

      // Write to temp directory
      final dir = Directory.systemTemp;
      final file = File('${dir.path}/$filename');
      await file.writeAsString(content);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.tr.exportData}: ${sessions.length} sessions (${format.toUpperCase()})'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.tr.anExportFailed}: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }
}

// ─────────── HELPER WIDGETS ───────────

class _OverviewCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _OverviewCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 16, color: color)),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white38 : Colors.grey[500])),
        ],
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ExportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
