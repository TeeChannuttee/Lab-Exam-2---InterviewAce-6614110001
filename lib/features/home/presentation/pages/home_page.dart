import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:interview_ace/features/history/presentation/bloc/history_bloc.dart';
import 'package:interview_ace/features/gamification/data/services/gamification_service.dart';
import 'package:interview_ace/core/widgets/skill_radar_chart.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;
  late HistoryBloc _historyBloc;

  @override
  void initState() {
    super.initState();
    _historyBloc = sl<HistoryBloc>()..add(LoadHistoryEvent());
  }

  @override
  void dispose() {
    _historyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _historyBloc,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFFAFBFC),
        body: SafeArea(
          child: IndexedStack(
            index: _currentTab,
            children: [
              _DashboardTab(isDark: isDark),
              _PracticeTab(isDark: isDark),
              _InsightsTab(isDark: isDark),
              _ProfileTab(isDark: isDark),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBg : Colors.white,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentTab,
            onTap: (i) => setState(() => _currentTab = i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: isDark ? Colors.white30 : const Color(0xFF9CA3AF),
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.grid_view_rounded, size: 22),
                activeIcon: const Icon(Icons.grid_view_rounded, size: 22),
                label: context.tr.navHome,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.play_circle_outline, size: 22),
                activeIcon: const Icon(Icons.play_circle, size: 22),
                label: context.tr.interviewModes,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.insights_outlined, size: 22),
                activeIcon: const Icon(Icons.insights, size: 22),
                label: context.tr.navAnalytics,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline, size: 22),
                activeIcon: const Icon(Icons.person, size: 22),
                label: context.tr.navSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  TAB 1 — Dashboard
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _DashboardTab extends StatelessWidget {
  final bool isDark;
  const _DashboardTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final gamification = sl<GamificationService>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.psychology, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'InterviewAce',
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.lightText,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Enterprise Interview Platform',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? Colors.white38 : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.router.pushNamed('/settings'),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.settings_outlined, size: 17,
                      color: isDark ? Colors.white54 : AppColors.lightTextSecondary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CTA Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                final count = state is HistoryLoaded ? state.sessions.length : 0;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        count > 0 ? '$count sessions completed' : 'Ready to begin',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        count > 0 ? 'Continue practicing' : 'Start your first interview',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.router.pushNamed('/setup-interview'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: Text(context.tr.startInterview,
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          // Metrics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                final sessions = state is HistoryLoaded ? state.sessions : [];
                final scored = sessions.where((s) => s.totalScore != null);
                final avg = scored.isEmpty ? 0.0
                    : scored.map((s) => s.totalScore!).reduce((a, b) => a + b) / scored.length;
                return Row(
                  children: [
                    _MetricCard(label: 'Sessions', value: '${sessions.length}', isDark: isDark),
                    const SizedBox(width: 8),
                    _MetricCard(label: 'Avg Score', value: '${avg.toStringAsFixed(0)}%', isDark: isDark),
                    const SizedBox(width: 8),
                    _MetricCard(label: 'Level', value: '${gamification.level}', isDark: isDark),
                    const SizedBox(width: 8),
                    _MetricCard(label: 'Streak', value: '${gamification.currentStreak}d', isDark: isDark),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          // Quick Access
          _SectionHeader(title: context.tr.quickAccess, isDark: isDark),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _ActionRow(
                  icon: Icons.description_outlined,
                  title: context.tr.resumeScanner,
                  subtitle: context.tr.resumeScannerSub,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/resume-scan'),
                ),
                _ActionRow(
                  icon: Icons.checklist_rounded,
                  title: context.tr.interviewChecklist,
                  subtitle: context.tr.interviewChecklistSub,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/interview-checklist'),
                ),
                _ActionRow(
                  icon: Icons.auto_stories_outlined,
                  title: context.tr.knowledgeBase,
                  subtitle: context.tr.knowledgeBaseSub,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/knowledge-base'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Recent Sessions
          _SectionHeader(title: context.tr.recentActivity, isDark: isDark),
          const SizedBox(height: 10),
          _RecentSessionsList(isDark: isDark),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  TAB 2 — Practice
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _PracticeTab extends StatelessWidget {
  final bool isDark;
  const _PracticeTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(context.tr.interviewModes,
              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightText, letterSpacing: -0.5)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Text(context.tr.readyToPractice,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.lightTextSecondary)),
          ),

          const SizedBox(height: 20),

          // Interview Modes
          _SectionHeader(title: context.tr.interviewModes, isDark: isDark),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _PracticeCard(
                  icon: Icons.edit_note_rounded,
                  title: context.tr.textInterview,
                  subtitle: context.tr.textInterviewSub,
                  color: AppColors.primary,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/setup-interview'),
                ),
                const SizedBox(height: 10),
                _PracticeCard(
                  icon: Icons.mic_none_rounded,
                  title: context.tr.voiceInterview,
                  subtitle: context.tr.voiceInterviewSub,
                  color: const Color(0xFF2E6EB5),
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/setup-interview'),
                ),
                const SizedBox(height: 10),
                _PracticeCard(
                  icon: Icons.theater_comedy_outlined,
                  title: context.tr.mockScenarios,
                  subtitle: context.tr.mockScenariosSub,
                  color: const Color(0xFF4B5563),
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/mock-scenarios'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Tools
          _SectionHeader(title: context.tr.trainingTools, isDark: isDark),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _ActionRow(
                  icon: Icons.face_outlined,
                  title: context.tr.confidenceTracker,
                  subtitle: context.tr.confidenceTrackerSub,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/confidence'),
                ),
                _ActionRow(
                  icon: Icons.smart_toy_outlined,
                  title: context.tr.aiCoachChat,
                  subtitle: context.tr.aiCoachChatSub,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/ai-chat-coach'),
                ),
                _ActionRow(
                  icon: Icons.style_outlined,
                  title: context.tr.flashcards,
                  subtitle: context.tr.flashcardsSub,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/flashcards'),
                ),
                _ActionRow(
                  icon: Icons.description_outlined,
                  title: context.tr.resumeScanner,
                  subtitle: context.tr.resumeScannerSub,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/resume-scan'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Premium Tools (NEW!)
          _SectionHeader(title: context.tr.premiumTools, isDark: isDark),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _ActionRow(
                  icon: Icons.description_outlined,
                  title: context.tr.jdQuestionGen,
                  subtitle: context.tr.jdQuestionGenSub,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/jd-questions'),
                ),
                _ActionRow(
                  icon: Icons.business_rounded,
                  title: context.tr.companyResearch,
                  subtitle: context.tr.companyResearchSub,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/company-research'),
                ),
                _ActionRow(
                  icon: Icons.timer_outlined,
                  title: context.tr.pacingCoach,
                  subtitle: context.tr.pacingCoachSub,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/pacing-coach'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  TAB 3 — Insights
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _InsightsTab extends StatelessWidget {
  final bool isDark;
  const _InsightsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(context.tr.navAnalytics,
              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightText, letterSpacing: -0.5)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Text(context.tr.readyToPractice,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.lightTextSecondary)),
          ),

          const SizedBox(height: 20),

          // Radar Chart — Skill Overview (REAL data from sessions)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
                ),
              ),
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  // Calculate real skills from session data
                  Map<String, double> skillScores = {
                    'Technical': 0, 'Communication': 0,
                    'Problem Solving': 0, 'Leadership': 0,
                    'Adaptability': 0, 'Confidence': 0,
                  };

                  if (state is HistoryLoaded && state.sessions.isNotEmpty) {
                    final scored = state.sessions.where((s) => s.totalScore != null).toList();
                    if (scored.isNotEmpty) {
                      final avgScore = scored.map((s) => s.totalScore!).reduce((a, b) => a + b) / scored.length / 100;
                      final consistency = (scored.length / 10).clamp(0.0, 1.0);
                      final bestScore = scored.map((s) => s.totalScore!).reduce((a, b) => a > b ? a : b) / 100;

                      skillScores = {
                        'Technical': (avgScore * 0.9 + consistency * 0.1).clamp(0.0, 1.0),
                        'Communication': (avgScore * 1.05).clamp(0.0, 1.0),
                        'Problem Solving': (avgScore * 0.95).clamp(0.0, 1.0),
                        'Leadership': (consistency * 0.8).clamp(0.0, 1.0),
                        'Adaptability': ((avgScore + consistency) / 2).clamp(0.0, 1.0),
                        'Confidence': (bestScore * 0.9).clamp(0.0, 1.0),
                      };
                    }
                  }

                  return Column(
                    children: [
                      Text(context.tr.skillRadar,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.lightText)),
                      const SizedBox(height: 4),
                      Text(context.tr.noData,
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.lightTextSecondary)),
                      const SizedBox(height: 12),
                      Center(
                        child: SkillRadarChart(
                          size: 200,
                          skills: skillScores,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 22),

          // Performance
          _SectionHeader(title: context.tr.secPerformance, isDark: isDark),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _ActionRow(
                  icon: Icons.bar_chart_rounded,
                  title: context.tr.analytics,
                  subtitle: context.tr.subAnalyticsDashboard,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/analytics-dashboard'),
                ),
                _ActionRow(
                  icon: Icons.timeline_rounded,
                  title: context.tr.skillGap,
                  subtitle: context.tr.subSkillGap,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/skill-gap'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Advanced Analytics
          _SectionHeader(title: context.tr.secAdvancedAnalytics, isDark: isDark),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _ActionRow(
                  icon: Icons.visibility_outlined,
                  title: context.tr.eyeContactHeatmap,
                  subtitle: context.tr.subEyeContact,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/eye-contact-heatmap'),
                ),
                _ActionRow(
                  icon: Icons.psychology_outlined,
                  title: context.tr.personalityAnalysis,
                  subtitle: context.tr.subPersonality,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/personality-type'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // History
          _SectionHeader(title: context.tr.secRecords, isDark: isDark),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _ActionRow(
                  icon: Icons.history_rounded,
                  title: context.tr.sessionHistory,
                  subtitle: context.tr.subSessionHistory,
                  isDark: isDark,
                  onTap: () => context.router.pushNamed('/history'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  TAB 4 — Profile
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _ProfileTab extends StatelessWidget {
  final bool isDark;
  const _ProfileTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final gamification = sl<GamificationService>();

    return FutureBuilder<Box>(
      future: Hive.openBox('auth'),
      builder: (context, snapshot) {
        final userName = snapshot.hasData
            ? (snapshot.data!.get('userName', defaultValue: 'User') as String)
            : 'User';
        final userEmail = snapshot.hasData
            ? (snapshot.data!.get('userEmail', defaultValue: '') as String)
            : '';
        final initials = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(context.tr.navSettings,
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightText, letterSpacing: -0.5)),
              ),

              const SizedBox(height: 20),

              // User card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(initials,
                            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userName,
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppColors.lightText)),
                            const SizedBox(height: 2),
                            Text(userEmail,
                              style: GoogleFonts.inter(fontSize: 13, color: AppColors.lightTextSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Lv${gamification.level}',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // XP progress card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(gamification.levelTitle,
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.lightText)),
                          Text('${gamification.totalXP} XP',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: gamification.levelProgress,
                          minHeight: 6,
                          backgroundColor: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(context.tr.profXpToNext(gamification.xpForNextLevel - gamification.totalXP),
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              _SectionHeader(title: context.tr.profAccount, isDark: isDark),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _ActionRow(
                      icon: Icons.emoji_events_outlined,
                      title: context.tr.profAchievements,
                      subtitle: context.tr.profBadgesEarned(gamification.unlockedBadges.length),
                      isDark: isDark,
                      onTap: () => context.router.pushNamed('/achievement-profile'),
                    ),
                    _ActionRow(
                      icon: Icons.school_outlined,
                      title: context.tr.profLearningPath,
                      subtitle: context.tr.profTrackProgress,
                      isDark: isDark,
                      onTap: () => context.router.pushNamed('/learning-path'),
                    ),
                    _ActionRow(
                      icon: Icons.settings_outlined,
                      title: context.tr.profSettings,
                      subtitle: context.tr.profSettingsSub,
                      isDark: isDark,
                      onTap: () => context.router.pushNamed('/settings'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final box = await Hive.openBox('auth');
                      await box.put('isLoggedIn', false);
                      if (context.mounted) {
                        context.router.replaceNamed('/login');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      foregroundColor: AppColors.error,
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: Text(context.tr.profSignOut, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  Shared Components
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white30 : const Color(0xFF9CA3AF),
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  const _MetricCard({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: isDark ? Colors.white38 : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.lightText,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? Colors.white38 : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 18,
                  color: isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFD1D5DB)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14,
                color: isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFD1D5DB)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentSessionsList extends StatelessWidget {
  final bool isDark;
  const _RecentSessionsList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoaded && state.sessions.isNotEmpty) {
            final recent = state.sessions.take(3).toList();
            return Column(
              children: recent.map((session) {
                final score = session.totalScore;
                final scoreColor = score != null
                    ? AppColors.getScoreColor(score) : AppColors.lightTextSecondary;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Material(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => context.router.pushNamed('/history'),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: scoreColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  score != null ? '${score.toInt()}' : '—',
                                  style: GoogleFonts.inter(
                                    color: scoreColor, fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(session.position,
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13,
                                      color: isDark ? Colors.white : AppColors.lightText)),
                                  Text('${session.company} · ${session.level}',
                                    style: GoogleFonts.inter(fontSize: 11,
                                      color: isDark ? Colors.white38 : AppColors.lightTextSecondary)),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, size: 18,
                              color: isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFD1D5DB)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.inbox_outlined, size: 32,
                  color: isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFD1D5DB)),
                const SizedBox(height: 8),
                Text(context.tr.noSessionsYet,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white38 : AppColors.lightTextSecondary)),
                const SizedBox(height: 2),
                Text('Sessions will appear here after completion',
                  style: GoogleFonts.inter(fontSize: 11,
                    color: isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFD1D5DB))),
              ],
            ),
          );
        },
      ),
    );
  }
}
