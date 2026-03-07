import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/interview/data/datasources/remote/openai_remote_datasource.dart';
import 'package:interview_ace/features/interview/domain/repositories/interview_repository.dart';

/// AI Personality Type Analysis — REAL OpenAI analysis from user's interview history
@RoutePage()
class PersonalityTypePage extends StatefulWidget {
  const PersonalityTypePage({super.key});

  @override
  State<PersonalityTypePage> createState() => _PersonalityTypePageState();
}

class _PersonalityTypePageState extends State<PersonalityTypePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Map<String, dynamic>? _result;
  bool _isAnalyzing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _analyzePersonality();
  }

  Future<void> _analyzePersonality() async {
    try {
      setState(() { _isAnalyzing = true; _error = null; });

      // Get real interview history from repository
      final repo = sl<InterviewRepository>();
      final sessionsResult = await repo.getAllSessions();

      final sessions = sessionsResult.fold(
        (failure) => <dynamic>[],
        (data) => data,
      );

      if (sessions.isEmpty) {
        setState(() {
          _isAnalyzing = false;
          _error = 'No interview data yet. Complete at least 1 interview session first!';
        });
        return;
      }

      // Collect Q&A pairs from all sessions
      final answerHistory = <Map<String, dynamic>>[];
      for (final session in sessions.take(5)) {
        final questionsResult = await repo.getQuestionsForSession(session.id);
        final questions = questionsResult.fold(
          (failure) => <dynamic>[],
          (data) => data,
        );
        for (final q in questions) {
          if (q.answerText != null && q.answerText!.isNotEmpty) {
            answerHistory.add({
              'question': q.questionText,
              'answer': q.answerText,
            });
          }
        }
      }

      if (answerHistory.isEmpty) {
        setState(() {
          _isAnalyzing = false;
          _error = 'No answers found. Complete an interview and answer questions first!';
        });
        return;
      }

      // Call OpenAI for real personality analysis
      final openai = sl<OpenAIRemoteDataSource>();
      final result = await openai.analyzePersonality(
        answerHistory: answerHistory.take(10).toList(),
      );

      if (mounted) {
        setState(() {
          _result = result;
          _isAnalyzing = false;
        });
        _animController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _error = 'Analysis failed: ${e.toString().length > 80 ? '${e.toString().substring(0, 80)}...' : e}';
        });
      }
    }
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
      appBar: AppBar(title: Text(context.tr.personalityAnalysis), centerTitle: true),
      body: _isAnalyzing
          ? _buildLoading(isDark)
          : _error != null
              ? _buildError(isDark)
              : _result != null
                  ? _buildResult(isDark)
                  : const SizedBox(),
    );
  }

  Widget _buildLoading(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎭', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text('AI is analyzing your personality...', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Reading your interview answers', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500], fontSize: 13)),
          const SizedBox(height: 24),
          SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildError(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📝', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center,
                style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _analyzePersonality,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.tr.tryAgain),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(bool isDark) {
    final r = _result!;
    final type = r['type'] ?? 'XXXX';
    final title = r['title'] ?? 'Unknown';
    final subtitle = r['subtitle'] ?? '';
    final traits = (r['traits'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {};
    final strengths = List<String>.from(r['strengths'] ?? []);
    final growthAreas = List<String>.from(r['growth_areas'] ?? []);
    final idealRoles = List<String>.from(r['ideal_roles'] ?? []);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: FadeTransition(
        opacity: _animController,
        child: Column(
          children: [
            // Type card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10))],
              ),
              child: Column(
                children: [
                  Text(type, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                  const SizedBox(height: 8),
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7)), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(context.tr.analyzedByAI,
                style: TextStyle(fontSize: 10, color: isDark ? Colors.white24 : Colors.grey[400])),
            const SizedBox(height: 20),

            // Trait bars
            if (traits.isNotEmpty)
              _buildSection('📊 Trait Analysis', isDark,
                child: Column(
                  children: traits.entries.map((e) {
                    final color = e.value >= 0.8 ? AppColors.success : e.value >= 0.6 ? AppColors.warning : AppColors.error;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          SizedBox(width: 100, child: Text(e.key, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                          Expanded(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: e.value),
                              duration: const Duration(milliseconds: 1500),
                              builder: (_, v, __) => ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: v,
                                  minHeight: 8,
                                  backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation(color),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(width: 36, child: Text('${(e.value * 100).toInt()}%',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // Strengths
            if (strengths.isNotEmpty)
              _buildSection('💪 Interview Strengths', isDark,
                child: Column(
                  children: strengths.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('✅ ', style: TextStyle(fontSize: 12)),
                            Expanded(child: Text(s, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600], height: 1.4))),
                          ],
                        ),
                      )).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // Growth areas
            if (growthAreas.isNotEmpty)
              _buildSection('📈 Growth Opportunities', isDark,
                child: Column(
                  children: growthAreas.map((g) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🌱 ', style: TextStyle(fontSize: 12)),
                            Expanded(child: Text(g, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600], height: 1.4))),
                          ],
                        ),
                      )).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // Ideal roles
            if (idealRoles.isNotEmpty)
              _buildSection('🎯 Ideal Roles For You', isDark,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: idealRoles.map((role) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                        ),
                        child: Text(role, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      )).toList(),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, bool isDark, {required Widget child}) {
    return Container(
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
