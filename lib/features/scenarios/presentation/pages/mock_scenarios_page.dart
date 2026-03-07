import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/features/interview/presentation/pages/interview_session_page.dart';
import 'package:interview_ace/features/interview/presentation/pages/setup_interview_page.dart';

/// Mock Interview Scenarios — pre-configured interview formats
@RoutePage()
class MockScenariosPage extends StatelessWidget {
  const MockScenariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(tr.interviewScenarios), centerTitle: true),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Text(tr.msChooseChallenge,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(tr.msSubtitle, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500])),
          const SizedBox(height: 24),

          _ScenarioCard(
            icon: Icons.person_outline,
            title: tr.msStandard,
            subtitle: tr.msStandardInfo,
            description: tr.msStandardDesc,
            difficulty: tr.msBeginner,
            difficultyColor: AppColors.success,
            isDark: isDark,
            onTap: () => _startScenario(context, type: 'Mixed', count: 5),
          ),
          const SizedBox(height: 14),

          _ScenarioCard(
            icon: Icons.groups_outlined,
            title: tr.msPanel,
            subtitle: tr.msPanelInfo,
            description: tr.msPanelDesc,
            difficulty: tr.msIntermediate,
            difficultyColor: AppColors.warning,
            isDark: isDark,
            onTap: () => _startScenario(context, type: 'Mixed', count: 7),
          ),
          const SizedBox(height: 14),

          _ScenarioCard(
            icon: Icons.bolt_outlined,
            title: tr.msRapidFire,
            subtitle: tr.msRapidFireInfo,
            description: tr.msRapidFireDesc,
            difficulty: tr.msAdvanced,
            difficultyColor: AppColors.error,
            isDark: isDark,
            onTap: () => _startScenario(context, type: 'Mixed', count: 10),
          ),
          const SizedBox(height: 14),

          _ScenarioCard(
            icon: Icons.psychology_outlined,
            title: tr.msBehavioral,
            subtitle: tr.msBehavioralInfo,
            description: tr.msBehavioralDesc,
            difficulty: tr.msIntermediate,
            difficultyColor: AppColors.warning,
            isDark: isDark,
            onTap: () => _startScenario(context, type: 'Behavioral', count: 5),
          ),
          const SizedBox(height: 14),

          _ScenarioCard(
            icon: Icons.business_center_outlined,
            title: tr.msCaseStudy,
            subtitle: tr.msCaseStudyInfo,
            description: tr.msCaseStudyDesc,
            difficulty: tr.msExpert,
            difficultyColor: const Color(0xFF8B5CF6),
            isDark: isDark,
            onTap: () => _startScenario(context, type: 'Situational', count: 3),
          ),
          const SizedBox(height: 14),

          _ScenarioCard(
            icon: Icons.local_fire_department_outlined,
            title: tr.msPressure,
            subtitle: tr.msPressureInfo,
            description: tr.msPressureDesc,
            difficulty: tr.msExpert,
            difficultyColor: const Color(0xFF8B5CF6),
            isDark: isDark,
            onTap: () => _startScenario(context, type: 'Situational', count: 8),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _startScenario(BuildContext context, {required String type, required int count}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(
          name: '/setup-interview',
          arguments: {
            'prefillType': type,
            'prefillCount': count,
          },
        ),
        builder: (_) => const SetupInterviewPage(),
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String difficulty;
  final Color difficultyColor;
  final bool isDark;
  final VoidCallback onTap;

  const _ScenarioCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.difficulty,
    required this.difficultyColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
          boxShadow: isDark
              ? null
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: difficultyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 24, color: difficultyColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: difficultyColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(difficulty, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: difficultyColor)),
                    ),
                  ]),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500], height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
