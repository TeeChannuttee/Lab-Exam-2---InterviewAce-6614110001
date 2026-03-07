import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/history/presentation/bloc/history_bloc.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';

/// Session Comparison — compare 2 interview sessions side by side
@RoutePage()
class SessionComparisonPage extends StatefulWidget {
  const SessionComparisonPage({super.key});

  @override
  State<SessionComparisonPage> createState() => _SessionComparisonPageState();
}

class _SessionComparisonPageState extends State<SessionComparisonPage> {
  late final HistoryBloc _historyBloc;
  InterviewSession? _sessionA;
  InterviewSession? _sessionB;

  @override
  void initState() {
    super.initState();
    _historyBloc = sl<HistoryBloc>()..add(LoadHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _historyBloc,
      child: Scaffold(
        appBar: AppBar(title: Text(context.tr.compareSessions), centerTitle: true),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is! HistoryLoaded || state.sessions.length < 2) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('📊', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(context.tr.needTwoSessions,
                        style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500])),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Session Pickers
                  Row(
                    children: [
                      Expanded(child: _buildSessionPicker('Session A (Before)', _sessionA, state.sessions, (s) => setState(() => _sessionA = s), isDark, const Color(0xFFEF4444))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSessionPicker('Session B (After)', _sessionB, state.sessions, (s) => setState(() => _sessionB = s), isDark, AppColors.success)),
                    ],
                  ),

                  if (_sessionA != null && _sessionB != null) ...[
                    const SizedBox(height: 24),
                    _buildComparisonHeader(isDark),
                    const SizedBox(height: 16),
                    _buildScoreComparison(isDark),
                    const SizedBox(height: 16),
                    _buildDetailComparison(isDark),
                    const SizedBox(height: 16),
                    _buildProgressIndicator(isDark),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSessionPicker(String label, InterviewSession? selected, List<InterviewSession> sessions,
      ValueChanged<InterviewSession?> onChanged, bool isDark, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: color)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selected?.id,
              hint: Text('Select...', style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[400])),
              items: sessions.map((s) => DropdownMenuItem(
                value: s.id,
                child: Text('${s.position} (${s.totalScore?.toInt() ?? '?'}%)',
                    style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
              )).toList(),
              onChanged: (id) => onChanged(sessions.firstWhere((s) => s.id == id)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonHeader(bool isDark) {
    final scoreA = _sessionA!.totalScore ?? 0;
    final scoreB = _sessionB!.totalScore ?? 0;
    final diff = scoreB - scoreA;
    final improved = diff > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          (improved ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
          Colors.transparent,
        ]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: (improved ? AppColors.success : AppColors.error).withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(improved ? Icons.trending_up : Icons.trending_down,
              color: improved ? AppColors.success : AppColors.error, size: 28),
          const SizedBox(width: 10),
          Text(
            '${improved ? '+' : ''}${diff.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w900,
              color: improved ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: 10),
          Text(improved ? 'Improved! 🎉' : 'Needs work 💪',
              style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildScoreComparison(bool isDark) {
    final scoreA = _sessionA!.totalScore ?? 0;
    final scoreB = _sessionB!.totalScore ?? 0;

    return Row(
      children: [
        Expanded(child: _scoreCard('Before', scoreA, const Color(0xFFEF4444), isDark)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('VS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ),
        Expanded(child: _scoreCard('After', scoreB, AppColors.success, isDark)),
      ],
    );
  }

  Widget _scoreCard(String label, double score, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.1 : 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
          const SizedBox(height: 6),
          Text('${score.toInt()}%', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildDetailComparison(bool isDark) {
    final items = [
      _CompareItem('Position', _sessionA!.position, _sessionB!.position),
      _CompareItem('Company', _sessionA!.company, _sessionB!.company),
      _CompareItem('Level', _sessionA!.level, _sessionB!.level),
      _CompareItem('Questions', '${_sessionA!.questionCount}', '${_sessionB!.questionCount}'),
      _CompareItem('Type', _sessionA!.questionType, _sessionB!.questionType),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📋 Detail Comparison', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(width: 80, child: Text(item.label, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[400]))),
                Expanded(child: Text(item.valueA, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center)),
                const SizedBox(width: 10, child: Center(child: Text('→', style: TextStyle(fontSize: 12)))),
                Expanded(child: Text(item.valueB, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(bool isDark) {
    final scoreA = _sessionA!.totalScore ?? 0;
    final scoreB = _sessionB!.totalScore ?? 0;
    final diff = scoreB - scoreA;
    final improved = diff > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.blue[50],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(improved ? '🌟 Great Progress!' : '💡 Tips for Improvement',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            improved
                ? 'You improved by ${diff.toStringAsFixed(1)}%! Keep up the great work. Consistent practice is the key to interview mastery.'
                : 'Don\'t worry! Review your feedback, practice with the AI Coach, and focus on your weak areas. Every session makes you stronger.',
            style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : Colors.grey[600], height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CompareItem {
  final String label, valueA, valueB;
  const _CompareItem(this.label, this.valueA, this.valueB);
}
