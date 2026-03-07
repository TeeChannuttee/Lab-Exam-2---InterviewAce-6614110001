import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/interview/domain/repositories/interview_repository.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';
import 'package:interview_ace/core/widgets/confetti_overlay.dart';
import 'dart:math' as math;

/// Interview Result Page — loads REAL session data from the database
@RoutePage()
class InterviewResultPage extends StatefulWidget {
  const InterviewResultPage({super.key});

  @override
  State<InterviewResultPage> createState() => _InterviewResultPageState();
}

class _InterviewResultPageState extends State<InterviewResultPage>
    with TickerProviderStateMixin {
  late final AnimationController _scoreAnimController;
  late final AnimationController _contentAnimController;
  late Animation<double> _scoreAnimation;

  bool _loading = true;
  InterviewSession? _session;
  List<InterviewQuestion> _questions = [];
  String? _error;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _scoreAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _contentAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scoreAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _scoreAnimController, curve: Curves.easeOutCubic),
    );

    _loadLatestSession();
  }

  Future<void> _loadLatestSession() async {
    try {
      final repo = sl<InterviewRepository>();
      final sessionsResult = await repo.getAllSessions();

      final sessions = sessionsResult.fold(
        (f) => <InterviewSession>[],
        (data) => data,
      );

      if (sessions.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'No completed sessions found.';
        });
        return;
      }

      // Get the most recent session (first in desc order)
      final latestSession = sessions.first;

      // Load questions for this session
      final questionsResult = await repo.getQuestionsForSession(latestSession.id);
      final questions = questionsResult.fold(
        (f) => <InterviewQuestion>[],
        (data) => data,
      );

      if (mounted) {
        final score = latestSession.totalScore ?? 0.0;
        _scoreAnimation = Tween<double>(begin: 0, end: score).animate(
          CurvedAnimation(parent: _scoreAnimController, curve: Curves.easeOutCubic),
        );

        setState(() {
          _session = latestSession;
          _questions = questions;
          _loading = false;
          _showConfetti = score >= 80;
        });

        _scoreAnimController.forward().then((_) {
          _contentAnimController.forward();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Failed to load results: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _scoreAnimController.dispose();
    _contentAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 40, height: 40,
                child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary)),
              const SizedBox(height: 16),
              Text('Loading results...', style: TextStyle(color: Colors.grey[500])),
            ],
          ),
        ),
      );
    }

    if (_error != null || _session == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr.interviewResult)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📊', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(_error ?? 'No data', style: TextStyle(color: Colors.grey[500])),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.router.pushNamed('/home'),
                child: Text(context.tr.backToHome),
              ),
            ],
          ),
        ),
      );
    }

    return ConfettiOverlay(
      trigger: _showConfetti,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildScoreCircle(isDark),
                const SizedBox(height: 32),
                _buildFeedbackSection(isDark),
                const SizedBox(height: 20),
                _buildStrengthsWeaknesses(isDark),
                const SizedBox(height: 20),
                _buildQuestionBreakdown(isDark),
                const SizedBox(height: 32),
                _buildActionButtons(context, isDark),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCircle(bool isDark) {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        final currentScore = _scoreAnimation.value;
        final normalizedScore = currentScore / 100;

        Color scoreColor;
        String emoji;
        String label;

        if (currentScore >= 80) {
          scoreColor = AppColors.success;
          emoji = '🌟';
          label = 'Excellent!';
        } else if (currentScore >= 60) {
          scoreColor = AppColors.warning;
          emoji = '👍';
          label = 'Good Job!';
        } else {
          scoreColor = AppColors.error;
          emoji = '💪';
          label = 'Keep Practicing!';
        }

        return Column(
          children: [
            // Session info
            Text(
              '${_session!.position} @ ${_session!.company}',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white38 : Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 180,
              height: 180,
              child: CustomPaint(
                painter: _ScoreRingPainter(
                  progress: normalizedScore,
                  color: scoreColor,
                  backgroundColor: isDark ? Colors.white10 : Colors.grey[200]!,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 28)),
                      Text(
                        '${currentScore.toInt()}',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: scoreColor,
                          height: 1,
                        ),
                      ),
                      Text(
                        'out of 100',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scoreColor,
                  ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeedbackSection(bool isDark) {
    final feedback = _session!.overallFeedback;
    if (feedback == null || feedback.isEmpty) return const SizedBox.shrink();

    return FadeTransition(
      opacity: _contentAnimController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _contentAnimController,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.white.withValues(alpha: 0.06), Colors.white.withValues(alpha: 0.02)]
                  : [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text('AI Feedback', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                feedback,
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.grey[700],
                  height: 1.6,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthsWeaknesses(bool isDark) {
    final strengths = _session!.strengths;
    final weaknesses = _session!.weaknesses;

    if ((strengths == null || strengths.isEmpty) && (weaknesses == null || weaknesses.isEmpty)) {
      return const SizedBox.shrink();
    }

    // Split comma-separated strings into lists
    final strengthList = strengths?.split(', ').where((s) => s.isNotEmpty).toList() ?? [];
    final weaknessList = weaknesses?.split(', ').where((s) => s.isNotEmpty).toList() ?? [];

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _contentAnimController,
        curve: const Interval(0.3, 1),
      ),
      child: Row(
        children: [
          if (strengthList.isNotEmpty)
            Expanded(
              child: _buildListCard(
                title: '💪 Strengths',
                items: strengthList,
                color: AppColors.success,
                isDark: isDark,
              ),
            ),
          if (strengthList.isNotEmpty && weaknessList.isNotEmpty)
            const SizedBox(width: 12),
          if (weaknessList.isNotEmpty)
            Expanded(
              child: _buildListCard(
                title: '🎯 Improve',
                items: weaknessList,
                color: AppColors.warning,
                isDark: isDark,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionBreakdown(bool isDark) {
    final scored = _questions.where((q) => q.score != null).toList();
    if (scored.isEmpty) return const SizedBox.shrink();

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _contentAnimController,
        curve: const Interval(0.4, 1),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr.perQuestionScores,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 12),
            ...scored.map((q) {
              final score = q.score!;
              final color = score >= 80
                  ? AppColors.success
                  : score >= 50
                      ? AppColors.warning
                      : AppColors.error;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('Q${q.questionNumber}',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        q.questionText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${score.toInt()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard({
    required String title,
    required List<String> items,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.1 : 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 10),
          ...items.take(5).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 5, height: 5,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item,
                          style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.grey[700],
                            fontSize: 13,
                          )),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _contentAnimController,
        curve: const Interval(0.5, 1),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.router.pushNamed('/setup-interview'),
              icon: const Icon(Icons.replay_rounded),
              label: Text(context.tr.practiceAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.router.pushNamed('/home'),
              icon: const Icon(Icons.home_outlined),
              label: Text(context.tr.backToHome),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the animated score ring
class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _ScoreRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 10.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
