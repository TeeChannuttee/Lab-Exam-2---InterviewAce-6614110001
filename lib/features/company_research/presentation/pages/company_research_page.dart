import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/interview/data/datasources/remote/openai_remote_datasource.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Company Research AI — learn about a company before your interview
@RoutePage()
class CompanyResearchPage extends StatefulWidget {
  const CompanyResearchPage({super.key});

  @override
  State<CompanyResearchPage> createState() => _CompanyResearchPageState();
}

class _CompanyResearchPageState extends State<CompanyResearchPage>
    with SingleTickerProviderStateMixin {
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  late AnimationController _animController;
  bool _isLoading = false;
  Map<String, dynamic>? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _research() async {
    if (_companyController.text.trim().isEmpty) return;
    setState(() { _isLoading = true; _error = null; });

    try {
      final openai = sl<OpenAIRemoteDataSource>();
      final language = context.read<SettingsBloc>().state.language;
      final result = await openai.researchCompany(
        companyName: _companyController.text.trim(),
        position: _positionController.text.trim().isEmpty ? null : _positionController.text.trim(),
        language: language,
      );
      if (mounted) {
        setState(() { _result = result; _isLoading = false; });
        _animController.reset(); _animController.forward();
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
      appBar: AppBar(title: Text(context.tr.researchCompanyTitle), centerTitle: true),
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
                  const Color(0xFF10B981).withValues(alpha: 0.12),
                  const Color(0xFF059669).withValues(alpha: 0.04),
                ]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.business_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 14),
                  Text(tr.researchAnyCompany, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(tr.crHeroSubtitle, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Inputs
            TextField(
              controller: _companyController,
              decoration: InputDecoration(
                labelText: context.tr.companyName,
                hintText: 'Google, Apple, LINE',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF10B981)),
                filled: true,
                fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF10B981), width: 2)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _positionController,
              decoration: InputDecoration(
                labelText: tr.positionOptional,
                hintText: 'Software Engineer',
                prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF10B981)),
                filled: true,
                fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _research,
                icon: _isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.auto_awesome),
                label: Text(_isLoading ? context.tr.researching : context.tr.researchBtn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
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
              _buildOverview(isDark),
              const SizedBox(height: 14),
              _buildCultureValues(isDark),
              const SizedBox(height: 14),
              _buildInterviewStyle(isDark),
              const SizedBox(height: 14),
              _buildCommonQuestions(isDark),
              const SizedBox(height: 14),
              _buildTips(isDark),
              const SizedBox(height: 14),
              _buildWhatTheyLookFor(isDark),
              const SizedBox(height: 14),
              _buildFunFact(isDark),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview(bool isDark) {
    return FadeTransition(
      opacity: _animController,
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
            Row(children: [
              const Icon(Icons.business_rounded, size: 24, color: Color(0xFF10B981)),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_result!['company_name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  Text(_result!['industry'] ?? '', style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[400])),
                ],
              )),
            ]),
            const SizedBox(height: 10),
            Text(_result!['overview'] ?? '', style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[700], height: 1.5, fontSize: 14)),
            if (_result!['salary_range'] != null) ...[
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.attach_money, size: 16, color: Color(0xFF10B981)),
                const SizedBox(width: 4),
                Text('${_result!['salary_range']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF10B981))),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCultureValues(bool isDark) {
    final values = (_result!['culture_values'] as List?)?.cast<String>() ?? [];
    if (values.isEmpty) return const SizedBox.shrink();
    return _sectionCard(context.tr.cultureValues, values, const Color(0xFF8B5CF6), isDark);
  }

  Widget _buildInterviewStyle(bool isDark) {
    final style = _result!['interview_style'] as String?;
    if (style == null || style.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr.interviewStyle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          Text(style, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[700], height: 1.5, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildCommonQuestions(bool isDark) {
    final questions = (_result!['common_questions'] as List?)?.cast<String>() ?? [];
    if (questions.isEmpty) return const SizedBox.shrink();
    return _sectionCard(context.tr.commonQuestions, questions, AppColors.warning, isDark);
  }

  Widget _buildTips(bool isDark) {
    final tips = (_result!['tips'] as List?)?.cast<String>() ?? [];
    if (tips.isEmpty) return const SizedBox.shrink();
    return _sectionCard(context.tr.interviewTipsLabel, tips, AppColors.success, isDark);
  }

  Widget _buildWhatTheyLookFor(bool isDark) {
    final traits = (_result!['what_they_look_for'] as List?)?.cast<String>() ?? [];
    if (traits.isEmpty) return const SizedBox.shrink();
    return _sectionCard(context.tr.whatTheyLookFor, traits, AppColors.primary, isDark);
  }

  Widget _buildFunFact(bool isDark) {
    final fact = _result!['fun_fact'] as String?;
    if (fact == null || fact.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.1 : 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, size: 20, color: Color(0xFFF59E0B)),
          const SizedBox(width: 10),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr.funFact, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              Text(fact, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[700], fontSize: 13)),
            ],
          )),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<String> items, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.08 : 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 7), decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Expanded(child: Text(item, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[700], fontSize: 13, height: 1.4))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
