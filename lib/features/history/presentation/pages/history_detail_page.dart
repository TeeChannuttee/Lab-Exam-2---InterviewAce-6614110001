import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/features/history/presentation/bloc/history_bloc.dart';

@RoutePage()
class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.sessionDetail),
        centerTitle: true,
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryDetailLoaded) {
            return _buildDetail(state, isDark, context);
          }

          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(context.tr.noData,
                    style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetail(HistoryDetailLoaded state, bool isDark, BuildContext context) {
    final session = state.session;
    final questions = state.questions;
    final score = session.totalScore ?? 0;
    final scoreColor = score >= 80
        ? AppColors.success
        : score >= 50
            ? AppColors.warning
            : AppColors.error;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Overview Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scoreColor.withValues(alpha: 0.15),
                  scoreColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: scoreColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Hero(
                  tag: 'score_${session.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      '${score.toInt()}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: scoreColor,
                      ),
                    ),
                  ),
                ),
                Text(
                  session.position,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  '${session.company} · ${session.level}',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Feedback
          if (session.overallFeedback != null) ...[
            Text(context.tr.aiFeedback,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                session.overallFeedback!,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Questions
          Text('Questions (${questions.length})',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...questions.asMap().entries.map((entry) {
            final q = entry.value;
            final qScore = q.score ?? 0;
            final qColor = qScore >= 80
                ? AppColors.success
                : qScore >= 50
                    ? AppColors.warning
                    : AppColors.error;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: qColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${qScore.toInt()}/100',
                            style: TextStyle(
                              color: qColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Q${q.questionNumber}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white38 : Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.questionText,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (q.answerText != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        q.answerText!,
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (q.feedback != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '💬 ${q.feedback!}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
