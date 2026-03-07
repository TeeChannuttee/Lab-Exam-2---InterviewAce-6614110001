import 'dart:convert';
import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/interview/presentation/bloc/interview_bloc.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';

@RoutePage()
class InterviewSessionPage extends StatefulWidget {
  const InterviewSessionPage({super.key});

  @override
  State<InterviewSessionPage> createState() => _InterviewSessionPageState();
}

class _InterviewSessionPageState extends State<InterviewSessionPage>
    with TickerProviderStateMixin {
  final _answerController = TextEditingController();
  late final AnimationController _cardAnimController;
  late final InterviewBloc _interviewBloc;

  @override
  void initState() {
    super.initState();
    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _interviewBloc = sl<InterviewBloc>();

    // Read setup params from route arguments (passed from SetupInterviewPage)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      
      // Read language from args or fallback to SettingsBloc
      final settingsLang = context.read<SettingsBloc>().state.language;
      final lang = (args['language'] as String?)?.isNotEmpty == true 
          ? args['language'] as String 
          : settingsLang;
      
      final position = args['position'] as String? ?? 'Software Developer';
      final company = args['company'] as String? ?? 'Company';
      final level = args['level'] as String? ?? 'Mid-level';
      final questionType = args['type'] as String? ?? 'Mixed';
      final count = args['count'] as int? ?? 5;
      
      debugPrint('📋 Interview setup: position=$position, company=$company, level=$level, type=$questionType, language=$lang, count=$count');

      _interviewBloc.add(SetupInterviewEvent(
        position: position,
        company: company,
        level: level,
        questionType: questionType,
        language: lang,
        questionCount: count,
      ));
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    _cardAnimController.dispose();
    _interviewBloc.close();
    super.dispose();
  }

  void _animateNewQuestion() {
    _cardAnimController.reset();
    _cardAnimController.forward();
    _answerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _interviewBloc,
      child: BlocConsumer<InterviewBloc, InterviewState>(
        listener: (context, state) {
          if (state is InterviewQuestionsReady) {
            _animateNewQuestion();
          }
          if (state is InterviewCompleted) {
            context.router.pushNamed('/interview-result');
          }
          if (state is InterviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.tr.interview),
              centerTitle: true,
              actions: [
                if (state is InterviewQuestionsReady)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Chip(
                      label: Text(
                        '${state.currentIndex + 1}/${state.questions.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      backgroundColor: AppColors.primary,
                      side: BorderSide.none,
                    ),
                  ),
              ],
            ),
            body: _buildBody(state, isDark),
          );
        },
      ),
    );
  }

  Widget _buildBody(InterviewState state, bool isDark) {
    if (state is InterviewLoading) {
      return _buildLoadingState(state, isDark);
    }

    if (state is InterviewQuestionsReady) {
      return _buildQuestionView(state, isDark);
    }

    if (state is InterviewEvaluating) {
      return _buildEvaluatingState(isDark);
    }

    if (state is InterviewAnswerEvaluated) {
      return _buildFeedbackView(state, isDark);
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLoadingState(InterviewLoading state, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.5 + (value * 0.5),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.psychology, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            state.message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.primary,
              backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionView(InterviewQuestionsReady state, bool isDark) {
    final question = state.currentQuestion;

    return Column(
      children: [
        // Progress bar
        Container(
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: state.progress,
              color: AppColors.primary,
              backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Card
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.3, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _cardAnimController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: FadeTransition(
                    opacity: _cardAnimController,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  AppColors.primary.withValues(alpha: 0.15),
                                  AppColors.accent.withValues(alpha: 0.08),
                                ]
                              : [
                                  AppColors.primary.withValues(alpha: 0.08),
                                  AppColors.accent.withValues(alpha: 0.04),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Q${question.questionNumber}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  question.category.toUpperCase(),
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            question.questionText,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Answer Input
                Text(
                  'Your Answer',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _answerController,
                  maxLines: 6,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Type your answer here...\n\nTip: Use the STAR method (Situation, Task, Action, Result)',
                    filled: true,
                    fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _interviewBloc.add(SkipQuestionEvent());
                        },
                        icon: const Icon(Icons.skip_next_rounded),
                        label: Text(context.tr.skip),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: _answerController.text.isNotEmpty
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _answerController.text.isNotEmpty
                              ? () {
                                  _interviewBloc.add(
                                    SubmitAnswerEvent(answer: _answerController.text),
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: Text(context.tr.submitAnswer),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: isDark ? Colors.white12 : Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvaluatingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            builder: (context, value, _) {
              return Transform.rotate(
                angle: value * 6.28,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'AI is evaluating...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackView(InterviewAnswerEvaluated state, bool isDark) {
    final q = state.evaluatedQuestion;
    final score = q.score ?? 0;
    final Color scoreColor = score >= 80
        ? AppColors.success
        : score >= 50
            ? AppColors.warning
            : AppColors.error;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Score circle
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: score),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, animatedScore, _) {
              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scoreColor.withValues(alpha: 0.2), scoreColor.withValues(alpha: 0.05)],
                  ),
                  border: Border.all(color: scoreColor.withValues(alpha: 0.3), width: 3),
                ),
                child: Center(
                  child: Text(
                    '${animatedScore.toInt()}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: scoreColor,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Feedback
          if (q.feedback != null)
            _feedbackCard('💬 Feedback', q.feedback!, isDark),
          const SizedBox(height: 12),
          if (q.idealAnswer != null)
            _feedbackCard('✨ Ideal Answer', q.idealAnswer!, isDark),
          const SizedBox(height: 12),
          if (q.starAnalysis != null)
            _starAnalysisCard(q.starAnalysis!, isDark),
          const SizedBox(height: 24),

          // Next/Finish button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (state.currentIndex < state.questions.length - 1) {
                  _interviewBloc.add(NextQuestionEvent());
                } else {
                  _interviewBloc.add(FinishInterviewEvent());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                state.currentIndex < state.questions.length - 1
                    ? 'Next Question →'
                    : 'Finish Interview 🎉',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackCard(String title, String content, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _starAnalysisCard(String starJson, bool isDark) {
    // Try to parse as JSON map
    Map<String, dynamic> starMap = {};
    try {
      final decoded = jsonDecode(starJson);
      if (decoded is Map) starMap = Map<String, dynamic>.from(decoded);
    } catch (_) {
      // If not valid JSON, show as text
      return _feedbackCard('⭐ STAR Analysis', starJson, isDark);
    }

    final labels = {
      'Situation': '📍 Situation',
      'Task': '🎯 Task',
      'Action': '⚡ Action',
      'Result': '🏆 Result',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⭐ STAR Analysis', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 10),
          ...labels.entries.map((e) {
            final value = starMap[e.key]?.toString() ?? 'N/A';
            final isPresent = value.toLowerCase().contains('present');
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(e.value, style: const TextStyle(fontSize: 13)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPresent
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isPresent ? '✅ Present' : '❌ Missing',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isPresent ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
