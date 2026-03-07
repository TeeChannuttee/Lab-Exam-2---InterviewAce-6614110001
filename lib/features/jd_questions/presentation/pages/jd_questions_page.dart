import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/interview/data/datasources/remote/openai_remote_datasource.dart';

/// AI generates interview questions from a Job Description
@RoutePage()
class JdQuestionsPage extends StatefulWidget {
  const JdQuestionsPage({super.key});

  @override
  State<JdQuestionsPage> createState() => _JdQuestionsPageState();
}

class _JdQuestionsPageState extends State<JdQuestionsPage>
    with SingleTickerProviderStateMixin {
  final _jdController = TextEditingController();
  late AnimationController _animController;
  bool _isLoading = false;
  Map<String, dynamic>? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _jdController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _generateQuestions() async {
    if (_jdController.text.trim().length < 20) return;
    setState(() { _isLoading = true; _error = null; });

    try {
      final openai = sl<OpenAIRemoteDataSource>();
      final result = await openai.generateQuestionsFromJD(
        jobDescription: _jdController.text,
      );
      if (mounted) {
        setState(() { _result = result; _isLoading = false; });
        _animController.reset();
        _animController.forward();
      }
    } catch (e) {
      if (mounted) setState(() { _error = 'Failed: $e'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.jdQuestionGen), centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0xFF6366F1).withValues(alpha: 0.12),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.04),
                ]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.description_outlined, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 14),
                  Text(tr.jdPasteTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(tr.jdPasteSubtitle, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Input
            TextField(
              controller: _jdController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: tr.pasteJD,
                hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.grey[400]),
                filled: true,
                fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _generateQuestions,
                icon: _isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.auto_awesome),
                label: Text(_isLoading ? context.tr.generating : context.tr.generateQuestions),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.error)),
            ],

            // Results
            if (_result != null) ...[
              const SizedBox(height: 24),
              _buildResultHeader(isDark),
              const SizedBox(height: 16),
              _buildSkillTags(isDark),
              const SizedBox(height: 16),
              _buildQuestionsList(isDark),
              const SizedBox(height: 16),
              _buildPrepTips(isDark),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResultHeader(bool isDark) {
    return FadeTransition(
      opacity: _animController,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: isDark ? 0.12 : 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_result!['job_title'] ?? 'Position'} @ ${_result!['company'] ?? 'Company'}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text('${(_result!['questions'] as List?)?.length ?? 0} ${context.tr.jdQuestionsGenerated}',
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillTags(bool isDark) {
    final skills = (_result!['key_skills'] as List?)?.cast<String>() ?? [];
    if (skills.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr.keySkillsRequired, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6, runSpacing: 6,
          children: skills.map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6366F1))),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildQuestionsList(bool isDark) {
    final questions = (_result!['questions'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr.tailoredQuestions, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 10),
        ...questions.asMap().entries.map((entry) {
          final i = entry.key;
          final q = entry.value;
          final difficulty = q['difficulty'] ?? 'medium';
          final diffColor = difficulty == 'hard' ? AppColors.error : difficulty == 'easy' ? AppColors.success : AppColors.warning;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
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
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Q${i + 1}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6366F1))),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: diffColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(difficulty, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: diffColor)),
                    ),
                    const Spacer(),
                    Text(q['category'] ?? '', style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.grey[400])),
                  ],
                ),
                const SizedBox(height: 8),
                Text(q['question'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4)),
                if (q['tips'] != null) ...[
                  const SizedBox(height: 6),
                  Text(q['tips'] ?? '', style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500], fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPrepTips(bool isDark) {
    final tips = (_result!['preparation_tips'] as List?)?.cast<String>() ?? [];
    if (tips.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.blue[50],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr.preparationTips, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          ...tips.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400])),
                Expanded(child: Text(t, style: TextStyle(fontSize: 13, color: isDark ? Colors.white60 : Colors.grey[700], height: 1.4))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
