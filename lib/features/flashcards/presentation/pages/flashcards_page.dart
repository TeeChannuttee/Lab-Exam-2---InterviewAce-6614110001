import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/interview/domain/repositories/interview_repository.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';
import 'dart:math' as math;

/// Flip Card Flashcards — REAL data from user's interview Q&A history
/// Shows questions user scored low on + AI ideal answers for study
@RoutePage()
class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  int _currentIndex = 0;
  bool _isFlipped = false;
  bool _loading = true;
  List<_Flashcard> _cards = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRealData();
  }

  Future<void> _loadRealData() async {
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
          _error = 'fcNoDataYet';
        });
        return;
      }

      // Collect all answered questions with AI feedback
      final flashcards = <_Flashcard>[];
      for (final session in sessions) {
        final qResult = await repo.getQuestionsForSession(session.id);
        qResult.fold((_) {}, (questions) {
          for (final q in questions) {
            if (q.answerText != null && q.answerText!.isNotEmpty) {
              final emoji = q.category == 'behavioral'
                  ? '💬'
                  : q.category == 'technical'
                      ? '💻'
                      : '🧩';
              flashcards.add(_Flashcard(
                question: q.questionText,
                answer: q.idealAnswer ?? q.feedback ?? 'Review your answer and improve based on AI feedback.',
                yourAnswer: q.answerText,
                category: q.category.isNotEmpty
                    ? '${q.category[0].toUpperCase()}${q.category.substring(1)}'
                    : 'General',
                emoji: emoji,
                score: q.score?.toInt(),
              ));
            }
          }
        });
      }

      if (flashcards.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'fcNoAnswered';
        });
        return;
      }

      // Sort by score ascending (worst first — study weak areas)
      flashcards.sort((a, b) => (a.score ?? 0).compareTo(b.score ?? 0));

      setState(() {
        _cards = flashcards;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Error loading data: $e';
      });
    }
  }

  void _nextCard() {
    if (_cards.isEmpty) return;
    setState(() {
      _isFlipped = false;
      _currentIndex = (_currentIndex + 1) % _cards.length;
    });
  }

  void _prevCard() {
    if (_cards.isEmpty) return;
    setState(() {
      _isFlipped = false;
      _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr.flashcards), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr.flashcards), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🃏', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 16),
                Text(_error == 'fcNoDataYet' ? context.tr.fcNoDataYet : _error == 'fcNoAnswered' ? context.tr.fcNoAnswered : (_error ?? context.tr.noFlashcards),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600])),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => context.router.pushNamed('/setup-interview'),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(context.tr.startInterview),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final card = _cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.flashcards),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_currentIndex + 1}/${_cards.length}',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Category + score badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(card.category,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accent)),
                ),
                if (card.score != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: (card.score! >= 70 ? AppColors.success : card.score! >= 50 ? AppColors.warning : AppColors.error)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('${context.tr.fcScore}: ${card.score}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                            color: card.score! >= 70 ? AppColors.success : card.score! >= 50 ? AppColors.warning : AppColors.error)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            // Real data badge
            Text(context.tr.fromRealHistory,
                style: TextStyle(fontSize: 10, color: isDark ? Colors.white24 : Colors.grey[400])),
            const SizedBox(height: 14),

            // Flip card
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isFlipped = !_isFlipped),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _isFlipped ? math.pi : 0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  builder: (context, angle, _) {
                    final isBack = angle > math.pi / 2;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: isBack
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(math.pi),
                              child: _buildCardBack(card, isDark),
                            )
                          : _buildCardFront(card, isDark),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tap to flip hint
            Text(
              _isFlipped ? context.tr.fcTapQuestion : context.tr.fcTapReveal,
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[400]),
            ),
            const SizedBox(height: 16),

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NavButton(icon: Icons.arrow_back_rounded, onTap: _prevCard, isDark: isDark),
                const SizedBox(width: 24),
                _NavButton(
                  icon: Icons.shuffle_rounded,
                  onTap: () => setState(() {
                    _isFlipped = false;
                    _currentIndex = math.Random().nextInt(_cards.length);
                  }),
                  isDark: isDark,
                ),
                const SizedBox(width: 24),
                _NavButton(icon: Icons.arrow_forward_rounded, onTap: _nextCard, isDark: isDark),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront(_Flashcard card, bool isDark) {
    final tr = context.tr;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.accent],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(card.emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 24),
          Text(tr.fcQuestion, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white54, letterSpacing: 2)),
          const SizedBox(height: 12),
          Text(card.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, height: 1.3),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildCardBack(_Flashcard card, bool isDark) {
    final tr = context.tr;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(color: AppColors.success.withValues(alpha: 0.15), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✅', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 12),
            Text(tr.fcIdealAnswer, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success, letterSpacing: 2)),
            const SizedBox(height: 12),
            Text(card.answer,
                style: TextStyle(fontSize: 14, height: 1.6, color: isDark ? Colors.white70 : Colors.grey[800]),
                textAlign: TextAlign.center),
            if (card.yourAnswer != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(tr.fcYourAnswer, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white24 : Colors.grey[400], letterSpacing: 1)),
                    const SizedBox(height: 6),
                    Text(card.yourAnswer!,
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500], height: 1.4),
                        textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Flashcard {
  final String question;
  final String answer;
  final String? yourAnswer;
  final String category;
  final String emoji;
  final int? score;
  const _Flashcard({required this.question, required this.answer, this.yourAnswer, required this.category, required this.emoji, this.score});
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  const _NavButton({required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDark ? Colors.white70 : Colors.grey[700]),
      ),
    );
  }
}
