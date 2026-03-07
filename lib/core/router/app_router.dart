import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/features/auth/presentation/pages/login_page.dart';
import 'package:interview_ace/features/auth/presentation/pages/register_page.dart';
import 'package:interview_ace/features/interview/presentation/pages/setup_interview_page.dart';
import 'package:interview_ace/features/interview/presentation/pages/interview_session_page.dart';
import 'package:interview_ace/features/interview/presentation/pages/interview_result_page.dart';
import 'package:interview_ace/features/history/presentation/pages/history_page.dart';
import 'package:interview_ace/features/history/presentation/pages/history_detail_page.dart';
import 'package:interview_ace/features/resume_scan/presentation/pages/resume_scan_page.dart';
import 'package:interview_ace/features/confidence/presentation/pages/confidence_page.dart';
import 'package:interview_ace/features/settings/presentation/pages/settings_page.dart';
import 'package:interview_ace/features/home/presentation/pages/home_page.dart';
import 'package:interview_ace/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:interview_ace/features/analytics/presentation/pages/analytics_dashboard_page.dart';
import 'package:interview_ace/features/chat/presentation/pages/ai_chat_coach_page.dart';
import 'package:interview_ace/features/gamification/presentation/pages/achievement_profile_page.dart';
import 'package:interview_ace/features/voice/presentation/pages/voice_interview_page.dart';
import 'package:interview_ace/features/scenarios/presentation/pages/mock_scenarios_page.dart';
import 'package:interview_ace/features/flashcards/presentation/pages/flashcards_page.dart';
import 'package:interview_ace/features/skill_gap/presentation/pages/skill_gap_page.dart';
import 'package:interview_ace/features/heatmap/presentation/pages/eye_contact_heatmap_page.dart';
import 'package:interview_ace/features/personality/presentation/pages/personality_type_page.dart';
import 'package:interview_ace/features/knowledge/presentation/pages/knowledge_base_page.dart';
import 'package:interview_ace/features/learning/presentation/pages/learning_path_page.dart';
import 'package:interview_ace/features/checklist/presentation/pages/interview_checklist_page.dart';
import 'package:interview_ace/features/splash/presentation/pages/splash_screen.dart';
import 'package:interview_ace/features/jd_questions/presentation/pages/jd_questions_page.dart';
import 'package:interview_ace/features/salary/presentation/pages/salary_negotiation_page.dart';
import 'package:interview_ace/features/comparison/presentation/pages/session_comparison_page.dart';
import 'package:interview_ace/features/company_research/presentation/pages/company_research_page.dart';
import 'package:interview_ace/features/pacing/presentation/pages/pacing_coach_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/', initial: true),
        AutoRoute(page: LoginRoute.page, path: '/login'),
        AutoRoute(page: RegisterRoute.page, path: '/register'),
        AutoRoute(page: OnboardingRoute.page, path: '/onboarding'),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: SetupInterviewRoute.page, path: '/setup-interview'),
        AutoRoute(page: InterviewSessionRoute.page, path: '/interview-session'),
        AutoRoute(page: InterviewResultRoute.page, path: '/interview-result'),
        AutoRoute(page: HistoryRoute.page, path: '/history'),
        AutoRoute(page: HistoryDetailRoute.page, path: '/history-detail'),
        AutoRoute(page: ResumeScanRoute.page, path: '/resume-scan'),
        AutoRoute(page: ConfidenceRoute.page, path: '/confidence'),
        AutoRoute(page: SettingsRoute.page, path: '/settings'),
        AutoRoute(page: AnalyticsDashboardRoute.page, path: '/analytics-dashboard'),
        AutoRoute(page: AiChatCoachRoute.page, path: '/ai-chat-coach'),
        AutoRoute(page: AchievementProfileRoute.page, path: '/achievement-profile'),
        AutoRoute(page: VoiceInterviewRoute.page, path: '/voice-interview'),
        AutoRoute(page: MockScenariosRoute.page, path: '/mock-scenarios'),
        AutoRoute(page: FlashcardsRoute.page, path: '/flashcards'),
        AutoRoute(page: SkillGapRoute.page, path: '/skill-gap'),
        AutoRoute(page: EyeContactHeatmapRoute.page, path: '/eye-contact-heatmap'),
        AutoRoute(page: PersonalityTypeRoute.page, path: '/personality-type'),
        AutoRoute(page: KnowledgeBaseRoute.page, path: '/knowledge-base'),
        AutoRoute(page: LearningPathRoute.page, path: '/learning-path'),
        AutoRoute(page: InterviewChecklistRoute.page, path: '/interview-checklist'),
        AutoRoute(page: JdQuestionsRoute.page, path: '/jd-questions'),
        AutoRoute(page: SalaryNegotiationRoute.page, path: '/salary-negotiation'),
        AutoRoute(page: SessionComparisonRoute.page, path: '/session-comparison'),
        AutoRoute(page: CompanyResearchRoute.page, path: '/company-research'),
        AutoRoute(page: PacingCoachRoute.page, path: '/pacing-coach'),
      ];
}
