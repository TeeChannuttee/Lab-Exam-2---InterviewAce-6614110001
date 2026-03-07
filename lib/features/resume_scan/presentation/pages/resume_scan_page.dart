import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/resume_scan/data/services/text_recognition_service.dart';
import 'package:interview_ace/features/resume_scan/presentation/bloc/resume_scan_bloc.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:interview_ace/features/resume_scan/presentation/widgets/custom_photo_picker.dart';
import 'dart:io';

@RoutePage()
class ResumeScanPage extends StatefulWidget {
  const ResumeScanPage({super.key});

  @override
  State<ResumeScanPage> createState() => _ResumeScanPageState();
}

class _ResumeScanPageState extends State<ResumeScanPage>
    with SingleTickerProviderStateMixin {
  late final TextRecognitionService _textRecognitionService;
  late final ResumeScanBloc _resumeScanBloc;
  late final AnimationController _animController;

  TextRecognitionResult? _scanResult;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _textRecognitionService = TextRecognitionService();
    _resumeScanBloc = sl<ResumeScanBloc>();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _textRecognitionService.dispose();
    _resumeScanBloc.close();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _scanFromSource(String source) async {
    setState(() => _isScanning = true);
    try {
      TextRecognitionResult? result;
      if (source == 'camera') {
        result = await _textRecognitionService.recognizeFromCamera();
      } else if (source == 'photos') {
        // Use custom Flutter photo picker (bypasses broken native picker on Simulator)
        final file = await CustomPhotoPicker.pick(context);
        if (file != null) {
          result = await _textRecognitionService.recognizeFromFile(file);
        }
      } else {
        result = await _textRecognitionService.recognizeFromGallery();
      }

      if (result != null && result.fullText.isNotEmpty) {
        setState(() => _scanResult = result);
        // Send to AI for analysis
        final language = context.read<SettingsBloc>().state.language;
        _resumeScanBloc.add(AnalyzeResumeEvent(extractedText: result.fullText, language: language));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.tr.scanFailed}: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _resumeScanBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.tr.scanResume),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildScanOptions(isDark),
              const SizedBox(height: 24),
              if (_isScanning) _buildScanningState(isDark),
              if (_scanResult != null && !_isScanning) ...[
                _buildScanResultStats(isDark),
                const SizedBox(height: 12),
                _buildExtractedText(isDark),
                const SizedBox(height: 20),
              ],
              _buildAIAnalysis(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanOptions(bool isDark) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic)),
      child: FadeTransition(
        opacity: _animController,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [AppColors.accent.withValues(alpha: 0.12), Colors.transparent]
                  : [AppColors.accent.withValues(alpha: 0.06), Colors.white],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accent, AppColors.primary],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.document_scanner_outlined,
                    color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                context.tr.scanYourResume,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                context.tr.aiWillAnalyze,
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _ScanButton(
                      icon: Icons.camera_alt_rounded,
                      label: context.tr.camera,
                      onTap: () => _scanFromSource('camera'),
                      isDark: isDark,
                      isPrimary: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ScanButton(
                      icon: Icons.photo_library_rounded,
                      label: context.tr.photos,
                      onTap: () => _scanFromSource('photos'),
                      isDark: isDark,
                      isPrimary: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanningState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            builder: (context, value, _) {
              return Transform.rotate(
                angle: value * 6.28,
                child: Icon(Icons.document_scanner,
                    size: 48, color: AppColors.accent),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(context.tr.scanningText,
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildScanResultStats(bool isDark) {
    final result = _scanResult!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: isDark ? 0.15 : 0.08),
            AppColors.success.withValues(alpha: isDark ? 0.05 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.ocrScanComplete,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                  '${result.wordCount} ${context.tr.words}  ·  ${result.lineCount} ${context.tr.lines}  ·  ${result.blocks.length} ${context.tr.blocks}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _showFullText = false;

  Widget _buildExtractedText(bool isDark) {
    final text = _scanResult!.fullText;
    final lines = text.split('\n');
    final previewLines = lines.take(6).join('\n');
    final showExpand = lines.length > 6;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_snippet_outlined, size: 16,
                  color: isDark ? Colors.white54 : Colors.grey[500]),
              const SizedBox(width: 6),
              Text(context.tr.extractedText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey[500],
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _showFullText ? text : previewLines,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: isDark ? Colors.white60 : Colors.grey[600],
              height: 1.5,
            ),
          ),
          if (showExpand)
            GestureDetector(
              onTap: () => setState(() => _showFullText = !_showFullText),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _showFullText ? context.tr.showLess : '${context.tr.showAll} ${lines.length} ${context.tr.lines}...',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAIAnalysis(bool isDark) {
    return BlocBuilder<ResumeScanBloc, ResumeScanState>(
      builder: (context, state) {
        if (state is ResumeScanLoading) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.primary.withValues(alpha: 0.1), Colors.transparent]
                    : [AppColors.primary.withValues(alpha: 0.05), Colors.white],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primary, size: 32),
                const SizedBox(height: 12),
                const Text('ATS is analyzing your resume...',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.primary,
                ),
              ],
            ),
          );
        }

        if (state is ResumeScanAnalyzed) {
          final profile = state.profile;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Section Header ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.analytics_rounded,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(context.tr.atsAnalysisReport,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            )),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 1. ATS SCORE
              if (profile.atsScore != null) _buildAtsScoreCard(profile.atsScore!, isDark),
              const SizedBox(height: 16),

              // 2. OVERVIEW
              if (profile.analysis != null)
                _analysisCard(context.tr.overview, profile.analysis!, isDark, Icons.description_outlined),
              const SizedBox(height: 16),

              // 3. FORMAT CHECKS
              if (profile.formatChecks != null && profile.formatChecks!.isNotEmpty)
                _buildFormatChecksCard(profile.formatChecks!, isDark),
              const SizedBox(height: 16),

              // 4. KEYWORD ANALYSIS
              if (profile.keywordsFound != null || profile.keywordsMissing != null)
                _buildKeywordAnalysisCard(
                    profile.keywordsFound ?? [], profile.keywordsMissing ?? [], isDark),
              const SizedBox(height: 16),

              // 5. STRENGTHS
              if (profile.strengths != null && profile.strengths!.isNotEmpty)
                _listCard(context.tr.strengths, profile.strengths!, AppColors.success, isDark, Icons.thumb_up_rounded),
              const SizedBox(height: 16),

              // 6. WEAKNESSES
              if (profile.weaknesses != null && profile.weaknesses!.isNotEmpty)
                _listCard(context.tr.areasToImprove, profile.weaknesses!, AppColors.warning, isDark, Icons.warning_amber_rounded),
              const SizedBox(height: 16),

              // 7. IMPROVEMENT TIPS
              if (profile.improvementTips != null && profile.improvementTips!.isNotEmpty)
                _listCard(context.tr.actionItems, profile.improvementTips!, AppColors.primary, isDark, Icons.lightbulb_outline_rounded),
              const SizedBox(height: 16),

              // 8. SUGGESTED QUESTIONS
              if (profile.suggestedQuestions != null && profile.suggestedQuestions!.isNotEmpty)
                _listCard(context.tr.interviewQuestions, profile.suggestedQuestions!, Colors.deepPurple, isDark, Icons.quiz_rounded),
              const SizedBox(height: 24),
            ],
          );
        }

        if (state is ResumeScanError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.error),
                const SizedBox(width: 12),
                Expanded(child: Text(state.message)),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ─────────── ATS SCORE CARD ───────────

  Widget _buildAtsScoreCard(int score, bool isDark) {
    final Color scoreColor;
    final String scoreLabel;
    final IconData scoreIcon;

    if (score >= 80) {
      scoreColor = Colors.green;
      scoreLabel = context.tr.excellent;
      scoreIcon = Icons.check_circle;
    } else if (score >= 60) {
      scoreColor = Colors.orange;
      scoreLabel = context.tr.fair;
      scoreIcon = Icons.warning_amber_rounded;
    } else {
      scoreColor = Colors.red;
      scoreLabel = context.tr.needsWork;
      scoreIcon = Icons.cancel;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scoreColor.withValues(alpha: isDark ? 0.2 : 0.08),
            scoreColor.withValues(alpha: isDark ? 0.05 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(context.tr.atsCompatibilityScore,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.grey[600],
              )),
          const SizedBox(height: 16),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [scoreColor.withValues(alpha: 0.2), scoreColor.withValues(alpha: 0.05)],
              ),
              border: Border.all(color: scoreColor.withValues(alpha: 0.4), width: 4),
            ),
            child: Center(
              child: Text(
                '$score',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: scoreColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(scoreIcon, color: scoreColor, size: 20),
              const SizedBox(width: 6),
              Text(scoreLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: scoreColor,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────── FORMAT CHECKS CARD ───────────

  Widget _buildFormatChecksCard(Map<String, bool> checks, bool isDark) {
    final labels = {
      'has_contact_info': context.tr.contactInfo,
      'has_summary': context.tr.summaryObjective,
      'has_education': context.tr.education,
      'has_experience': context.tr.workExperience,
      'has_skills': context.tr.skillsSection,
      'proper_length': context.tr.properLength,
      'has_achievements': context.tr.measurableAchievements,
    };

    final passCount = checks.values.where((v) => v).length;
    final totalCount = checks.length;

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
          Row(
            children: [
              const Text('📋 Format Compliance',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: passCount == totalCount
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$passCount/$totalCount',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: passCount == totalCount ? Colors.green[700] : Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...checks.entries.map((e) {
            final label = labels[e.key] ?? e.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    e.value ? Icons.check_circle : Icons.cancel,
                    color: e.value ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(label,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      )),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─────────── KEYWORD ANALYSIS CARD ───────────

  Widget _buildKeywordAnalysisCard(
      List<String> found, List<String> missing, bool isDark) {
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
          Text(context.tr.keywordAnalysis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          if (found.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(context.tr.keywordsFoundLabel,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700])),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: found
                  .map((k) => Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                        ),
                        child: Text(k,
                            style: TextStyle(
                                fontSize: 12, color: Colors.green[800])),
                      ))
                  .toList(),
            ),
          ],
          if (missing.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(context.tr.missingKeywords,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700])),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: missing
                  .map((k) => Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        ),
                        child: Text(k,
                            style: TextStyle(
                                fontSize: 12, color: Colors.red[800])),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ─────────── GENERIC CARDS ───────────

  Widget _analysisCard(String title, String content, bool isDark, [IconData? icon]) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
        boxShadow: isDark ? null : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
              ],
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 10),
          Text(content,
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[700],
                  fontSize: 14,
                  height: 1.6)),
        ],
      ),
    );
  }

  Widget _listCard(String title, List<String> items, Color color, bool isDark, [IconData? icon]) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: isDark ? 0.2 : 0.15)),
        boxShadow: isDark ? null : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                const SizedBox(width: 10),
              ],
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text('${idx + 1}',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: color)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item,
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.grey[800],
                            fontSize: 13.5,
                            height: 1.5)),
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

class _ScanButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final bool isPrimary;

  const _ScanButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return isPrimary
        ? ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: 20),
            label: Text(label),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        : OutlinedButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: 20),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
  }
}
