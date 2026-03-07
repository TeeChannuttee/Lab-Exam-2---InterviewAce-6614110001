import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/interview/domain/repositories/interview_repository.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';
import 'package:interview_ace/features/gamification/data/services/gamification_service.dart';

/// Skill Gap Analysis — REAL data from interview session scores by category
@RoutePage()
class SkillGapPage extends StatefulWidget {
  const SkillGapPage({super.key});

  @override
  State<SkillGapPage> createState() => _SkillGapPageState();
}

class _SkillGapPageState extends State<SkillGapPage> {
  bool _loading = true;
  List<_SkillGap> _skills = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRealData();
  }

  Future<void> _loadRealData() async {
    try {
      final repo = sl<InterviewRepository>();
      final gamification = sl<GamificationService>();
      final sessionsResult = await repo.getAllSessions();

      final sessions = sessionsResult.fold(
        (f) => <InterviewSession>[],
        (data) => data,
      );

      if (sessions.isEmpty) {
        setState(() {
          _loading = false;
          _error = context.tr.sgNoData;
        });
        return;
      }

      // Collect all questions with scores
      final allQuestions = <InterviewQuestion>[];
      for (final session in sessions) {
        final qResult = await repo.getQuestionsForSession(session.id);
        qResult.fold((_) {}, (qs) => allQuestions.addAll(qs));
      }

      final scored = allQuestions.where((q) => q.score != null).toList();
      if (scored.isEmpty) {
        setState(() {
          _loading = false;
          _error = context.tr.sgNoScored;
        });
        return;
      }

      // Calculate per-category scores from REAL data
      final behavioralQs = scored.where((q) => q.category == 'behavioral');
      final technicalQs = scored.where((q) => q.category == 'technical');
      final situationalQs = scored.where((q) => q.category == 'situational');

      final skills = <_SkillGap>[];

      // Behavioral
      if (behavioralQs.isNotEmpty) {
        final avg = behavioralQs.map((q) => q.score!).reduce((a, b) => a + b) / behavioralQs.length;
        skills.add(_SkillGap(
          name: context.tr.sgBehavioral, score: avg.toInt(), icon: Icons.psychology_rounded,
          tips: avg >= 70
              ? ['Great behavioral answers!', 'Keep using specific examples', 'Quantify results when possible']
              : ['Prepare 5-7 detailed STAR stories', 'Quantify your results with numbers', 'Practice transitions between STAR elements'],
          resources: avg >= 70
              ? ['Advanced STAR techniques', 'Executive storytelling', 'Impact-driven answers']
              : ['STAR Method worksheet', 'Behavioral question bank', 'Practice with AI Coach'],
          questionCount: behavioralQs.length,
        ));
      }

      // Technical
      if (technicalQs.isNotEmpty) {
        final avg = technicalQs.map((q) => q.score!).reduce((a, b) => a + b) / technicalQs.length;
        skills.add(_SkillGap(
          name: context.tr.sgTechnical, score: avg.toInt(), icon: Icons.code_rounded,
          tips: avg >= 70
              ? ['Strong technical foundation!', 'Explain complex concepts simply', 'Reference real-world applications']
              : ['Review data structures & algorithms', 'Practice system design questions', 'Study design patterns'],
          resources: avg >= 70
              ? ['System Design Primer', 'Architecture patterns', 'Tech leadership articles']
              : ['LeetCode daily challenges', 'Coding interview prep', 'Technical fundamentals'],
          questionCount: technicalQs.length,
        ));
      }

      // Situational
      if (situationalQs.isNotEmpty) {
        final avg = situationalQs.map((q) => q.score!).reduce((a, b) => a + b) / situationalQs.length;
        skills.add(_SkillGap(
          name: context.tr.sgSituational, score: avg.toInt(), icon: Icons.lightbulb_rounded,
          tips: avg >= 70
              ? ['Excellent problem-solving approach!', 'Structure answers with clear logic', 'Show adaptability in responses']
              : ['Think out loud during problem solving', 'Break problems into smaller steps', 'Practice with case studies'],
          resources: avg >= 70
              ? ['Case interview frameworks', 'Decision-making models', 'Leadership scenarios']
              : ['HackerRank problems', 'Case study frameworks', 'Whiteboard practice'],
          questionCount: situationalQs.length,
        ));
      }

      // Overall communication (from all scores)
      final overallAvg = scored.map((q) => q.score!).reduce((a, b) => a + b) / scored.length;
      skills.add(_SkillGap(
        name: context.tr.sgCommunication, score: overallAvg.toInt(), icon: Icons.chat_bubble_outline,
        tips: overallAvg >= 70
            ? ['Strong communication skills!', 'Keep answers clear and concise', 'Good use of examples']
            : ['Practice explaining complex ideas simply', 'Record yourself and review delivery', 'Focus on pacing and pauses'],
        resources: overallAvg >= 70
            ? ['Advanced presentation skills', 'Executive communication', 'Storytelling techniques']
            : ['Toastmasters practice', 'TED Talk analysis', 'Mirror practice daily'],
        questionCount: scored.length,
      ));

      // Confidence (from gamification streak + session count)
      final streakScore = (gamification.currentStreak * 15).clamp(0, 100);
      skills.add(_SkillGap(
        name: context.tr.sgConsistency, score: streakScore, icon: Icons.local_fire_department_rounded,
        tips: streakScore >= 70
            ? ['Excellent practice habit!', 'Maintain your ${gamification.currentStreak}-day streak', 'Challenge yourself with harder questions']
            : ['Build a daily practice habit', 'Aim for a 3-day streak to start', 'Set a reminder to practice daily'],
        resources: streakScore >= 70
            ? ['Advanced interview techniques', 'Industry-specific prep', 'Mock panel interviews']
            : ['Daily 10-min practice routine', 'Habit building guides', 'Interview warm-up exercises'],
        questionCount: gamification.totalSessions,
      ));

      // Sort by score ascending (weakest first)
      skills.sort((a, b) => a.score.compareTo(b.score));

      setState(() {
        _skills = skills;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = '${context.tr.sgErrorLoading}: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.skillGapAnalysis), centerTitle: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildEmpty(isDark)
              : _buildContent(isDark),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology_outlined, size: 56, color: isDark ? Colors.white24 : Colors.grey[300]),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center,
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
    );
  }

  Widget _buildContent(bool isDark) {
    final overallAvg = _skills.isNotEmpty
        ? _skills.map((s) => s.score).reduce((a, b) => a + b) / _skills.length
        : 0;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        // Real data badge
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 14, color: AppColors.success),
                const SizedBox(width: 4),
                Text(context.tr.calculatedFromData,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.accent.withValues(alpha: 0.05),
            ]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Icon(Icons.psychology_outlined, size: 36, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(context.tr.yourSkillProfile,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              Text('${context.tr.sgOverall}: ${overallAvg.toInt()}% · ${context.tr.sgWeakestFirst}',
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Skill cards sorted by score (weakest first)
        ..._skills.map((skill) => _buildSkillCard(skill, isDark)),
      ],
    );
  }

  Widget _buildSkillCard(_SkillGap skill, bool isDark) {
    final color = skill.score >= 70
        ? AppColors.success
        : skill.score >= 50
            ? AppColors.warning
            : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(skill.icon, color: color, size: 20),
        ),
        title: Row(
          children: [
            Text(skill.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(width: 6),
            Text('(${skill.questionCount} Q)',
                style: TextStyle(fontSize: 10, color: isDark ? Colors.white24 : Colors.grey[400])),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: skill.score / 100),
                duration: const Duration(milliseconds: 1000),
                builder: (_, v, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: v, minHeight: 6,
                    backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('${skill.score}%', style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 12)),
          ],
        ),
        children: [
          _SectionHeader(context.tr.sgTips),
          ...skill.tips.map((t) => _BulletPoint(t, isDark)),
          const SizedBox(height: 10),
          _SectionHeader(context.tr.sgResources),
          ...skill.resources.map((r) => _BulletPoint(r, isDark)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  final bool isDark;
  const _BulletPoint(this.text, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400])),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600], height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _SkillGap {
  final String name;
  final int score;
  final IconData icon;
  final List<String> tips;
  final List<String> resources;
  final int questionCount;
  const _SkillGap({required this.name, required this.score, required this.icon, required this.tips, required this.resources, required this.questionCount});
}
