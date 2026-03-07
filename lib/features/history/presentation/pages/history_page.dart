import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/core/widgets/shimmer_loading.dart';
import 'package:interview_ace/core/widgets/animated_empty_state.dart';
import 'package:interview_ace/features/history/presentation/bloc/history_bloc.dart';

@RoutePage()
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late final HistoryBloc _historyBloc;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _historyBloc = sl<HistoryBloc>()..add(LoadHistoryEvent());
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
          title: Text(context.tr.history),
          centerTitle: true,
          actions: [
            BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoaded && state.sessions.isNotEmpty) {
                  return IconButton(
                    onPressed: () => _showClearDialog(context),
                    icon: const Icon(Icons.delete_sweep_outlined),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const ShimmerLoading(itemCount: 5, itemHeight: 80);
            }

            if (state is HistoryLoaded && state.sessions.isEmpty) {
              return _buildEmptyState(isDark);
            }

            if (state is HistoryLoaded) {
              return _buildSessionList(state, isDark);
            }

            if (state is HistoryError) {
              return Center(
                child: Text(state.message,
                    style: TextStyle(color: AppColors.error)),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return AnimatedEmptyState(
      icon: Icons.history_rounded,
      title: context.tr.noSessionsYet,
      subtitle: 'Complete your first mock interview\nand it will show up here',
      actionLabel: 'Start First Interview',
      onAction: () => context.router.pushNamed('/setup-interview'),
    );
  }

  Widget _buildSessionList(HistoryLoaded state, bool isDark) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: state.sessions.length,
      itemBuilder: (context, index) {
        final session = state.sessions[index];
        final score = session.totalScore;
        final scoreColor = score != null
            ? (score >= 80
                ? AppColors.success
                : score >= 50
                    ? AppColors.warning
                    : AppColors.error)
            : Colors.grey;

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animController,
            curve: Interval(
              (index * 0.1).clamp(0, 0.5),
              ((index * 0.1) + 0.5).clamp(0, 1),
              curve: Curves.easeOutCubic,
            ),
          )),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Dismissible(
              key: Key(session.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete_outline, color: AppColors.error),
              ),
              onDismissed: (_) {
                _historyBloc.add(DeleteSessionEvent(sessionId: session.id));
              },
              child: Material(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                elevation: isDark ? 0 : 1,
                shadowColor: Colors.black12,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    _historyBloc.add(LoadSessionDetailEvent(sessionId: session.id));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'score_${session.id}',
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  scoreColor.withValues(alpha: 0.2),
                                  scoreColor.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: scoreColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                score != null ? '${score.toInt()}' : '—',
                                style: TextStyle(
                                  color: scoreColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.position,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${session.company} · ${session.level} · ${session.questionCount} Q',
                                style: TextStyle(
                                  color: isDark ? Colors.white38 : Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: isDark ? Colors.white24 : Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr.clearAllData),
        content: Text(context.tr.clearAllDialog),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.tr.cancel),
          ),
          FilledButton(
            onPressed: () {
              _historyBloc.add(ClearAllHistoryEvent());
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(context.tr.clearAllData),
          ),
        ],
      ),
    );
  }
}
