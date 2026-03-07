import 'package:flutter/material.dart';

/// Centralized app localization with Thai (th) and English (en) support.
/// Access via: `context.tr.someKey`
class AppLocalizations {
  final String locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations('en');
  }

  String _t(String key) => (_translations[locale] ?? _translations['en']!)[key] ?? key;

  // ─────── GENERAL ───────
  String get appName => _t('appName');
  String get ok => _t('ok');
  String get cancel => _t('cancel');
  String get save => _t('save');
  String get delete => _t('delete');
  String get reset => _t('reset');
  String get error => _t('error');
  String get success => _t('success');
  String get loading => _t('loading');
  String get retry => _t('retry');
  String get next => _t('next');
  String get back => _t('back');
  String get done => _t('done');
  String get close => _t('close');
  String get search => _t('search');
  String get noData => _t('noData');
  String get comingSoon => _t('comingSoon');
  String get or_ => _t('or_');

  // ─────── AUTH ───────
  String get login => _t('login');
  String get register => _t('register');
  String get email => _t('email');
  String get password => _t('password');
  String get fullName => _t('fullName');
  String get confirmPassword => _t('confirmPassword');
  String get continueWithGoogle => _t('continueWithGoogle');
  String get forgotPassword => _t('forgotPassword');
  String get dontHaveAccount => _t('dontHaveAccount');
  String get alreadyHaveAccount => _t('alreadyHaveAccount');
  String get signUp => _t('signUp');
  String get signIn => _t('signIn');
  String get welcomeBack => _t('welcomeBack');
  String get createAccount => _t('createAccount');
  String get loginSubtitle => _t('loginSubtitle');
  String get registerSubtitle => _t('registerSubtitle');
  String get enterEmail => _t('enterEmail');
  String get enterPassword => _t('enterPassword');
  String get enterFullName => _t('enterFullName');
  String get reenterPassword => _t('reenterPassword');

  // ─────── HOME ───────
  String get home => _t('home');
  String get goodMorning => _t('goodMorning');
  String get goodAfternoon => _t('goodAfternoon');
  String get goodEvening => _t('goodEvening');
  String get readyToPractice => _t('readyToPractice');
  String get quickInsights => _t('quickInsights');
  String get totalSessions => _t('totalSessions');
  String get avgScore => _t('avgScore');
  String get bestScore => _t('bestScore');
  String get currentStreak => _t('currentStreak');
  String get days => _t('days');
  String get skillRadar => _t('skillRadar');
  String get interviewModes => _t('interviewModes');
  String get textInterview => _t('textInterview');
  String get textInterviewSub => _t('textInterviewSub');
  String get voiceInterview => _t('voiceInterview');
  String get voiceInterviewSub => _t('voiceInterviewSub');
  String get mockScenarios => _t('mockScenarios');
  String get mockScenariosSub => _t('mockScenariosSub');
  String get trainingTools => _t('trainingTools');
  String get confidenceTracker => _t('confidenceTracker');
  String get confidenceTrackerSub => _t('confidenceTrackerSub');
  String get aiCoachChat => _t('aiCoachChat');
  String get aiCoachChatSub => _t('aiCoachChatSub');
  String get flashcards => _t('flashcards');
  String get flashcardsSub => _t('flashcardsSub');
  String get resumeScanner => _t('resumeScanner');
  String get resumeScannerSub => _t('resumeScannerSub');
  String get premiumTools => _t('premiumTools');
  String get jdQuestionGen => _t('jdQuestionGen');
  String get jdQuestionGenSub => _t('jdQuestionGenSub');
  String get companyResearch => _t('companyResearch');
  String get companyResearchSub => _t('companyResearchSub');
  String get salaryNegotiation => _t('salaryNegotiation');
  String get salaryNegotiationSub => _t('salaryNegotiationSub');
  String get sessionComparison => _t('sessionComparison');
  String get sessionComparisonSub => _t('sessionComparisonSub');
  String get pacingCoach => _t('pacingCoach');
  String get pacingCoachSub => _t('pacingCoachSub');
  String get resumeCard => _t('resumeCard');
  String get resumeCardSub => _t('resumeCardSub');
  String get quickAccess => _t('quickAccess');
  String get interviewChecklist => _t('interviewChecklist');
  String get interviewChecklistSub => _t('interviewChecklistSub');
  String get knowledgeBase => _t('knowledgeBase');
  String get knowledgeBaseSub => _t('knowledgeBaseSub');
  String get recentActivity => _t('recentActivity');
  String get practice => _t('practice');
  String get chooseMode => _t('chooseMode');

  // ─────── ONBOARDING ───────
  String get skip => _t('skip');
  String get getStarted => _t('getStarted');
  String get onboard1Title => _t('onboard1Title');
  String get onboard1Sub => _t('onboard1Sub');
  String get onboard2Title => _t('onboard2Title');
  String get onboard2Sub => _t('onboard2Sub');
  String get onboard3Title => _t('onboard3Title');
  String get onboard3Sub => _t('onboard3Sub');
  String get onboard4Title => _t('onboard4Title');
  String get onboard4Sub => _t('onboard4Sub');

  // ─────── INTERVIEW ───────
  String get setupInterview => _t('setupInterview');
  String get position => _t('position');
  String get company => _t('company');
  String get level => _t('level');
  String get questionType => _t('questionType');
  String get questionCount => _t('questionCount');
  String get language => _t('language');
  String get startInterview => _t('startInterview');
  String get submitAnswer => _t('submitAnswer');
  String get nextQuestion => _t('nextQuestion');
  String get finishInterview => _t('finishInterview');
  String get typeYourAnswer => _t('typeYourAnswer');
  String get interviewResult => _t('interviewResult');
  String get overallScore => _t('overallScore');
  String get feedback => _t('feedback');
  String get strengths => _t('strengths');
  String get weaknesses => _t('weaknesses');
  String get questionLabel => _t('questionLabel');
  String get junior => _t('junior');
  String get mid => _t('mid');
  String get senior => _t('senior');
  String get behavioral => _t('behavioral');
  String get technical => _t('technical');
  String get mixed => _t('mixed');
  String get viewResult => _t('viewResult');
  String get congratulations => _t('congratulations');
  String get keepPracticing => _t('keepPracticing');
  String get backToHome => _t('backToHome');
  String get perQuestion => _t('perQuestion');

  // ─────── SETTINGS ───────
  String get settings => _t('settings');
  String get appearance => _t('appearance');
  String get darkMode => _t('darkMode');
  String get darkTheme => _t('darkTheme');
  String get lightTheme => _t('lightTheme');
  String get languageSetting => _t('languageSetting');
  String get data => _t('data');
  String get clearCache => _t('clearCache');
  String get clearCacheSub => _t('clearCacheSub');
  String get clearAllData => _t('clearAllData');
  String get clearAllDataSub => _t('clearAllDataSub');
  String get about => _t('about');
  String get version => _t('version');
  String get builtWithFlutter => _t('builtWithFlutter');
  String get clearCacheDialog => _t('clearCacheDialog');
  String get clearAllDialog => _t('clearAllDialog');

  // ─────── ANALYTICS ───────
  String get analytics => _t('analytics');
  String get history => _t('history');
  String get noSessionsYet => _t('noSessionsYet');
  String get exportData => _t('exportData');
  String get shareSummary => _t('shareSummary');
  String get performanceTrend => _t('performanceTrend');
  String get scoreDistribution => _t('scoreDistribution');
  String get sessionsOverTime => _t('sessionsOverTime');
  String get anScoreTrend => _t('anScoreTrend');
  String get anQuestionTypes => _t('anQuestionTypes');
  String get anByLevel => _t('anByLevel');
  String get anSessions => _t('anSessions');
  String get anAvgScore => _t('anAvgScore');
  String get anBest => _t('anBest');
  String get anQuestions => _t('anQuestions');
  String get anAiInsights => _t('anAiInsights');
  String get anExportCsv => _t('anExportCsv');
  String get anExportCsvSub => _t('anExportCsvSub');
  String get anExportJson => _t('anExportJson');
  String get anExportJsonSub => _t('anExportJsonSub');
  String get anShareSub => _t('anShareSub');
  String get anInsightExcellent => _t('anInsightExcellent');
  String get anInsightGood => _t('anInsightGood');
  String get anInsightKeep => _t('anInsightKeep');
  String get anInsightConsistent => _t('anInsightConsistent');
  String get anInsightMore => _t('anInsightMore');
  String get anInsightTip => _t('anInsightTip');
  String get anCompleteToSee => _t('anCompleteToSee');
  String get anNoCategoryData => _t('anNoCategoryData');
  String get anNoLevelData => _t('anNoLevelData');
  String get anSummaryCopied => _t('anSummaryCopied');
  String get anExportFailed => _t('anExportFailed');

  // ─────── GAMIFICATION ───────
  String get level1 => _t('level1');
  String get achievements => _t('achievements');
  String get leaderboard => _t('leaderboard');
  String get xp => _t('xp');
  String get badges => _t('badges');
  String get streak => _t('streak');
  String get missions => _t('missions');
  String get rank => _t('rank');
  String get progress => _t('progress');

  // ─────── BOTTOM NAV ───────
  String get navHome => _t('navHome');
  String get navAnalytics => _t('navAnalytics');
  String get navHistory => _t('navHistory');
  String get navSettings => _t('navSettings');

  // ─────── CONFIDENCE ───────
  String get confidenceAnalysis => _t('confidenceAnalysis');
  String get eyeContact => _t('eyeContact');
  String get smile => _t('smile');
  String get posture => _t('posture');
  String get startCamera => _t('startCamera');
  String get stopCamera => _t('stopCamera');
  String get confidenceScore => _t('confidenceScore');
  String get tips => _t('tips');

  // ─────── AI CHAT ───────
  String get chatCoach => _t('chatCoach');
  String get typeMessage => _t('typeMessage');
  String get aiThinking => _t('aiThinking');
  String get chatWelcome => _t('chatWelcome');
  String get clearChat => _t('clearChat');

  // ─────── RESUME ───────
  String get scanResume => _t('scanResume');
  String get takePhoto => _t('takePhoto');
  String get pickGallery => _t('pickGallery');
  String get analyzing => _t('analyzing');
  String get resumeStrengths => _t('resumeStrengths');
  String get resumeWeaknesses => _t('resumeWeaknesses');
  String get resumeSuggestions => _t('resumeSuggestions');

  // ─────── VOICE ───────
  String get voicePractice => _t('voicePractice');
  String get tapToSpeak => _t('tapToSpeak');
  String get listening => _t('listening');
  String get evaluating => _t('evaluating');
  String get yourAnswer => _t('yourAnswer');
  String get aiFeedback => _t('aiFeedback');

  // ─────── KNOWLEDGE ───────
  String get interviewTips => _t('interviewTips');
  String get commonQuestions => _t('commonQuestions');
  String get starMethod => _t('starMethod');
  String get bodyLanguage => _t('bodyLanguage');
  String get negotiationTips => _t('negotiationTips');

  // ─────── MOCK SCENARIOS ───────
  String get chooseScenario => _t('chooseScenario');
  String get scenarioDesc => _t('scenarioDesc');

  // ─────── HISTORY ───────
  String get sessionHistory => _t('sessionHistory');
  String get noHistory => _t('noHistory');
  String get sessionDetail => _t('sessionDetail');
  String get date => _t('date');
  String get score => _t('score');
  String get duration => _t('duration');

  // ─────── CHECKLIST ───────
  String get preInterviewChecklist => _t('preInterviewChecklist');
  String get completed => _t('completed');
  String get incomplete => _t('incomplete');

  // ─────── PERSONALITY ───────
  String get personalityType => _t('personalityType');
  String get idealRoles => _t('idealRoles');
  String get growthAreas => _t('growthAreas');

  // ─────── JOURNEY ───────
  String get journeyMap => _t('journeyMap');
  String get learningPath => _t('learningPath');
  String get currentLevel => _t('currentLevel');
  String get nextLevel => _t('nextLevel');

  // ─────── SKILL GAP ───────
  String get skillGap => _t('skillGap');
  String get readiness => _t('readiness');
  String get readinessScore => _t('readinessScore');

  // Skill Gap Details
  String get sgNoData => _t('sgNoData');
  String get sgNoScored => _t('sgNoScored');
  String get sgErrorLoading => _t('sgErrorLoading');
  String get sgOverall => _t('sgOverall');
  String get sgWeakestFirst => _t('sgWeakestFirst');
  String get sgTips => _t('sgTips');
  String get sgResources => _t('sgResources');
  String get sgBehavioral => _t('sgBehavioral');
  String get sgTechnical => _t('sgTechnical');
  String get sgSituational => _t('sgSituational');
  String get sgCommunication => _t('sgCommunication');
  String get sgConsistency => _t('sgConsistency');

  // ─────── EMOTION ───────
  String get emotionTimeline => _t('emotionTimeline');

  // ─────── HEATMAP ───────
  String get eyeContactHeatmap => _t('eyeContactHeatmap');

  // ─────── HOME SECTIONS ───────
  String get secPerformance => _t('secPerformance');
  String get secAdvancedAnalytics => _t('secAdvancedAnalytics');
  String get secRecords => _t('secRecords');
  String get subAnalyticsDashboard => _t('subAnalyticsDashboard');
  String get subSkillGap => _t('subSkillGap');
  String get subReadinessScore => _t('subReadinessScore');
  String get subEyeContact => _t('subEyeContact');
  String get subEmotionTimeline => _t('subEmotionTimeline');
  String get subPersonality => _t('subPersonality');
  String get subJourneyMap => _t('subJourneyMap');
  String get subSessionHistory => _t('subSessionHistory');
  String get subLeaderboard => _t('subLeaderboard');

  // ─────── CHECKLIST ITEMS ───────
  String get cl24hBefore => _t('cl24hBefore');
  String get clResearchCompany => _t('clResearchCompany');
  String get clReviewJob => _t('clReviewJob');
  String get clPrepareStories => _t('clPrepareStories');
  String get clPlanOutfit => _t('clPlanOutfit');
  String get clCheckRoute => _t('clCheckRoute');
  String get clPrepareQuestions => _t('clPrepareQuestions');
  String get clReviewResume => _t('clReviewResume');
  String get clSleepEarly => _t('clSleepEarly');
  String get cl1hBefore => _t('cl1hBefore');
  String get clEatLight => _t('clEatLight');
  String get clReviewNotes => _t('clReviewNotes');
  String get clChargeDevices => _t('clChargeDevices');
  String get clQuietSpace => _t('clQuietSpace');
  String get clTestCamera => _t('clTestCamera');
  String get clGatherMaterials => _t('clGatherMaterials');
  String get cl5minBefore => _t('cl5minBefore');
  String get clDeepBreaths => _t('clDeepBreaths');
  String get clPowerPose => _t('clPowerPose');
  String get clSmile => _t('clSmile');
  String get clSilencePhone => _t('clSilencePhone');
  String get clWaterReady => _t('clWaterReady');
  String get clPositiveThought => _t('clPositiveThought');
  String get clRememberName => _t('clRememberName');
  String get clOpenNotes => _t('clOpenNotes');
  String get clFinalCheck => _t('clFinalCheck');
  String get clJoinEarly => _t('clJoinEarly');
  String get clSavedLocal => _t('clSavedLocal');

  // ─────── RESUME SCAN UI ───────
  String get scanYourResume => _t('scanYourResume');
  String get aiWillAnalyze => _t('aiWillAnalyze');
  String get camera => _t('camera');
  String get photos => _t('photos');
  String get scanningText => _t('scanningText');
  String get ocrScanComplete => _t('ocrScanComplete');
  String get extractedText => _t('extractedText');
  String get showAll => _t('showAll');
  String get showLess => _t('showLess');
  String get atsAnalysisReport => _t('atsAnalysisReport');
  String get atsCompatibilityScore => _t('atsCompatibilityScore');
  String get excellent => _t('excellent');
  String get fair => _t('fair');
  String get overview => _t('overview');
  String get formatCompliance => _t('formatCompliance');
  String get keywordAnalysis => _t('keywordAnalysis');
  String get keywordsFoundLabel => _t('keywordsFoundLabel');
  String get missingKeywords => _t('missingKeywords');
  String get areasToImprove => _t('areasToImprove');
  String get actionItems => _t('actionItems');
  String get interviewQuestions => _t('interviewQuestions');
  String get scanFailed => _t('scanFailed');
  String get atsAnalyzing => _t('atsAnalyzing');
  String get contactInfo => _t('contactInfo');
  String get summaryObjective => _t('summaryObjective');
  String get education => _t('education');
  String get workExperience => _t('workExperience');
  String get skillsSection => _t('skillsSection');
  String get properLength => _t('properLength');
  String get measurableAchievements => _t('measurableAchievements');
  String get selectPhoto => _t('selectPhoto');

  // ─────── AI CHAT COACH ───────
  String get chatCoachTitle => _t('chatCoachTitle');
  String get chatCoachOnline => _t('chatCoachOnline');
  String get chatCoachWelcome => _t('chatCoachWelcome');
  String get chatCoachHint => _t('chatCoachHint');
  String get chatCoachError => _t('chatCoachError');
  String get chatQ1 => _t('chatQ1');
  String get chatQ2 => _t('chatQ2');
  String get chatQ3 => _t('chatQ3');
  String get chatQ4 => _t('chatQ4');
  String get chatQ5 => _t('chatQ5');

  // ─────── PROFILE TAB / SETTINGS ───────
  String get profAccount => _t('profAccount');
  String get profAchievements => _t('profAchievements');
  String profBadgesEarned(int n) => '${_t('profBadgesEarned')} $n';
  String get profLearningPath => _t('profLearningPath');
  String get profTrackProgress => _t('profTrackProgress');
  String get profSettings => _t('profSettings');
  String get profSettingsSub => _t('profSettingsSub');
  String get profSignOut => _t('profSignOut');
  String profXpToNext(int n) => '$n ${_t('profXpToNext')}';
  String get profClearAllTitle => _t('profClearAllTitle');
  String get profClearAllBody => _t('profClearAllBody');
  String get profDeleteAll => _t('profDeleteAll');
  String get profAllCleared => _t('profAllCleared');

  // ─────── ACHIEVEMENT PAGE ───────
  String get achSessions => _t('achSessions');
  String get achStreak => _t('achStreak');
  String get achBest => _t('achBest');
  String get achBadges => _t('achBadges');
  String achDayStreak(int n) => '$n ${_t('achDayStreak')}';
  String get achStartStreak => _t('achStartStreak');
  String get achStreakKeep => _t('achStreakKeep');
  String get achStreakStart => _t('achStreakStart');
  String achUnlocked(int a, int b) => '$a/$b ${_t('achUnlocked')}';
  String get achXpToNext => _t('achXpToNext');
  String achLevel(int n) => '${_t('achLevel')} $n';
  // Badge titles
  String get badgeFirstSteps => _t('badgeFirstSteps');
  String get badgeFirstStepsDesc => _t('badgeFirstStepsDesc');
  String get badgeGettingSerious => _t('badgeGettingSerious');
  String get badgeGettingSeriousDesc => _t('badgeGettingSeriousDesc');
  String get badgeDedicated => _t('badgeDedicated');
  String get badgeDedicatedDesc => _t('badgeDedicatedDesc');
  String get badgeCommitted => _t('badgeCommitted');
  String get badgeCommittedDesc => _t('badgeCommittedDesc');
  String get badgeInterviewKing => _t('badgeInterviewKing');
  String get badgeInterviewKingDesc => _t('badgeInterviewKingDesc');
  String get badgeHighAchiever => _t('badgeHighAchiever');
  String get badgeHighAchieverDesc => _t('badgeHighAchieverDesc');
  String get badgeExcellence => _t('badgeExcellence');
  String get badgeExcellenceDesc => _t('badgeExcellenceDesc');
  String get badgePerfection => _t('badgePerfection');
  String get badgePerfectionDesc => _t('badgePerfectionDesc');
  String get badge3DayStreak => _t('badge3DayStreak');
  String get badge3DayStreakDesc => _t('badge3DayStreakDesc');
  String get badgeWeekWarrior => _t('badgeWeekWarrior');
  String get badgeWeekWarriorDesc => _t('badgeWeekWarriorDesc');
  String get badgeMonthlyMaster => _t('badgeMonthlyMaster');
  String get badgeMonthlyMasterDesc => _t('badgeMonthlyMasterDesc');

  // ─────── LEARNING PATH PAGE ───────
  String lpProgress(int lv, int s) => '${_t('lpProgress')} (Lv$lv · $s ${_t('achSessions').toLowerCase()})';
  String get lpFoundation => _t('lpFoundation');
  String get lpBuildingSkills => _t('lpBuildingSkills');
  String get lpIntermediate => _t('lpIntermediate');
  String get lpAdvanced => _t('lpAdvanced');
  String get lpMaster => _t('lpMaster');
  String get lpM_f1 => _t('lpM_f1');
  String get lpM_f2 => _t('lpM_f2');
  String get lpM_f3 => _t('lpM_f3');
  String get lpM_f4 => _t('lpM_f4');
  String get lpM_b1 => _t('lpM_b1');
  String get lpM_b2 => _t('lpM_b2');
  String get lpM_b3 => _t('lpM_b3');
  String get lpM_b4 => _t('lpM_b4');
  String get lpM_i1 => _t('lpM_i1');
  String get lpM_i2 => _t('lpM_i2');
  String get lpM_i3 => _t('lpM_i3');
  String get lpM_i4 => _t('lpM_i4');
  String get lpM_i5 => _t('lpM_i5');
  String get lpM_a1 => _t('lpM_a1');
  String get lpM_a2 => _t('lpM_a2');
  String get lpM_a3 => _t('lpM_a3');
  String get lpM_a4 => _t('lpM_a4');
  String get lpM_a5 => _t('lpM_a5');
  String get lpM_m1 => _t('lpM_m1');
  String get lpM_m2 => _t('lpM_m2');
  String get lpM_m3 => _t('lpM_m3');
  String get lpM_m4 => _t('lpM_m4');
  String get lpM_m5 => _t('lpM_m5');

  // ─────── READINESS SCORE PAGE ───────
  String get rsInterviewReadiness => _t('rsInterviewReadiness');
  String get rsSkillBreakdown => _t('rsSkillBreakdown');
  String get rsDetailedBreakdown => _t('rsDetailedBreakdown');
  String get rsNextSteps => _t('rsNextSteps');
  String get rsReady => _t('rsReady');
  String get rsAlmostReady => _t('rsAlmostReady');
  String get rsGettingThere => _t('rsGettingThere');
  String get rsKeepPracticing => _t('rsKeepPracticing');
  String get rsJustStarting => _t('rsJustStarting');
  String get rsPractice => _t('rsPractice');
  String get rsPerformance => _t('rsPerformance');
  String get rsConsistency => _t('rsConsistency');
  String get rsLevel => _t('rsLevel');
  String get rsExperience => _t('rsExperience');
  String get rsRec1Low => _t('rsRec1Low');
  String get rsRec2Low => _t('rsRec2Low');
  String get rsRec3Low => _t('rsRec3Low');
  String get rsRec1Mid => _t('rsRec1Mid');
  String get rsRec2Mid => _t('rsRec2Mid');
  String get rsRec3Mid => _t('rsRec3Mid');
  String get rsRec1High => _t('rsRec1High');
  String get rsRec2High => _t('rsRec2High');
  String get rsRec3High => _t('rsRec3High');
  // ─────── MISC PAGE LABELS ───────
  String get startConversation => _t('startConversation');
  String get summaryCopied => _t('summaryCopied');
  String get exportedSessions => _t('exportedSessions');
  String get exportFailed => _t('exportFailed');
  String get interviewJourney => _t('interviewJourney');
  String get personalityAnalysis => _t('personalityAnalysis');
  String get analyzedByAI => _t('analyzedByAI');
  String get tryAgain => _t('tryAgain');
  String get readinessScoreTitle => _t('readinessScoreTitle');
  String get skillGapAnalysis => _t('skillGapAnalysis');
  String get calculatedFromData => _t('calculatedFromData');
  String get yourSkillProfile => _t('yourSkillProfile');
  String get interviewScenarios => _t('interviewScenarios');
  String get practiceAgain => _t('practiceAgain');
  String get interview => _t('interview');
  String get realDataLabel => _t('realDataLabel');
  String get useConfidenceFirst => _t('useConfidenceFirst');
  String get great => _t('great');
  String get improve => _t('improve');
  String get perQuestionScores => _t('perQuestionScores');
  String get fromRealHistory => _t('fromRealHistory');
  String get noFlashcards => _t('noFlashcards');
  String get fcQuestion => _t('fcQuestion');
  String get fcIdealAnswer => _t('fcIdealAnswer');
  String get fcYourAnswer => _t('fcYourAnswer');
  String get fcTapReveal => _t('fcTapReveal');
  String get fcTapQuestion => _t('fcTapQuestion');
  String get fcScore => _t('fcScore');
  String get fcNoDataYet => _t('fcNoDataYet');
  String get fcNoAnswered => _t('fcNoAnswered');
  String get clearCacheQuestion => _t('clearCacheQuestion');
  String get clearCacheBody => _t('clearCacheBody');
  String get cacheCleared => _t('cacheCleared');
  String get clear => _t('clear');
  String get unlocked => _t('unlocked');
  String get yourXpStats => _t('yourXpStats');
  String get sessions => _t('sessions');
  String get progressFromData => _t('progressFromData');
  String get questionsGenerated => _t('questionsGenerated');
  String get words => _t('words');
  String get lines => _t('lines');
  String get blocks => _t('blocks');

  // ─────── NEW FEATURES ───────
  String get pasteJD => _t('pasteJD');
  String get generateQuestions => _t('generateQuestions');
  String get generating => _t('generating');
  String get tailoredQuestions => _t('tailoredQuestions');
  String get keySkillsRequired => _t('keySkillsRequired');
  String get preparationTips => _t('preparationTips');
  String get jdPasteTitle => _t('jdPasteTitle');
  String get jdPasteSubtitle => _t('jdPasteSubtitle');
  String get jdQuestionsGenerated => _t('jdQuestionsGenerated');
  String get salaryDiffEasy => _t('salaryDiffEasy');
  String get salaryDiffEasyDesc => _t('salaryDiffEasyDesc');
  String get salaryDiffMedium => _t('salaryDiffMedium');
  String get salaryDiffMediumDesc => _t('salaryDiffMediumDesc');
  String get salaryDiffHard => _t('salaryDiffHard');
  String get salaryDiffHardDesc => _t('salaryDiffHardDesc');
  String get startNegotiation => _t('startNegotiation');
  String get selectDifficulty => _t('selectDifficulty');
  String get salarySimTitle => _t('salarySimTitle');
  String get salarySimSub => _t('salarySimSub');
  String get yourCounterOffer => _t('yourCounterOffer');
  String get hrManager => _t('hrManager');
  String get salaryWelcome => _t('salaryWelcome');
  String get salaryConnError => _t('salaryConnError');
  String get salaryFriendly => _t('salaryFriendly');
  String get salaryTough => _t('salaryTough');
  String get salaryBalanced => _t('salaryBalanced');
  String get compareSessions => _t('compareSessions');
  String get sessionBefore => _t('sessionBefore');
  String get sessionAfter => _t('sessionAfter');
  String get selectSession => _t('selectSession');
  String get improved => _t('improved');
  String get needsWork => _t('needsWork');
  String get detailComparison => _t('detailComparison');
  String get greatProgress => _t('greatProgress');
  String get tipsForImprovement => _t('tipsForImprovement');
  String get needTwoSessions => _t('needTwoSessions');
  String get researchCompanyTitle => _t('researchCompanyTitle');
  String get researchAnyCompany => _t('researchAnyCompany');
  String get companyName => _t('companyName');
  String get positionOptional => _t('positionOptional');
  String get researching => _t('researching');
  String get researchBtn => _t('researchBtn');
  String get crHeroSubtitle => _t('crHeroSubtitle');
  String get cultureValues => _t('cultureValues');
  String get interviewStyle => _t('interviewStyle');
  String get interviewTipsLabel => _t('interviewTipsLabel');
  String get whatTheyLookFor => _t('whatTheyLookFor');
  String get funFact => _t('funFact');
  String get goldenZone => _t('goldenZone');
  String get startAnswer => _t('startAnswer');
  String get stopSave => _t('stopSave');
  String get answerTimes => _t('answerTimes');
  String get pacingTips => _t('pacingTips');
  String get pacingTip1 => _t('pacingTip1');
  String get pacingTip2 => _t('pacingTip2');
  String get pacingTip3 => _t('pacingTip3');
  String get pacingTip4 => _t('pacingTip4');
  String get answerLabel => _t('answerLabel');
  String get buildingUp => _t('buildingUp');
  String get goldenZoneLabel => _t('goldenZoneLabel');
  String get wrappingUp => _t('wrappingUp');
  String get tooLong => _t('tooLong');
  String get tooLongLabel => _t('tooLongLabel');
  String get ready => _t('ready');
  String get perfect => _t('perfect');
  String get tooShort => _t('tooShort');
  String get digitalResumeCard => _t('digitalResumeCard');
  String get createShareableCard => _t('createShareableCard');
  String get generateCard => _t('generateCard');
  String get scanToSave => _t('scanToSave');
  String get keySkills => _t('keySkills');
  String get phone => _t('phone');
  String get linkedinUrl => _t('linkedinUrl');
  String get jobTitle => _t('jobTitle');

  // ── KNOWLEDGE BASE ──
  String get kbForYou => _t('kbForYou');
  String get kbStar => _t('kbStar');
  String get kbTips => _t('kbTips');
  String get kbIndustry => _t('kbIndustry');
  String get kbPersonalInsights => _t('kbPersonalInsights');
  String get kbBasedOnSessions => _t('kbBasedOnSessions');
  String get kbCompleteToUnlock => _t('kbCompleteToUnlock');
  String get kbAvgScore => _t('kbAvgScore');
  String get kbSessions => _t('kbSessions');
  String get kbFocus => _t('kbFocus');
  String get kbAiCoach => _t('kbAiCoach');
  String get kbAiCoachSub => _t('kbAiCoachSub');
  String get kbRegenerate => _t('kbRegenerate');
  String get kbGenerateAi => _t('kbGenerateAi');
  String get kbRecommended => _t('kbRecommended');
  String get kbFocusArea => _t('kbFocusArea');
  String get kbRecentPerf => _t('kbRecentPerf');
  String get kbStrengthLabel => _t('kbStrengthLabel');
  String get kbStartJourney => _t('kbStartJourney');
  String get kbStartJourneySub => _t('kbStartJourneySub');
  String get kbStarTitle => _t('kbStarTitle');
  String get kbStarSubtitle => _t('kbStarSubtitle');
  String get kbSituation => _t('kbSituation');
  String get kbSituationDesc => _t('kbSituationDesc');
  String get kbSituationEx => _t('kbSituationEx');
  String get kbTask => _t('kbTask');
  String get kbTaskDesc => _t('kbTaskDesc');
  String get kbTaskEx => _t('kbTaskEx');
  String get kbAction => _t('kbAction');
  String get kbActionDesc => _t('kbActionDesc');
  String get kbActionEx => _t('kbActionEx');
  String get kbResult => _t('kbResult');
  String get kbResultDesc => _t('kbResultDesc');
  String get kbResultEx => _t('kbResultEx');
  String get kbExample => _t('kbExample');
  String get kbBestPractices => _t('kbBestPractices');
  String get kbDoSpecific => _t('kbDoSpecific');
  String get kbDoYourActions => _t('kbDoYourActions');
  String get kbDoKeepTime => _t('kbDoKeepTime');
  String get kbDontVague => _t('kbDontVague');
  String get kbDontBadmouth => _t('kbDontBadmouth');
  String get kbDontNoQuestion => _t('kbDontNoQuestion');
  String get kbPowerPhrases => _t('kbPowerPhrases');
  String get kbCommonMistakes => _t('kbCommonMistakes');
  String get kbAdvancedTactics => _t('kbAdvancedTactics');
  String get kbShowImpact => _t('kbShowImpact');
  String get kbShowImpactDesc => _t('kbShowImpactDesc');
  String get kbShowGrowth => _t('kbShowGrowth');
  String get kbShowGrowthDesc => _t('kbShowGrowthDesc');
  String get kbShowFit => _t('kbShowFit');
  String get kbShowFitDesc => _t('kbShowFitDesc');
  String get kbShowInit => _t('kbShowInit');
  String get kbShowInitDesc => _t('kbShowInitDesc');
  String get kbTooVague => _t('kbTooVague');
  String get kbNegativity => _t('kbNegativity');
  String get kbUnprepared => _t('kbUnprepared');
  String get kbOverRehearsed => _t('kbOverRehearsed');
  String get kb2MinRule => _t('kb2MinRule');
  String get kbMirror => _t('kbMirror');
  String get kbPause => _t('kbPause');
  String get kbFollowUp => _t('kbFollowUp');
  String get kbPortfolio => _t('kbPortfolio');
  String get kbTech => _t('kbTech');
  String get kbFinance => _t('kbFinance');
  String get kbMarketing => _t('kbMarketing');
  String get kbHealthcare => _t('kbHealthcare');
  String get kbConsulting => _t('kbConsulting');
  String get kbTopics => _t('kbTopics');
  String get kbFocusAreas => _t('kbFocusAreas');

  // Tips content
  String get kbShowImpactEx => _t('kbShowImpactEx');
  String get kbShowGrowthEx => _t('kbShowGrowthEx');
  String get kbShowFitEx => _t('kbShowFitEx');
  String get kbShowInitEx => _t('kbShowInitEx');
  String get kbTooVagueSub => _t('kbTooVagueSub');
  String get kbTooVagueEx => _t('kbTooVagueEx');
  String get kbNegativitySub => _t('kbNegativitySub');
  String get kbNegativityEx => _t('kbNegativityEx');
  String get kbUnpreparedSub => _t('kbUnpreparedSub');
  String get kbUnpreparedEx => _t('kbUnpreparedEx');
  String get kbOverRehearsedSub => _t('kbOverRehearsedSub');
  String get kbOverRehearsedEx => _t('kbOverRehearsedEx');
  String get kb2MinRuleSub => _t('kb2MinRuleSub');
  String get kb2MinRuleEx => _t('kb2MinRuleEx');
  String get kbMirrorSub => _t('kbMirrorSub');
  String get kbMirrorEx => _t('kbMirrorEx');
  String get kbPauseSub => _t('kbPauseSub');
  String get kbPauseEx => _t('kbPauseEx');
  String get kbFollowUpSub => _t('kbFollowUpSub');
  String get kbFollowUpEx => _t('kbFollowUpEx');
  String get kbPortfolioSub => _t('kbPortfolioSub');
  String get kbPortfolioEx => _t('kbPortfolioEx');
  // Industry tips
  String get kbTech1 => _t('kbTech1');
  String get kbTech2 => _t('kbTech2');
  String get kbTech3 => _t('kbTech3');
  String get kbTech4 => _t('kbTech4');
  String get kbTech5 => _t('kbTech5');
  String get kbTech6 => _t('kbTech6');
  String get kbFinance1 => _t('kbFinance1');
  String get kbFinance2 => _t('kbFinance2');
  String get kbFinance3 => _t('kbFinance3');
  String get kbFinance4 => _t('kbFinance4');
  String get kbFinance5 => _t('kbFinance5');
  String get kbFinance6 => _t('kbFinance6');
  String get kbMarketing1 => _t('kbMarketing1');
  String get kbMarketing2 => _t('kbMarketing2');
  String get kbMarketing3 => _t('kbMarketing3');
  String get kbMarketing4 => _t('kbMarketing4');
  String get kbMarketing5 => _t('kbMarketing5');
  String get kbMarketing6 => _t('kbMarketing6');
  String get kbHealthcare1 => _t('kbHealthcare1');
  String get kbHealthcare2 => _t('kbHealthcare2');
  String get kbHealthcare3 => _t('kbHealthcare3');
  String get kbHealthcare4 => _t('kbHealthcare4');
  String get kbHealthcare5 => _t('kbHealthcare5');
  String get kbHealthcare6 => _t('kbHealthcare6');
  String get kbConsulting1 => _t('kbConsulting1');
  String get kbConsulting2 => _t('kbConsulting2');
  String get kbConsulting3 => _t('kbConsulting3');
  String get kbConsulting4 => _t('kbConsulting4');
  String get kbConsulting5 => _t('kbConsulting5');
  String get kbConsulting6 => _t('kbConsulting6');

  // Mock Scenarios
  String get msChooseChallenge => _t('msChooseChallenge');
  String get msSubtitle => _t('msSubtitle');
  String get msBeginner => _t('msBeginner');
  String get msIntermediate => _t('msIntermediate');
  String get msAdvanced => _t('msAdvanced');
  String get msExpert => _t('msExpert');
  String get msStandard => _t('msStandard');
  String get msStandardInfo => _t('msStandardInfo');
  String get msStandardDesc => _t('msStandardDesc');
  String get msPanel => _t('msPanel');
  String get msPanelInfo => _t('msPanelInfo');
  String get msPanelDesc => _t('msPanelDesc');
  String get msRapidFire => _t('msRapidFire');
  String get msRapidFireInfo => _t('msRapidFireInfo');
  String get msRapidFireDesc => _t('msRapidFireDesc');
  String get msBehavioral => _t('msBehavioral');
  String get msBehavioralInfo => _t('msBehavioralInfo');
  String get msBehavioralDesc => _t('msBehavioralDesc');
  String get msCaseStudy => _t('msCaseStudy');
  String get msCaseStudyInfo => _t('msCaseStudyInfo');
  String get msCaseStudyDesc => _t('msCaseStudyDesc');
  String get msPressure => _t('msPressure');
  String get msPressureInfo => _t('msPressureInfo');
  String get msPressureDesc => _t('msPressureDesc');

  // ── TRANSLATIONS MAP ──
  static final Map<String, Map<String, String>> _translations = {
    'en': _en,
    'th': _th,
  };

  static const _en = <String, String>{
    // General
    'appName': 'InterviewAce',
    'ok': 'OK',
    'cancel': 'Cancel',
    'save': 'Save',
    'delete': 'Delete',
    'reset': 'Reset',
    'error': 'Error',
    'success': 'Success',
    'loading': 'Loading...',
    'retry': 'Retry',
    'next': 'Next',
    'back': 'Back',
    'done': 'Done',
    'close': 'Close',
    'search': 'Search',
    'noData': 'No data available',
    'comingSoon': 'Coming soon',
    'or_': 'or',

    // Auth
    'login': 'Login',
    'register': 'Register',
    'email': 'Email',
    'password': 'Password',
    'fullName': 'Full Name',
    'confirmPassword': 'Confirm Password',
    'continueWithGoogle': 'Continue with Google',
    'forgotPassword': 'Forgot Password?',
    'dontHaveAccount': 'Don\'t have an account?',
    'alreadyHaveAccount': 'Already have an account?',
    'signUp': 'Sign Up',
    'signIn': 'Sign In',
    'welcomeBack': 'Welcome Back',
    'createAccount': 'Create Account',
    'loginSubtitle': 'Sign in to continue your interview prep',
    'registerSubtitle': 'Join us and ace your next interview',
    'enterEmail': 'Enter your email',
    'enterPassword': 'Enter your password',
    'enterFullName': 'Enter your full name',
    'reenterPassword': 'Re-enter your password',

    // Home
    'home': 'Home',
    'goodMorning': 'Good Morning',
    'goodAfternoon': 'Good Afternoon',
    'goodEvening': 'Good Evening',
    'readyToPractice': 'Ready to practice?',
    'quickInsights': 'Quick Insights',
    'totalSessions': 'Total Sessions',
    'avgScore': 'Avg Score',
    'bestScore': 'Best Score',
    'currentStreak': 'Streak',
    'days': 'days',
    'skillRadar': 'Skill Radar',
    'interviewModes': 'Interview Modes',
    'textInterview': 'Text Interview',
    'textInterviewSub': 'AI-generated questions with typed answers',
    'voiceInterview': 'Voice Interview',
    'voiceInterviewSub': 'Speak your answers with speech recognition',
    'mockScenarios': 'Mock Scenarios',
    'mockScenariosSub': 'Realistic interview role-play situations',
    'trainingTools': 'Training Tools',
    'confidenceTracker': 'Confidence Tracker',
    'confidenceTrackerSub': 'Face detection & body language analysis',
    'aiCoachChat': 'AI Coach Chat',
    'aiCoachChatSub': 'Real-time coaching with AI assistant',
    'flashcards': 'Flashcards',
    'flashcardsSub': 'Review questions from past sessions',
    'resumeScanner': 'Resume Scanner',
    'resumeScannerSub': 'OCR-powered resume analysis',
    'premiumTools': '✨ Premium Tools',
    'jdQuestionGen': 'JD Question Generator',
    'jdQuestionGenSub': 'Paste a JD → AI creates tailored questions',
    'companyResearch': 'Company Research AI',
    'companyResearchSub': 'AI-powered company interview insights',
    'salaryNegotiation': 'Salary Negotiation',
    'salaryNegotiationSub': 'Practice negotiating with AI HR manager',
    'sessionComparison': 'Session Comparison',
    'sessionComparisonSub': 'Compare Before vs After performance',
    'pacingCoach': 'Pacing Coach',
    'pacingCoachSub': 'Train your answer timing (Golden Zone)',
    'resumeCard': 'Resume Card',
    'resumeCardSub': 'Create digital resume QR card',
    'quickAccess': 'Quick Access',
    'interviewChecklist': 'Interview Checklist',
    'interviewChecklistSub': 'Pre-interview preparation',
    'knowledgeBase': 'Knowledge Base',
    'knowledgeBaseSub': 'Interview tips & strategies',
    'recentActivity': 'Recent Activity',
    'practice': 'Practice',
    'chooseMode': 'Choose your training mode',

    // Onboarding
    'skip': 'Skip',
    'getStarted': 'Get Started',
    'onboard1Title': 'AI-Powered Coaching',
    'onboard1Sub': 'Practice with an intelligent AI coach that adapts to your skill level and provides real-time, personalized feedback.',
    'onboard2Title': 'Voice Interview',
    'onboard2Sub': 'Answer questions using your voice. Speech-to-Text technology captures your responses for AI evaluation.',
    'onboard3Title': 'Confidence Tracking',
    'onboard3Sub': 'ML Kit face detection monitors your confidence in real-time — eye contact, smile, and posture analysis.',
    'onboard4Title': 'Gamified Learning',
    'onboard4Sub': 'Earn XP, unlock badges, maintain streaks, and level up from Beginner to Interview God!',

    // Interview
    'setupInterview': 'Setup Interview',
    'position': 'Position',
    'company': 'Company',
    'level': 'Level',
    'questionType': 'Question Type',
    'questionCount': 'Questions',
    'language': 'Language',
    'startInterview': 'Start Interview',
    'submitAnswer': 'Submit Answer',
    'nextQuestion': 'Next Question',
    'finishInterview': 'Finish Interview',
    'typeYourAnswer': 'Type your answer here...',
    'interviewResult': 'Interview Result',
    'overallScore': 'Overall Score',
    'feedback': 'Feedback',
    'strengths': 'Strengths',
    'weaknesses': 'Areas to Improve',
    'questionLabel': 'Question',
    'junior': 'Junior',
    'mid': 'Mid-Level',
    'senior': 'Senior',
    'behavioral': 'Behavioral',
    'technical': 'Technical',
    'mixed': 'Mixed',
    'viewResult': 'View Result',
    'congratulations': 'Congratulations! 🎉',
    'keepPracticing': 'Keep practicing!',
    'backToHome': 'Back to Home',
    'perQuestion': 'Per Question Scores',

    // Settings
    'settings': 'Settings',
    'appearance': 'Appearance',
    'darkMode': 'Dark Mode',
    'darkTheme': 'Dark theme',
    'lightTheme': 'Light theme',
    'languageSetting': 'Language',
    'data': 'Data',
    'clearCache': 'Clear Cache',
    'clearCacheSub': 'Remove cached AI responses',
    'clearAllData': 'Clear All Data',
    'clearAllDataSub': 'Delete all sessions and data',
    'about': 'About',
    'version': 'Version 1.0.0',
    'builtWithFlutter': 'Clean Architecture + BLoC',
    'clearCacheDialog': 'This will clear all cached AI responses. Continue?',
    'clearAllDialog': 'This will delete ALL data. This cannot be undone.',

    // Analytics
    'analytics': 'Analytics',
    'history': 'History',
    'noSessionsYet': 'No sessions yet',
    'exportData': 'Export Data',
    'anScoreTrend': 'Score Trend',
    'anQuestionTypes': 'Question Types',
    'anByLevel': 'By Level',
    'anSessions': 'Sessions',
    'anAvgScore': 'Avg Score',
    'anBest': 'Best',
    'anQuestions': 'Questions',
    'anAiInsights': 'AI Insights',
    'anExportCsv': 'Export as CSV',
    'anExportCsvSub': 'Spreadsheet-compatible format',
    'anExportJson': 'Export as JSON',
    'anExportJsonSub': 'Developer-friendly format',
    'anShareSub': 'Share your progress report',
    'anInsightExcellent': 'Excellent! Your average score is above 80%. You\'re interview-ready!',
    'anInsightGood': 'Good progress! Focus on weaker areas to push past 80%.',
    'anInsightKeep': 'Keep practicing! Consistent practice will improve your scores.',
    'anInsightConsistent': 'Great consistency!',
    'anInsightMore': 'Complete more sessions to get better insights and track trends.',
    'anInsightTip': 'Tip: Practice with different question types for a well-rounded preparation.',
    'anCompleteToSee': 'Complete sessions to see trends',
    'anNoCategoryData': 'No category data',
    'anNoLevelData': 'No level data',
    'anSummaryCopied': 'Summary copied!',
    'anExportFailed': 'Export failed',
    'shareSummary': 'Share Summary',
    'performanceTrend': 'Performance Trend',
    'scoreDistribution': 'Score Distribution',
    'sessionsOverTime': 'Sessions Over Time',

    // Gamification
    'level1': 'Level',
    'achievements': 'Achievements',
    'leaderboard': 'Leaderboard',
    'xp': 'XP',
    'badges': 'Badges',
    'streak': 'Streak',
    'missions': 'Missions',
    'rank': 'Rank',
    'progress': 'Progress',

    // Bottom Nav
    'navHome': 'Home',
    'navAnalytics': 'Analytics',
    'navHistory': 'History',
    'navSettings': 'Settings',

    // Confidence
    'confidenceAnalysis': 'Confidence Analysis',
    'eyeContact': 'Eye Contact',
    'smile': 'Smile',
    'posture': 'Posture',
    'startCamera': 'Start Camera',
    'stopCamera': 'Stop Camera',
    'confidenceScore': 'Confidence Score',
    'tips': 'Tips',

    // AI Chat
    'chatCoach': 'AI Coach Chat',
    'typeMessage': 'Type a message...',
    'aiThinking': 'AI is thinking...',
    'chatWelcome': 'Hello! I\'m your interview coach. Ask me anything!',
    'clearChat': 'Clear Chat',

    // Resume
    'scanResume': 'Scan Resume',
    'takePhoto': 'Take Photo',
    'pickGallery': 'Pick from Gallery',
    'analyzing': 'Analyzing...',
    'resumeStrengths': 'Strengths',
    'resumeWeaknesses': 'Weaknesses',
    'resumeSuggestions': 'Suggestions',

    // Voice
    'voicePractice': 'Voice Practice',
    'tapToSpeak': 'Tap to speak',
    'listening': 'Listening...',
    'evaluating': 'Evaluating...',
    'yourAnswer': 'Your Answer',
    'aiFeedback': 'AI Feedback',

    // Knowledge
    'interviewTips': 'Interview Tips',
    'commonQuestions': 'Common Questions',
    'starMethod': 'STAR Method',
    'bodyLanguage': 'Body Language',
    'negotiationTips': 'Negotiation Tips',

    // Mock Scenarios
    'chooseScenario': 'Choose a Scenario',
    'scenarioDesc': 'Practice with realistic interview situations',

    // History
    'sessionHistory': 'Session History',
    'noHistory': 'No history yet. Start practicing!',
    'sessionDetail': 'Session Detail',
    'date': 'Date',
    'score': 'Score',
    'duration': 'Duration',

    // Checklist
    'preInterviewChecklist': 'Pre-Interview Checklist',
    'completed': 'Completed',
    'incomplete': 'Incomplete',

    // Personality
    'personalityType': 'Personality Type',
    'idealRoles': 'Ideal Roles',
    'growthAreas': 'Growth Areas',

    // Journey
    'journeyMap': 'Journey Map',
    'learningPath': 'Learning Path',
    'currentLevel': 'Current Level',
    'nextLevel': 'Next Level',

    // Skill Gap
    'skillGap': 'Skill Gap Analysis',
    'readiness': 'Readiness',
    'readinessScore': 'Readiness Score',

    // Skill Gap Details
    'sgNoData': 'No interview data yet. Complete interviews to see your skill analysis!',
    'sgNoScored': 'No scored answers yet. Answer questions and get AI feedback first!',
    'sgErrorLoading': 'Error loading data',
    'sgOverall': 'Overall',
    'sgWeakestFirst': 'Weakest skill first',
    'sgTips': 'Improvement Tips',
    'sgResources': 'Recommended Resources',
    'sgBehavioral': 'Behavioral',
    'sgTechnical': 'Technical',
    'sgSituational': 'Situational',
    'sgCommunication': 'Communication',
    'sgConsistency': 'Consistency',

    // Emotion
    'emotionTimeline': 'Emotion Timeline',

    // Heatmap
    'eyeContactHeatmap': 'Eye Contact Heatmap',

    // Home sections
    'secPerformance': 'Performance',
    'secAdvancedAnalytics': 'Advanced Analytics',
    'secRecords': 'Records',
    'subAnalyticsDashboard': 'Comprehensive performance metrics',
    'subSkillGap': 'Identify areas for improvement',
    'subReadinessScore': 'Overall interview preparedness',
    'subEyeContact': 'Visual gaze tracking analysis',
    'subEmotionTimeline': 'Real-time emotional state tracking',
    'subPersonality': 'AI-powered personality assessment',
    'subJourneyMap': 'Your complete training timeline',
    'subSessionHistory': 'Review all past interviews',
    'subLeaderboard': 'Compare with other candidates',

    // Checklist Items
    'cl24hBefore': '📅 24 Hours Before',
    'clResearchCompany': 'Research the company thoroughly',
    'clReviewJob': 'Review the job description',
    'clPrepareStories': 'Prepare 5 STAR method stories',
    'clPlanOutfit': 'Plan your outfit',
    'clCheckRoute': 'Check route / test video call link',
    'clPrepareQuestions': 'Prepare questions for the interviewer',
    'clReviewResume': 'Review your resume',
    'clSleepEarly': 'Get a good night\'s sleep',
    'cl1hBefore': '⏰ 1 Hour Before',
    'clEatLight': 'Eat a light meal',
    'clReviewNotes': 'Review your key talking points',
    'clChargeDevices': 'Charge phone / laptop',
    'clQuietSpace': 'Set up quiet interview space',
    'clTestCamera': 'Test camera & microphone',
    'clGatherMaterials': 'Gather pen, notepad, resume copy',
    'cl5minBefore': '🚀 5 Minutes Before',
    'clDeepBreaths': 'Take 5 deep breaths',
    'clPowerPose': 'Do a power pose (2 min)',
    'clSmile': 'Smile and relax your face',
    'clSilencePhone': 'Silence your phone',
    'clWaterReady': 'Have water nearby',
    'clPositiveThought': 'Think of 3 things you\'re grateful for',
    'clRememberName': 'Remember interviewer\'s name',
    'clOpenNotes': 'Open your cheat sheet / notes',
    'clFinalCheck': 'Final appearance check',
    'clJoinEarly': 'Join 2-3 minutes early',
    'clSavedLocal': '💾 Saved in local storage (Hive)',

    // Resume Scan UI
    'scanYourResume': 'Scan Your Resume',
    'aiWillAnalyze': 'AI will analyze and suggest interview questions',
    'camera': 'Camera',
    'photos': 'Photos',
    'scanningText': 'Scanning text...',
    'ocrScanComplete': 'OCR Scan Complete',
    'extractedText': 'Extracted Text',
    'showAll': '▼ Show all',
    'showLess': '▲ Show less',
    'atsAnalysisReport': 'ATS Analysis Report',
    'atsCompatibilityScore': 'ATS Compatibility Score',
    'excellent': 'Excellent',
    'fair': 'Fair',
    'overview': 'Overview',
    'formatCompliance': '📋 Format Compliance',
    'keywordAnalysis': '🔑 Keyword Analysis',
    'keywordsFoundLabel': '✅ Keywords Found',
    'missingKeywords': '❌ Missing Keywords (Add these!)',
    'areasToImprove': 'Areas to Improve',
    'actionItems': 'Action Items',
    'interviewQuestions': 'Interview Questions',
    'scanFailed': 'Scan failed',
    'atsAnalyzing': 'ATS is analyzing your resume...',
    'contactInfo': '📧 Contact Info',
    'summaryObjective': '📝 Summary / Objective',
    'education': '🎓 Education',
    'workExperience': '💼 Work Experience',
    'skillsSection': '🛠️ Skills Section',
    'properLength': '📏 Proper Length',
    'measurableAchievements': '🏆 Measurable Achievements',
    'selectPhoto': 'Select Photo',

    // AI Chat Coach
    'chatCoachTitle': 'AI Coach',
    'chatCoachOnline': 'Online',
    'chatCoachWelcome': 'Hi! I\'m your AI Interview Coach 🎯\n\nI can help you with:\n• Interview question practice\n• STAR method guidance\n• Resume tips\n• Salary negotiation\n\nWhat would you like to work on?',
    'chatCoachHint': 'Ask your AI coach...',
    'chatCoachError': 'Sorry, I encountered an error. Please try again! 🔄',
    'chatQ1': '💡 How to answer "Tell me about yourself"?',
    'chatQ2': '🎯 Tips for behavioral interviews',
    'chatQ3': '🧠 How to use the STAR method',
    'chatQ4': '💪 How to negotiate salary',
    'chatQ5': '📝 Common interview mistakes',
    'profAccount': 'Account',
    'profAchievements': 'Achievements',
    'profBadgesEarned': 'badges earned',
    'profLearningPath': 'Learning Path',
    'profTrackProgress': 'Track your learning progress',
    'profSettings': 'Settings',
    'profSettingsSub': 'Theme, preferences & data',
    'profSignOut': 'Sign out',
    'profXpToNext': 'XP to next level',
    'profClearAllTitle': 'Clear All Data?',
    'profClearAllBody': 'This will permanently delete all sessions, questions, and cached data. This action cannot be undone.',
    'profDeleteAll': 'Delete All',
    'profAllCleared': 'All data cleared ✓',
    'achSessions': 'Sessions',
    'achStreak': 'Streak',
    'achBest': 'Best',
    'achBadges': 'Badges',
    'achDayStreak': 'Day Streak!',
    'achStartStreak': 'Start Your Streak!',
    'achStreakKeep': 'Keep it up! Practice daily to maintain your streak.',
    'achStreakStart': 'Complete an interview today to start your streak!',
    'achUnlocked': 'unlocked',
    'achXpToNext': 'XP to next level',
    'achLevel': 'Level',
    'lpProgress': 'Progress from real data',
    'lpFoundation': 'Foundation',
    'lpBuildingSkills': 'Building Skills',
    'lpIntermediate': 'Intermediate',
    'lpAdvanced': 'Advanced',
    'lpMaster': 'Master',
    'lpM_f1': 'Complete your first interview',
    'lpM_f2': 'Read the Knowledge Base',
    'lpM_f3': 'Try the AI Chat Coach',
    'lpM_f4': 'Review your first feedback',
    'lpM_b1': 'Complete 3 interviews',
    'lpM_b2': 'Try Voice Interview',
    'lpM_b3': 'Build a 3-day streak',
    'lpM_b4': 'Score above 60 on any question',
    'lpM_i1': 'Complete 5 interviews',
    'lpM_i2': 'Try all question types (behavioral, technical, situational)',
    'lpM_i3': 'Use Resume Scan',
    'lpM_i4': 'Reach Level 3',
    'lpM_i5': 'Build a 7-day streak',
    'lpM_a1': 'Complete 10 interviews',
    'lpM_a2': 'Score above 80 consistently',
    'lpM_a3': 'Try Pressure Interview scenario',
    'lpM_a4': 'Reach Level 5',
    'lpM_a5': 'Export your data (CSV/JSON)',
    'lpM_m1': 'Complete 25 interviews',
    'lpM_m2': 'Reach Level 7+',
    'lpM_m3': 'Build a 30-day streak',
    'lpM_m4': 'Score above 90 on 3 questions',
    'lpM_m5': 'Full Readiness Score above 80%',
    'badgeFirstSteps': 'First Steps',
    'badgeFirstStepsDesc': 'Complete your first interview',
    'badgeGettingSerious': 'Getting Serious',
    'badgeGettingSeriousDesc': 'Complete 5 interviews',
    'badgeDedicated': 'Dedicated',
    'badgeDedicatedDesc': 'Complete 10 interviews',
    'badgeCommitted': 'Committed',
    'badgeCommittedDesc': 'Complete 25 interviews',
    'badgeInterviewKing': 'Interview King',
    'badgeInterviewKingDesc': 'Complete 50 interviews',
    'badgeHighAchiever': 'High Achiever',
    'badgeHighAchieverDesc': 'Score 90% or higher',
    'badgeExcellence': 'Excellence',
    'badgeExcellenceDesc': 'Score 95% or higher',
    'badgePerfection': 'Perfection',
    'badgePerfectionDesc': 'Achieve a perfect score',
    'badge3DayStreak': '3-Day Streak',
    'badge3DayStreakDesc': 'Practice 3 days in a row',
    'badgeWeekWarrior': 'Week Warrior',
    'badgeWeekWarriorDesc': 'Practice 7 days in a row',
    'badgeMonthlyMaster': 'Monthly Master',
    'badgeMonthlyMasterDesc': 'Practice 30 days in a row',

    // Misc Page Labels
    'startConversation': 'Start a conversation!',
    'summaryCopied': '📋 Summary copied!',
    'exportedSessions': 'Exported sessions',
    'exportFailed': 'Export failed',
    'interviewJourney': 'Interview Journey',
    'personalityAnalysis': 'Personality Analysis',
    'analyzedByAI': '🤖 Analyzed by AI from your real interview answers',
    'tryAgain': 'Try Again',
    'readinessScoreTitle': 'Readiness Score',
    'rsInterviewReadiness': 'Interview Readiness',
    'rsSkillBreakdown': 'Skill Breakdown',
    'rsDetailedBreakdown': 'Detailed Breakdown',
    'rsNextSteps': 'Next Steps',
    'rsReady': 'Ready to Crush It!',
    'rsAlmostReady': 'Almost Ready',
    'rsGettingThere': 'Getting There',
    'rsKeepPracticing': 'Keep Practicing',
    'rsJustStarting': 'Just Starting',
    'rsPractice': 'Practice',
    'rsPerformance': 'Performance',
    'rsConsistency': 'Consistency',
    'rsLevel': 'Level',
    'rsExperience': 'Experience',
    'rsRec1Low': 'Complete at least 5 practice sessions',
    'rsRec2Low': 'Build a 3-day streak for consistency',
    'rsRec3Low': 'Focus on STAR method answers',
    'rsRec1Mid': 'Aim for scores above 80% consistently',
    'rsRec2Mid': 'Try different interview scenarios',
    'rsRec3Mid': 'Practice with Voice Interview',
    'rsRec1High': 'You\'re almost interview-ready!',
    'rsRec2High': 'Try Pressure Interview scenario',
    'rsRec3High': 'Do a full Video Interview simulation',
    'skillGapAnalysis': 'Skill Gap Analysis',
    'calculatedFromData': 'Calculated from your real interview data',
    'yourSkillProfile': 'Your Skill Profile',
    'interviewScenarios': 'Interview Scenarios',
    'practiceAgain': 'Practice Again',
    'interview': 'Interview',
    'realDataLabel': 'Real Data',
    'useConfidenceFirst': 'Use the Confidence Tracking feature first\nto record face data with your camera.',
    'great': 'Great!',
    'improve': 'Improve',
    'perQuestionScores': '📋 Per-Question Scores',
    'fromRealHistory': '📊 From your real interview history',
    'noFlashcards': 'No flashcards available',
    'fcQuestion': 'QUESTION',
    'fcIdealAnswer': 'IDEAL ANSWER',
    'fcYourAnswer': 'YOUR ANSWER',
    'fcTapReveal': 'Tap to reveal ideal answer',
    'fcTapQuestion': 'Tap to see question',
    'fcScore': 'Score',
    'fcNoDataYet': 'No interview data yet. Complete interviews to generate personalized flashcards!',
    'fcNoAnswered': 'No answered questions found. Complete an interview first!',
    'clearCacheQuestion': 'Clear Cache?',
    'clearCacheBody': 'Cached AI responses will be removed. This won\'t delete your interview history.',
    'cacheCleared': 'Cache cleared ✓',
    'clear': 'Clear',
    'unlocked': 'unlocked',
    'yourXpStats': 'Your XP & stats from real data',
    'sessions': 'sessions',
    'progressFromData': 'Progress from real data',
    'questionsGenerated': 'questions generated',
    'words': 'words',
    'lines': 'lines',
    'blocks': 'blocks',

    // JD Questions
    'pasteJD': 'Paste the full job description here...',
    'generateQuestions': 'Generate Questions',
    'generating': 'Generating...',
    'tailoredQuestions': 'Tailored Questions',
    'keySkillsRequired': 'Key Skills Required',
    'preparationTips': 'Preparation Tips',
    'jdPasteTitle': 'Paste a Job Description',
    'jdPasteSubtitle': 'AI will generate tailored interview questions',
    'jdQuestionsGenerated': 'questions generated',

    // Salary
    'salaryDiffEasy': 'Friendly HR',
    'salaryDiffEasyDesc': 'Flexible and willing to meet your expectations',
    'salaryDiffMedium': 'Balanced Manager',
    'salaryDiffMediumDesc': 'Open to discussion but has clear limits',
    'salaryDiffHard': 'Tough Negotiator',
    'salaryDiffHardDesc': 'Budget-conscious, pushes back firmly',
    'startNegotiation': 'Start Negotiation',
    'selectDifficulty': 'Select Difficulty',
    'salarySimTitle': 'Salary Negotiation Simulator',
    'salarySimSub': 'Practice negotiating with an AI HR manager',
    'yourCounterOffer': 'Your counter-offer...',
    'hrManager': 'HR Manager',
    'salaryWelcome': 'Welcome! I\'m the HR Manager. We\'d like to offer you this position. Let\'s discuss the compensation package. What are your salary expectations?',
    'salaryConnError': 'Connection error. Please try again.',
    'salaryFriendly': 'Friendly',
    'salaryTough': 'Tough',
    'salaryBalanced': 'Balanced',

    // Comparison
    'compareSessions': 'Compare Sessions',
    'sessionBefore': 'Session A (Before)',
    'sessionAfter': 'Session B (After)',
    'selectSession': 'Select...',
    'improved': 'Improved! 🎉',
    'needsWork': 'Needs work 💪',
    'detailComparison': 'Detail Comparison',
    'greatProgress': 'Great Progress!',
    'tipsForImprovement': 'Tips for Improvement',
    'needTwoSessions': 'Need at least 2 sessions to compare',

    // Company Research
    'researchCompanyTitle': 'Company Research AI',
    'researchAnyCompany': 'Research Any Company',
    'companyName': 'Company Name',
    'positionOptional': 'Position (optional)',
    'researching': 'Researching...',
    'researchBtn': 'Research Company',
    'crHeroSubtitle': 'Get AI-powered insights for interview prep',
    'cultureValues': 'Culture & Values',
    'interviewStyle': 'Interview Style',
    'interviewTipsLabel': 'Interview Tips',
    'whatTheyLookFor': 'What They Look For',
    'funFact': 'Fun Fact',

    // Pacing
    'goldenZone': 'Golden Zone (60-120s)',
    'startAnswer': 'Start Answer',
    'stopSave': 'Stop & Save',
    'answerTimes': 'Answer Times',
    'pacingTips': 'Pacing Tips',
    'buildingUp': 'Building Up...',
    'goldenZoneLabel': 'Golden Zone!',
    'wrappingUp': 'Wrapping Up...',
    'tooLong': 'Too Long!',
    'ready': 'Ready',
    'perfect': 'Perfect!',
    'tooShort': 'Too short',
    'tooLongLabel': 'Too long',
    'pacingTip1': 'Aim for 60-120 seconds per answer (Golden Zone)',
    'pacingTip2': 'Use the STAR method to structure your response',
    'pacingTip3': 'Start with 10s context, 30s action detail, 15s results',
    'pacingTip4': 'Practice signaling your ending: "To summarize..."',
    'answerLabel': 'Answer',

    // QR Card
    'digitalResumeCard': 'Digital Resume Card',
    'createShareableCard': 'Create your shareable digital card',
    'generateCard': 'Generate Card ✨',
    'scanToSave': 'Scan to save contact',
    'keySkills': 'Key Skills (comma-separated)',
    'phone': 'Phone',
    'linkedinUrl': 'LinkedIn URL',
    'jobTitle': 'Job Title',

    // Knowledge Base
    'kbForYou': 'For You',
    'kbStar': 'STAR',
    'kbTips': 'Tips',
    'kbIndustry': 'Industry',
    'kbPersonalInsights': 'Personalized Insights',
    'kbBasedOnSessions': 'Based on {n} practice sessions',
    'kbCompleteToUnlock': 'Complete a session to unlock insights',
    'kbAvgScore': 'Avg Score',
    'kbSessions': 'Sessions',
    'kbFocus': 'Focus',
    'kbAiCoach': 'AI Personal Coach',
    'kbAiCoachSub': 'Personalized tips from your performance data',
    'kbRegenerate': 'Regenerate Tips',
    'kbGenerateAi': 'Generate AI Tips',
    'kbRecommended': 'Recommended for You',
    'kbFocusArea': 'Focus area: {area}',
    'kbRecentPerf': 'Recent Performance',
    'kbStrengthLabel': 'Strength: {s}',
    'kbStartJourney': 'Start Your Journey',
    'kbStartJourneySub': 'Complete your first practice interview to unlock personalized recommendations.',
    'kbStarTitle': 'STAR Method',
    'kbStarSubtitle': 'The gold standard for behavioral interview answers',
    'kbSituation': 'Situation',
    'kbSituationDesc': 'Set the scene — describe context and background clearly.',
    'kbSituationEx': 'In my previous role as a product manager at XYZ Corp, we faced a 20% increase in customer churn over two consecutive quarters...',
    'kbTask': 'Task',
    'kbTaskDesc': 'Explain what you needed to accomplish.',
    'kbTaskEx': 'I was tasked with identifying the root cause and implementing a solution to reduce churn by at least 15% within Q2.',
    'kbAction': 'Action',
    'kbActionDesc': 'Detail the specific steps you took.',
    'kbActionEx': 'I analyzed 6 months of user data, conducted 20+ exit interviews, identified 3 key pain points in onboarding, and redesigned the first-week experience with A/B testing.',
    'kbResult': 'Result',
    'kbResultDesc': 'Share measurable outcomes.',
    'kbResultEx': 'This led to a 22% reduction in churn, 15% increase in user activation, and saved approximately \$200K annually.',
    'kbExample': 'Example',
    'kbBestPractices': 'Best Practices',
    'kbDoSpecific': 'Use specific numbers and metrics',
    'kbDoYourActions': 'Focus on YOUR actions, not the team\'s',
    'kbDoKeepTime': 'Keep answers 90 seconds to 2 minutes',
    'kbDontVague': '"I work well with others" — too vague',
    'kbDontBadmouth': '"My boss was terrible" — never badmouth',
    'kbDontNoQuestion': '"No questions" — always prepare questions',
    'kbPowerPhrases': 'Power Phrases',
    'kbCommonMistakes': 'Common Mistakes',
    'kbAdvancedTactics': 'Advanced Tactics',
    'kbShowImpact': 'Show Impact',
    'kbShowImpactDesc': 'Quantify your achievements',
    'kbShowGrowth': 'Show Growth',
    'kbShowGrowthDesc': 'Demonstrate continuous learning',
    'kbShowFit': 'Show Cultural Fit',
    'kbShowFitDesc': 'Connect to the company\'s values',
    'kbShowInit': 'Show Initiative',
    'kbShowInitDesc': 'Demonstrate proactiveness',
    'kbTooVague': 'Too Vague',
    'kbNegativity': 'Negativity',
    'kbUnprepared': 'Unprepared',
    'kbOverRehearsed': 'Over-Rehearsed',
    'kb2MinRule': '2-Minute Rule',
    'kbMirror': 'Mirror Technique',
    'kbPause': 'The Pause',
    'kbFollowUp': 'Follow-Up Email',
    'kbPortfolio': 'Portfolio Proof',
    'kbTech': 'Technology & Software',
    'kbFinance': 'Finance & Banking',
    'kbMarketing': 'Marketing & Creative',
    'kbHealthcare': 'Healthcare',
    'kbConsulting': 'Consulting',
    'kbTopics': '{n} topics',
    'kbFocusAreas': '{n} focus areas',
    'kbShowImpactEx': '"Increased revenue by 30%" · "Reduced costs by \$50K" · "Led a team of 8" · "Delivered 2 weeks ahead"',
    'kbShowGrowthEx': '"Through this experience, I learned..." · "I actively sought feedback and improved by..."',
    'kbShowFitEx': '"This aligns with my passion for..." · "Your company\'s mission resonates with me because..."',
    'kbShowInitEx': '"I identified an opportunity to..." · "Without being asked, I..." · "I proposed a new approach that..."',
    'kbTooVagueSub': 'Avoid generic answers',
    'kbTooVagueEx': 'Instead of "I work well with others"\nSay: "I coordinated with 4 cross-functional teams to ship a feature 2 weeks early"',
    'kbNegativitySub': 'Never badmouth employers',
    'kbNegativityEx': 'Instead of "My boss was terrible"\nSay: "I learned to adapt to different management styles and communicate proactively"',
    'kbUnpreparedSub': 'Always have questions ready',
    'kbUnpreparedEx': 'Instead of "I have no questions"\nAsk: "What does success look like in the first 90 days?"',
    'kbOverRehearsedSub': 'Don\'t sound scripted',
    'kbOverRehearsedEx': 'Instead of memorizing word-for-word, practice key bullet points and let the conversation flow naturally.',
    'kb2MinRuleSub': 'Concise and structured',
    'kb2MinRuleEx': 'Keep each answer between 90 seconds and 2 minutes. Use STAR format to stay focused.',
    'kbMirrorSub': 'Build rapport naturally',
    'kbMirrorEx': 'Subtly match the interviewer\'s energy, pace, and body language.',
    'kbPauseSub': 'Think before answering',
    'kbPauseEx': 'Take 3-5 seconds before responding. Say "That\'s a great question, let me think..."',
    'kbFollowUpSub': 'Professional close',
    'kbFollowUpEx': 'Send a personalized thank-you within 24 hours. Reference specific conversation points.',
    'kbPortfolioSub': 'Show, don\'t just tell',
    'kbPortfolioEx': 'Bring work samples or a portfolio. Visual proof is significantly more compelling.',
    'kbTech1': 'Prepare for system design and architecture discussions',
    'kbTech2': 'Practice coding challenges and algorithms',
    'kbTech3': 'Review data structures and complexity analysis',
    'kbTech4': 'Prepare behavioral stories about tech projects',
    'kbTech5': 'Research the company\'s tech stack and engineering culture',
    'kbTech6': 'Be ready to discuss scalability and trade-offs',
    'kbFinance1': 'Study market analysis and financial modeling',
    'kbFinance2': 'Practice case studies and brain teasers',
    'kbFinance3': 'Know current market trends and economic indicators',
    'kbFinance4': 'Prepare for risk assessment scenarios',
    'kbFinance5': 'Be ready for estimation and mental math questions',
    'kbFinance6': 'Understand regulatory compliance frameworks',
    'kbMarketing1': 'Prepare a portfolio of past campaigns and results',
    'kbMarketing2': 'Know key metrics: ROI, CAC, LTV, conversion rates',
    'kbMarketing3': 'Be ready to discuss brand strategy and positioning',
    'kbMarketing4': 'Practice creative problem-solving scenarios',
    'kbMarketing5': 'Show data-driven decision making capability',
    'kbMarketing6': 'Discuss trends: social media, AI in marketing, analytics',
    'kbHealthcare1': 'Focus on patient outcomes and safety protocols',
    'kbHealthcare2': 'Prepare for compliance and ethics scenarios',
    'kbHealthcare3': 'Demonstrate team collaboration and communication',
    'kbHealthcare4': 'Discuss evidence-based decision making',
    'kbHealthcare5': 'Know regulatory frameworks (HIPAA, etc.)',
    'kbHealthcare6': 'Be ready for conflict resolution examples',
    'kbConsulting1': 'Master case interview frameworks',
    'kbConsulting2': 'Practice market sizing and estimation questions',
    'kbConsulting3': 'Show structured problem-solving approach',
    'kbConsulting4': 'Prepare examples of client-facing work',
    'kbConsulting5': 'Demonstrate analytical and strategic thinking',
    'kbConsulting6': 'Be ready for rapid-fire and pressure questions',
    // Mock Scenarios
    'msChooseChallenge': 'Choose Your Challenge',
    'msSubtitle': 'Practice with realistic interview scenarios',
    'msBeginner': 'Beginner',
    'msIntermediate': 'Intermediate',
    'msAdvanced': 'Advanced',
    'msExpert': 'Expert',
    'msStandard': 'Standard Interview',
    'msStandardInfo': '5 questions · 30 min · Mixed types',
    'msStandardDesc': 'Classic one-on-one interview with behavioral and technical questions.',
    'msPanel': 'Panel Interview',
    'msPanelInfo': '7 questions · 45 min · Multi-perspective',
    'msPanelDesc': 'Face a panel of interviewers with diverse question styles and follow-ups.',
    'msRapidFire': 'Rapid-Fire Round',
    'msRapidFireInfo': '10 questions · 15 min · Quick answers',
    'msRapidFireDesc': 'Think fast! Answer rapid-fire questions with tight time limits.',
    'msBehavioral': 'Behavioral Deep-Dive',
    'msBehavioralInfo': '5 questions · 40 min · STAR focused',
    'msBehavioralDesc': 'In-depth behavioral questions requiring detailed STAR method responses.',
    'msCaseStudy': 'Case Study',
    'msCaseStudyInfo': '3 questions · 60 min · Problem-solving',
    'msCaseStudyDesc': 'Solve real business cases and explain your thought process step by step.',
    'msPressure': 'Pressure Interview',
    'msPressureInfo': '8 questions · 20 min · High stress',
    'msPressureDesc': 'Challenging questions designed to test your composure under pressure.',
  };

  static const _th = <String, String>{
    // General
    'appName': 'InterviewAce',
    'ok': 'ตกลง',
    'cancel': 'ยกเลิก',
    'save': 'บันทึก',
    'delete': 'ลบ',
    'reset': 'รีเซ็ต',
    'error': 'ข้อผิดพลาด',
    'success': 'สำเร็จ',
    'loading': 'กำลังโหลด...',
    'retry': 'ลองใหม่',
    'next': 'ถัดไป',
    'back': 'กลับ',
    'done': 'เสร็จ',
    'close': 'ปิด',
    'search': 'ค้นหา',
    'noData': 'ไม่มีข้อมูล',
    'comingSoon': 'เร็วๆ นี้',
    'or_': 'หรือ',

    // Auth
    'login': 'เข้าสู่ระบบ',
    'register': 'สมัครสมาชิก',
    'email': 'อีเมล',
    'password': 'รหัสผ่าน',
    'fullName': 'ชื่อ-นามสกุล',
    'confirmPassword': 'ยืนยันรหัสผ่าน',
    'continueWithGoogle': 'เข้าสู่ระบบด้วย Google',
    'forgotPassword': 'ลืมรหัสผ่าน?',
    'dontHaveAccount': 'ยังไม่มีบัญชี?',
    'alreadyHaveAccount': 'มีบัญชีอยู่แล้ว?',
    'signUp': 'สมัครสมาชิก',
    'signIn': 'เข้าสู่ระบบ',
    'welcomeBack': 'ยินดีต้อนรับกลับ',
    'createAccount': 'สร้างบัญชี',
    'loginSubtitle': 'เข้าสู่ระบบเพื่อเตรียมสัมภาษณ์',
    'registerSubtitle': 'เริ่มเตรียมตัวสัมภาษณ์กับเรา',
    'enterEmail': 'กรอกอีเมลของคุณ',
    'enterPassword': 'กรอกรหัสผ่าน',
    'enterFullName': 'กรอกชื่อ-นามสกุล',
    'reenterPassword': 'กรอกรหัสผ่านอีกครั้ง',

    // Home
    'home': 'หน้าหลัก',
    'goodMorning': 'สวัสดีตอนเช้า',
    'goodAfternoon': 'สวัสดีตอนบ่าย',
    'goodEvening': 'สวัสดีตอนเย็น',
    'readyToPractice': 'พร้อมฝึกซ้อมมั้ย?',
    'quickInsights': 'สรุปผลด่วน',
    'totalSessions': 'ฝึกทั้งหมด',
    'avgScore': 'คะแนน TB',
    'bestScore': 'คะแนนสูงสุด',
    'currentStreak': 'ต่อเนื่อง',
    'days': 'วัน',
    'skillRadar': 'เรดาร์ทักษะ',
    'interviewModes': 'โหมดสัมภาษณ์',
    'textInterview': 'สัมภาษณ์แบบพิมพ์',
    'textInterviewSub': 'AI สร้างคำถาม + ตอบด้วยการพิมพ์',
    'voiceInterview': 'สัมภาษณ์ด้วยเสียง',
    'voiceInterviewSub': 'ตอบด้วยเสียงพร้อมระบบรู้จำเสียง',
    'mockScenarios': 'สถานการณ์จำลอง',
    'mockScenariosSub': 'จำลองสัมภาษณ์ตามสถานการณ์จริง',
    'trainingTools': 'เครื่องมือฝึกซ้อม',
    'confidenceTracker': 'วัดความมั่นใจ',
    'confidenceTrackerSub': 'วิเคราะห์ใบหน้าและภาษากาย',
    'aiCoachChat': 'แชทโค้ช AI',
    'aiCoachChatSub': 'ถามตอบกับ AI ผู้ช่วยสัมภาษณ์',
    'flashcards': 'แฟลชการ์ด',
    'flashcardsSub': 'ทบทวนคำถามจาก session ก่อนหน้า',
    'resumeScanner': 'สแกนเรซูเม่',
    'resumeScannerSub': 'วิเคราะห์เรซูเม่ด้วย OCR + AI',
    'premiumTools': '✨ เครื่องมือพรีเมียม',
    'jdQuestionGen': 'สร้างคำถามจาก JD',
    'jdQuestionGenSub': 'วาง JD → AI สร้างคำถามเฉพาะตำแหน่ง',
    'companyResearch': 'วิจัยบริษัท AI',
    'companyResearchSub': 'AI วิเคราะห์บริษัทให้เตรียมสัมภาษณ์',
    'salaryNegotiation': 'จำลองเจรจาเงินเดือน',
    'salaryNegotiationSub': 'ฝึกเจรจากับ AI HR Manager',
    'sessionComparison': 'เปรียบเทียบ Session',
    'sessionComparisonSub': 'เปรียบเทียบก่อน vs หลังฝึก',
    'pacingCoach': 'โค้ชจับเวลา',
    'pacingCoachSub': 'ฝึกจังหวะตอบ (60-120 วินาที)',
    'resumeCard': 'การ์ดเรซูเม่',
    'resumeCardSub': 'สร้างการ์ดนามบัตรดิจิทัล + QR',
    'quickAccess': 'เข้าถึงด่วน',
    'interviewChecklist': 'รายการเตรียมตัว',
    'interviewChecklistSub': 'เตรียมพร้อมก่อนสัมภาษณ์',
    'knowledgeBase': 'คลังความรู้',
    'knowledgeBaseSub': 'เทคนิคและกลยุทธ์สัมภาษณ์',
    'recentActivity': 'กิจกรรมล่าสุด',
    'practice': 'ฝึกซ้อม',
    'chooseMode': 'เลือกโหมดฝึกซ้อม',

    // Onboarding
    'skip': 'ข้าม',
    'getStarted': 'เริ่มต้น',
    'onboard1Title': 'โค้ชอัจฉริยะ AI',
    'onboard1Sub': 'ฝึกซ้อมกับ AI ที่ปรับตามระดับทักษะของคุณ และให้ข้อเสนอแนะแบบเรียลไทม์',
    'onboard2Title': 'สัมภาษณ์ด้วยเสียง',
    'onboard2Sub': 'ตอบคำถามด้วยเสียง ระบบ Speech-to-Text จับคำตอบให้ AI ประเมิน',
    'onboard3Title': 'วัดความมั่นใจ',
    'onboard3Sub': 'ML Kit ตรวจจับใบหน้าแบบเรียลไทม์ — สบตา รอยยิ้ม และท่าทาง',
    'onboard4Title': 'ระบบ Gamification',
    'onboard4Sub': 'สะสม XP ปลดล็อคเหรียญ รักษา Streak และเลเวลอัพจาก Beginner สู่ Interview God!',

    // Interview
    'setupInterview': 'ตั้งค่าสัมภาษณ์',
    'position': 'ตำแหน่ง',
    'company': 'บริษัท',
    'level': 'ระดับ',
    'questionType': 'ประเภทคำถาม',
    'questionCount': 'จำนวนคำถาม',
    'language': 'ภาษา',
    'startInterview': 'เริ่มสัมภาษณ์',
    'submitAnswer': 'ส่งคำตอบ',
    'nextQuestion': 'คำถามถัดไป',
    'finishInterview': 'จบสัมภาษณ์',
    'typeYourAnswer': 'พิมพ์คำตอบของคุณที่นี่...',
    'interviewResult': 'ผลสัมภาษณ์',
    'overallScore': 'คะแนนรวม',
    'feedback': 'ข้อเสนอแนะ',
    'strengths': 'จุดแข็ง',
    'weaknesses': 'จุดที่ต้องปรับปรุง',
    'questionLabel': 'คำถาม',
    'junior': 'จูเนียร์',
    'mid': 'ระดับกลาง',
    'senior': 'ซีเนียร์',
    'behavioral': 'พฤติกรรม',
    'technical': 'เทคนิค',
    'mixed': 'ผสม',
    'viewResult': 'ดูผลลัพธ์',
    'congratulations': 'ยอดเยี่ยม! 🎉',
    'keepPracticing': 'ฝึกต่อไป!',
    'backToHome': 'กลับหน้าหลัก',
    'perQuestion': 'คะแนนรายข้อ',

    // Settings
    'settings': 'ตั้งค่า',
    'appearance': 'ธีม',
    'darkMode': 'โหมดมืด',
    'darkTheme': 'ธีมมืด',
    'lightTheme': 'ธีมสว่าง',
    'languageSetting': 'ภาษา',
    'data': 'ข้อมูล',
    'clearCache': 'ล้างแคช',
    'clearCacheSub': 'ลบข้อมูล AI ที่แคชไว้',
    'clearAllData': 'ลบข้อมูลทั้งหมด',
    'clearAllDataSub': 'ลบ session และข้อมูลทั้งหมด',
    'about': 'เกี่ยวกับ',
    'version': 'เวอร์ชัน 1.0.0',
    'builtWithFlutter': 'Clean Architecture + BLoC',
    'clearCacheDialog': 'จะล้างข้อมูล AI ที่แคชไว้ทั้งหมด ดำเนินการต่อ?',
    'clearAllDialog': 'จะลบข้อมูลทั้งหมด ไม่สามารถกู้คืนได้',

    // Analytics
    'analytics': 'วิเคราะห์',
    'history': 'ประวัติ',
    'noSessionsYet': 'ยังไม่มี session',
    'exportData': 'ส่งออกข้อมูล',
    'anScoreTrend': 'แนวโน้มคะแนน',
    'anQuestionTypes': 'ประเภทคำถาม',
    'anByLevel': 'ตามระดับ',
    'anSessions': 'Sessions',
    'anAvgScore': 'คะแนนเฉลี่ย',
    'anBest': 'สูงสุด',
    'anQuestions': 'คำถาม',
    'anAiInsights': 'วิเคราะห์จาก AI',
    'anExportCsv': 'ส่งออก CSV',
    'anExportCsvSub': 'รูปแบบสำหรับตารางคำนวณ',
    'anExportJson': 'ส่งออก JSON',
    'anExportJsonSub': 'รูปแบบสำหรับนักพัฒนา',
    'anShareSub': 'แชร์รายงานความก้าวหน้า',
    'anInsightExcellent': 'เยี่ยม! คะแนนเฉลี่ยเกิน 80% พร้อมสัมภาษณ์แล้ว!',
    'anInsightGood': 'ดีครับ! โฟกัสจุดอ่อนเพื่อดันเกิน 80%',
    'anInsightKeep': 'ฝึกต่อไป! คะแนนจะดีขึ้นเรื่อยๆ',
    'anInsightConsistent': 'ฝึกสม่ำเสมอดี!',
    'anInsightMore': 'ทำ session เพิ่มเพื่อดูแนวโน้มและติดตามพัฒนาการ',
    'anInsightTip': 'เคล็ดลับ: ฝึกหลายประเภทคำถามเพื่อเตรียมตัวรอบด้าน',
    'anCompleteToSee': 'ทำ session เพื่อดูแนวโน้ม',
    'anNoCategoryData': 'ไม่มีข้อมูลประเภท',
    'anNoLevelData': 'ไม่มีข้อมูลระดับ',
    'anSummaryCopied': 'คัดลอกสรุปแล้ว!',
    'anExportFailed': 'ส่งออกไม่สำเร็จ',
    'shareSummary': 'แชร์สรุป',
    'performanceTrend': 'แนวโน้มผลงาน',
    'scoreDistribution': 'การกระจายคะแนน',
    'sessionsOverTime': 'จำนวน Session ตามเวลา',

    // Gamification
    'level1': 'เลเวล',
    'achievements': 'ความสำเร็จ',
    'leaderboard': 'กระดานอันดับ',
    'xp': 'XP',
    'badges': 'เหรียญ',
    'streak': 'ต่อเนื่อง',
    'missions': 'ภารกิจ',
    'rank': 'อันดับ',
    'progress': 'ความก้าวหน้า',

    // Bottom Nav
    'navHome': 'หน้าหลัก',
    'navAnalytics': 'วิเคราะห์',
    'navHistory': 'ประวัติ',
    'navSettings': 'ตั้งค่า',

    // Confidence
    'confidenceAnalysis': 'วิเคราะห์ความมั่นใจ',
    'eyeContact': 'สบตา',
    'smile': 'รอยยิ้ม',
    'posture': 'ท่าทาง',
    'startCamera': 'เปิดกล้อง',
    'stopCamera': 'ปิดกล้อง',
    'confidenceScore': 'คะแนนความมั่นใจ',
    'tips': 'เคล็ดลับ',

    // AI Chat
    'chatCoach': 'แชทโค้ช AI',
    'typeMessage': 'พิมพ์ข้อความ...',
    'aiThinking': 'AI กำลังคิด...',
    'chatWelcome': 'สวัสดี! ฉันเป็นโค้ชสัมภาษณ์ของคุณ ถามอะไรก็ได้!',
    'clearChat': 'ล้างแชท',

    // Resume
    'scanResume': 'สแกนเรซูเม่',
    'takePhoto': 'ถ่ายรูป',
    'pickGallery': 'เลือกจากแกลเลอรี',
    'analyzing': 'กำลังวิเคราะห์...',
    'resumeStrengths': 'จุดแข็ง',
    'resumeWeaknesses': 'จุดอ่อน',
    'resumeSuggestions': 'ข้อเสนอแนะ',

    // Voice
    'voicePractice': 'ฝึกซ้อมด้วยเสียง',
    'tapToSpeak': 'แตะเพื่อพูด',
    'listening': 'กำลังฟัง...',
    'evaluating': 'กำลังประเมิน...',
    'yourAnswer': 'คำตอบของคุณ',
    'aiFeedback': 'ข้อเสนอแนะจาก AI',

    // Knowledge
    'interviewTips': 'เทคนิคสัมภาษณ์',
    'commonQuestions': 'คำถามยอดฮิต',
    'starMethod': 'เทคนิค STAR',
    'bodyLanguage': 'ภาษากาย',
    'negotiationTips': 'เทคนิคเจรจา',

    // Mock Scenarios
    'chooseScenario': 'เลือกสถานการณ์',
    'scenarioDesc': 'ฝึกซ้อมกับสถานการณ์สัมภาษณ์จริง',

    // History
    'sessionHistory': 'ประวัติ Session',
    'noHistory': 'ยังไม่มีประวัติ เริ่มฝึกซ้อมเลย!',
    'sessionDetail': 'รายละเอียด Session',
    'date': 'วันที่',
    'score': 'คะแนน',
    'duration': 'ระยะเวลา',

    // Checklist
    'preInterviewChecklist': 'เช็คลิสต์ก่อนสัมภาษณ์',
    'completed': 'เสร็จแล้ว',
    'incomplete': 'ยังไม่เสร็จ',

    // Personality
    'personalityType': 'ประเภทบุคลิกภาพ',
    'idealRoles': 'ตำแหน่งที่เหมาะ',
    'growthAreas': 'จุดที่ควรพัฒนา',

    // Journey
    'journeyMap': 'แผนที่การเดินทาง',
    'learningPath': 'เส้นทางการเรียนรู้',
    'currentLevel': 'เลเวลปัจจุบัน',
    'nextLevel': 'เลเวลถัดไป',

    // Skill Gap
    'skillGap': 'วิเคราะห์ช่องว่างทักษะ',
    'readiness': 'ความพร้อม',
    'readinessScore': 'คะแนนความพร้อม',

    // Skill Gap Details
    'sgNoData': 'ยังไม่มีข้อมูลสัมภาษณ์ ทำแบบสัมภาษณ์เพื่อดูการวิเคราะห์!',
    'sgNoScored': 'ยังไม่มีคำตอบที่ให้คะแนน ตอบคำถามและรับ feedback ก่อน!',
    'sgErrorLoading': 'โหลดข้อมูลผิดพลาด',
    'sgOverall': 'ภาพรวม',
    'sgWeakestFirst': 'ทักษะอ่อนสุดแสดงก่อน',
    'sgTips': 'เคล็ดลับพัฒนา',
    'sgResources': 'แหล่งเรียนรู้แนะนำ',
    'sgBehavioral': 'พฤติกรรม',
    'sgTechnical': 'เทคนิค',
    'sgSituational': 'สถานการณ์',
    'sgCommunication': 'การสื่อสาร',
    'sgConsistency': 'ความสม่ำเสมอ',

    // Emotion
    'emotionTimeline': 'ไทม์ไลน์อารมณ์',

    // Heatmap
    'eyeContactHeatmap': 'Heatmap สบตา',

    // Home sections
    'secPerformance': 'ผลการฝึก',
    'secAdvancedAnalytics': 'วิเคราะห์ขั้นสูง',
    'secRecords': 'บันทึก',
    'subAnalyticsDashboard': 'สถิติผลงานครบด้าน',
    'subSkillGap': 'ระบุจุดที่ต้องพัฒนา',
    'subReadinessScore': 'ความพร้อมสัมภาษณ์โดยรวม',
    'subEyeContact': 'วิเคราะห์การสบตา',
    'subEmotionTimeline': 'ติดตามอารมณ์แบบเรียลไทม์',
    'subPersonality': 'วิเคราะห์บุคลิกภาพด้วย AI',
    'subJourneyMap': 'ไทม์ไลน์การฝึกทั้งหมด',
    'subSessionHistory': 'ดูประวัติการสัมภาษณ์',
    'subLeaderboard': 'เทียบกับผู้สมัครคนอื่น',

    // Checklist Items
    'cl24hBefore': '📅 24 ชั่วโมงก่อน',
    'clResearchCompany': 'ศึกษาข้อมูลบริษัทอย่างละเอียด',
    'clReviewJob': 'อ่านรายละเอียดตำแหน่งงาน',
    'clPrepareStories': 'เตรียมเรื่องเล่า STAR method 5 เรื่อง',
    'clPlanOutfit': 'เตรียมชุดที่จะใส่',
    'clCheckRoute': 'เช็คเส้นทาง / ทดสอบลิงก์วิดีโอคอล',
    'clPrepareQuestions': 'เตรียมคำถามสำหรับถามผู้สัมภาษณ์',
    'clReviewResume': 'ทบทวนเรซูเม่ของคุณ',
    'clSleepEarly': 'นอนหลับให้เพียงพอ',
    'cl1hBefore': '⏰ 1 ชั่วโมงก่อน',
    'clEatLight': 'ทานอาหารเบาๆ',
    'clReviewNotes': 'ทบทวนประเด็นสำคัญ',
    'clChargeDevices': 'ชาร์จโทรศัพท์ / แล็ปท็อป',
    'clQuietSpace': 'จัดเตรียมพื้นที่เงียบ',
    'clTestCamera': 'ทดสอบกล้องและไมโครโฟน',
    'clGatherMaterials': 'เตรียมปากกา สมุดจด สำเนาเรซูเม่',
    'cl5minBefore': '🚀 5 นาทีก่อน',
    'clDeepBreaths': 'หายใจลึกๆ 5 ครั้ง',
    'clPowerPose': 'ทำ Power Pose (2 นาที)',
    'clSmile': 'ยิ้มและผ่อนคลายใบหน้า',
    'clSilencePhone': 'ปิดเสียงโทรศัพท์',
    'clWaterReady': 'เตรียมน้ำดื่มไว้ใกล้มือ',
    'clPositiveThought': 'นึกถึง 3 สิ่งที่รู้สึกขอบคุณ',
    'clRememberName': 'จำชื่อผู้สัมภาษณ์',
    'clOpenNotes': 'เปิดโน้ต / สรุปย่อ',
    'clFinalCheck': 'เช็คหน้าตาครั้งสุดท้าย',
    'clJoinEarly': 'เข้าก่อนเวลา 2-3 นาที',
    'clSavedLocal': '💾 บันทึกในเครื่อง (Hive)',

    // Resume Scan UI
    'scanYourResume': 'สแกนเรซูเม่ของคุณ',
    'aiWillAnalyze': 'AI จะวิเคราะห์และแนะนำคำถามสัมภาษณ์',
    'camera': 'กล้อง',
    'photos': 'รูปภาพ',
    'scanningText': 'กำลังสแกนข้อความ...',
    'ocrScanComplete': 'สแกน OCR เสร็จสิ้น',
    'extractedText': 'ข้อความที่อ่านได้',
    'showAll': '▼ แสดงทั้งหมด',
    'showLess': '▲ แสดงน้อยลง',
    'atsAnalysisReport': 'รายงานวิเคราะห์ ATS',
    'atsCompatibilityScore': 'คะแนนความเข้ากันได้กับ ATS',
    'excellent': 'ยอดเยี่ยม',
    'fair': 'พอใช้',
    'overview': 'ภาพรวม',
    'formatCompliance': '📋 ความสมบูรณ์ของรูปแบบ',
    'keywordAnalysis': '🔑 วิเคราะห์คีย์เวิร์ด',
    'keywordsFoundLabel': '✅ คีย์เวิร์ดที่พบ',
    'missingKeywords': '❌ คีย์เวิร์ดที่ขาด (ควรเพิ่ม!)',
    'areasToImprove': 'จุดที่ควรปรับปรุง',
    'actionItems': 'สิ่งที่ต้องแก้ไข',
    'interviewQuestions': 'คำถามสัมภาษณ์',
    'scanFailed': 'สแกนล้มเหลว',
    'atsAnalyzing': 'ATS กำลังวิเคราะห์เรซูเม่ของคุณ...',
    'contactInfo': '📧 ข้อมูลติดต่อ',
    'summaryObjective': '📝 สรุป / วัตถุประสงค์',
    'education': '🎓 การศึกษา',
    'workExperience': '💼 ประสบการณ์ทำงาน',
    'skillsSection': '🛠️ ทักษะ',
    'properLength': '📏 ความยาวเหมาะสม',
    'measurableAchievements': '🏆 ผลงานที่วัดผลได้',
    'selectPhoto': 'เลือกรูปภาพ',

    // AI Chat Coach
    'chatCoachTitle': 'โค้ช AI',
    'chatCoachOnline': 'ออนไลน์',
    'chatCoachWelcome': 'สวัสดีครับ! ผมเป็นโค้ชสัมภาษณ์ AI 🎯\n\nผมช่วยคุณได้เรื่อง:\n• ฝึกตอบคำถามสัมภาษณ์\n• แนะนำเทคนิค STAR\n• ปรับปรุง Resume\n• เจรจาเงินเดือน\n\nอยากเริ่มจากเรื่องไหนครับ?',
    'chatCoachHint': 'ถามโค้ช AI ได้เลย...',
    'chatCoachError': 'ขออภัย เกิดข้อผิดพลาด ลองใหม่อีกครั้งครับ! 🔄',
    'chatQ1': '💡 ตอบ "เล่าเกี่ยวกับตัวเอง" ยังไงดี?',
    'chatQ2': '🎯 เคล็ดลับสัมภาษณ์เชิงพฤติกรรม',
    'chatQ3': '🧠 วิธีใช้ STAR Method',
    'chatQ4': '💪 เจรจาเงินเดือนยังไง',
    'chatQ5': '📝 ข้อผิดพลาดในการสัมภาษณ์',
    'profAccount': 'บัญชี',
    'profAchievements': 'ความสำเร็จ',
    'profBadgesEarned': 'เหรียญที่ได้',
    'profLearningPath': 'เส้นทางการเรียนรู้',
    'profTrackProgress': 'ติดตามความก้าวหน้าของคุณ',
    'profSettings': 'ตั้งค่า',
    'profSettingsSub': 'ธีม ค่ากำหนด และข้อมูล',
    'profSignOut': 'ออกจากระบบ',
    'profXpToNext': 'XP ถึงเลเวลถัดไป',
    'profClearAllTitle': 'ลบข้อมูลทั้งหมด?',
    'profClearAllBody': 'การดำเนินการนี้จะลบ sessions คำถาม และข้อมูลแคชทั้งหมดอย่างถาวร ไม่สามารถกู้คืนได้',
    'profDeleteAll': 'ลบทั้งหมด',
    'profAllCleared': 'ลบข้อมูลทั้งหมดแล้ว ✓',
    'achSessions': 'รอบที่ทำ',
    'achStreak': 'ต่อเนื่อง',
    'achBest': 'ดีสุด',
    'achBadges': 'เหรียญ',
    'achDayStreak': 'วันติดต่อ!',
    'achStartStreak': 'เริ่มสร้าง Streak!',
    'achStreakKeep': 'เยี่ยมมาก! ฝึกทุกวันเพื่อรักษา streak',
    'achStreakStart': 'ทำสัมภาษณ์วันนี้เพื่อเริ่ม streak!',
    'achUnlocked': 'ปลดล็อกแล้ว',
    'achXpToNext': 'XP ถึงเลเวลถัดไป',
    'achLevel': 'เลเวล',
    'lpProgress': 'ความคืบหน้าจากข้อมูลจริง',
    'lpFoundation': 'พื้นฐาน',
    'lpBuildingSkills': 'สร้างทักษะ',
    'lpIntermediate': 'ระดับกลาง',
    'lpAdvanced': 'ขั้นสูง',
    'lpMaster': 'เชี่ยวชาญ',
    'lpM_f1': 'ทำสัมภาษณ์ครั้งแรก',
    'lpM_f2': 'อ่านคลังความรู้',
    'lpM_f3': 'ลองใช้ AI Chat Coach',
    'lpM_f4': 'ดู feedback ครั้งแรก',
    'lpM_b1': 'ทำสัมภาษณ์ครบ 3 ครั้ง',
    'lpM_b2': 'ลองสัมภาษณ์ด้วยเสียง',
    'lpM_b3': 'สร้าง streak 3 วัน',
    'lpM_b4': 'ได้คะแนนเกิน 60 ในคำถามใดคำถามหนึ่ง',
    'lpM_i1': 'ทำสัมภาษณ์ครบ 5 ครั้ง',
    'lpM_i2': 'ลองคำถามทุกประเภท (พฤติกรรม, เทคนิค, สถานการณ์)',
    'lpM_i3': 'ใช้สแกนเรซูเม่',
    'lpM_i4': 'ถึงเลเวล 3',
    'lpM_i5': 'สร้าง streak 7 วัน',
    'lpM_a1': 'ทำสัมภาษณ์ครบ 10 ครั้ง',
    'lpM_a2': 'ได้คะแนนเกิน 80 สม่ำเสมอ',
    'lpM_a3': 'ลองสถานการณ์สัมภาษณ์แบบกดดัน',
    'lpM_a4': 'ถึงเลเวล 5',
    'lpM_a5': 'ส่งออกข้อมูล (CSV/JSON)',
    'lpM_m1': 'ทำสัมภาษณ์ครบ 25 ครั้ง',
    'lpM_m2': 'ถึงเลเวล 7+',
    'lpM_m3': 'สร้าง streak 30 วัน',
    'lpM_m4': 'ได้คะแนนเกิน 90 ใน 3 คำถาม',
    'lpM_m5': 'คะแนนความพร้อมรวมเกิน 80%',
    'badgeFirstSteps': 'ก้าวแรก',
    'badgeFirstStepsDesc': 'ทำสัมภาษณ์ครั้งแรก',
    'badgeGettingSerious': 'จริงจังแล้ว',
    'badgeGettingSeriousDesc': 'ทำสัมภาษณ์ครบ 5 ครั้ง',
    'badgeDedicated': 'ทุ่มเท',
    'badgeDedicatedDesc': 'ทำสัมภาษณ์ครบ 10 ครั้ง',
    'badgeCommitted': 'มุ่งมั่น',
    'badgeCommittedDesc': 'ทำสัมภาษณ์ครบ 25 ครั้ง',
    'badgeInterviewKing': 'ราชาสัมภาษณ์',
    'badgeInterviewKingDesc': 'ทำสัมภาษณ์ครบ 50 ครั้ง',
    'badgeHighAchiever': 'ผู้ทำคะแนนสูง',
    'badgeHighAchieverDesc': 'ได้คะแนน 90% ขึ้นไป',
    'badgeExcellence': 'ยอดเยี่ยม',
    'badgeExcellenceDesc': 'ได้คะแนน 95% ขึ้นไป',
    'badgePerfection': 'สมบูรณ์แบบ',
    'badgePerfectionDesc': 'ได้คะแนนเต็ม 100',
    'badge3DayStreak': 'ติดต่อ 3 วัน',
    'badge3DayStreakDesc': 'ฝึกติดต่อ 3 วัน',
    'badgeWeekWarrior': 'นักรบประจำสัปดาห์',
    'badgeWeekWarriorDesc': 'ฝึกติดต่อ 7 วัน',
    'badgeMonthlyMaster': 'เจ้าแห่งเดือน',
    'badgeMonthlyMasterDesc': 'ฝึกติดต่อ 30 วัน',

    // Misc Page Labels
    'startConversation': 'เริ่มบทสนทนา!',
    'summaryCopied': '📋 คัดลอกสรุปแล้ว!',
    'exportedSessions': 'ส่งออก session แล้ว',
    'exportFailed': 'ส่งออกล้มเหลว',
    'interviewJourney': 'เส้นทางสัมภาษณ์',
    'personalityAnalysis': 'วิเคราะห์บุคลิกภาพ',
    'analyzedByAI': '🤖 วิเคราะห์โดย AI จากคำตอบสัมภาษณ์จริงของคุณ',
    'tryAgain': 'ลองอีกครั้ง',
    'readinessScoreTitle': 'คะแนนความพร้อม',
    'rsInterviewReadiness': 'ความพร้อมสัมภาษณ์',
    'rsSkillBreakdown': 'วิเคราะห์ทักษะ',
    'rsDetailedBreakdown': 'รายละเอียด',
    'rsNextSteps': 'สิ่งที่ควรทำต่อ',
    'rsReady': 'พร้อมลุย!',
    'rsAlmostReady': 'เกือบพร้อมแล้ว',
    'rsGettingThere': 'กำลังไปได้ดี',
    'rsKeepPracticing': 'ฝึกต่อไป',
    'rsJustStarting': 'เพิ่งเริ่ม',
    'rsPractice': 'การฝึก',
    'rsPerformance': 'ผลงาน',
    'rsConsistency': 'ความสม่ำเสมอ',
    'rsLevel': 'ระดับ',
    'rsExperience': 'ประสบการณ์',
    'rsRec1Low': 'ทำแบบฝึกอย่างน้อย 5 รอบ',
    'rsRec2Low': 'สร้าง streak 3 วันติดต่อกัน',
    'rsRec3Low': 'โฟกัสการตอบแบบ STAR',
    'rsRec1Mid': 'ตั้งเป้าคะแนนเกิน 80% สม่ำเสมอ',
    'rsRec2Mid': 'ลองสถานการณ์สัมภาษณ์หลายรูปแบบ',
    'rsRec3Mid': 'ฝึกกับสัมภาษณ์ด้วยเสียง',
    'rsRec1High': 'คุณเกือบพร้อมแล้ว!',
    'rsRec2High': 'ลองสัมภาษณ์แบบกดดัน',
    'rsRec3High': 'ทำสัมภาษณ์วิดีโอเต็มรูปแบบ',
    'skillGapAnalysis': 'วิเคราะห์ช่องว่างทักษะ',
    'calculatedFromData': 'คำนวณจากข้อมูลสัมภาษณ์จริงของคุณ',
    'yourSkillProfile': 'โปรไฟล์ทักษะของคุณ',
    'interviewScenarios': 'สถานการณ์สัมภาษณ์',
    'practiceAgain': 'ฝึกซ้อมอีกครั้ง',
    'interview': 'สัมภาษณ์',
    'realDataLabel': 'ข้อมูลจริง',
    'useConfidenceFirst': 'ใช้ฟีเจอร์วัดความมั่นใจก่อน\nเพื่อบันทึกข้อมูลใบหน้าด้วยกล้อง',
    'great': 'ดีมาก!',
    'improve': 'ควรปรับปรุง',
    'perQuestionScores': '📋 คะแนนรายข้อ',
    'fromRealHistory': '📊 จากประวัติสัมภาษณ์จริงของคุณ',
    'noFlashcards': 'ยังไม่มีแฟลชการ์ด',
    'fcQuestion': 'คำถาม',
    'fcIdealAnswer': 'คำตอบในอุดมคติ',
    'fcYourAnswer': 'คำตอบของคุณ',
    'fcTapReveal': 'แตะเพื่อดูคำตอบในอุดมคติ',
    'fcTapQuestion': 'แตะเพื่อดูคำถาม',
    'fcScore': 'คะแนน',
    'fcNoDataYet': 'ยังไม่มีข้อมูลสัมภาษณ์ ทำแบบสัมภาษณ์ก่อนเพื่อสร้างแฟลชการ์ดเฉพาะคุณ!',
    'fcNoAnswered': 'ยังไม่พบคำถามที่ตอบแล้ว ทำแบบสัมภาษณ์ก่อนครับ!',
    'clearCacheQuestion': 'ล้างแคช?',
    'clearCacheBody': 'ข้อมูล AI ที่แคชไว้จะถูกลบ ประวัติสัมภาษณ์ไม่ได้ถูกลบ',
    'cacheCleared': 'ล้างแคชแล้ว ✓',
    'clear': 'ล้าง',
    'unlocked': 'ปลดล็อคแล้ว',
    'yourXpStats': 'XP และสถิติจากข้อมูลจริงของคุณ',
    'sessions': 'ครั้ง',
    'progressFromData': 'ความก้าวหน้าจากข้อมูลจริง',
    'questionsGenerated': 'คำถามที่สร้างแล้ว',
    'words': 'คำ',
    'lines': 'บรรทัด',
    'blocks': 'บล็อค',

    // JD Questions
    'pasteJD': 'วาง Job Description ที่นี่...',
    'generateQuestions': 'สร้างคำถาม',
    'generating': 'กำลังสร้าง...',
    'tailoredQuestions': 'คำถามที่สร้างให้',
    'keySkillsRequired': 'ทักษะที่ต้องการ',
    'preparationTips': 'เคล็ดลับเตรียมตัว',
    'jdPasteTitle': 'วาง Job Description',
    'jdPasteSubtitle': 'AI จะสร้างคำถามสัมภาษณ์เฉพาะตำแหน่ง',
    'jdQuestionsGenerated': 'คำถามที่สร้างแล้ว',

    // Salary
    'salaryDiffEasy': 'HR ใจดี',
    'salaryDiffEasyDesc': 'ยืดหยุ่นและยินดีตอบสนอง',
    'salaryDiffMedium': 'HR ปกติ',
    'salaryDiffMediumDesc': 'เปิดรับฟังแต่มีขีดจำกัด',
    'salaryDiffHard': 'HR เข้มงวด',
    'salaryDiffHardDesc': 'คุมงบเข้มงวด ต่อรองยาก',
    'startNegotiation': 'เริ่มเจรจา',
    'selectDifficulty': 'เลือกระดับความยาก',
    'salarySimTitle': 'จำลองเจรจาเงินเดือน',
    'salarySimSub': 'ฝึกเจรจากับ AI HR Manager',
    'yourCounterOffer': 'ข้อเสนอของคุณ...',
    'hrManager': 'HR Manager',
    'salaryWelcome': 'สวัสดีครับ! ผมเป็น HR Manager เราอยากเสนอตำแหน่งนี้ให้คุณ มาคุยเรื่องค่าตอบแทนกันครับ คุณคาดหวังเงินเดือนเท่าไหร่ครับ?',
    'salaryConnError': 'เชื่อมต่อผิดพลาด ลองใหม่อีกครั้ง',
    'salaryFriendly': 'ใจดี',
    'salaryTough': 'เข้มงวด',
    'salaryBalanced': 'ปานกลาง',

    // Comparison
    'compareSessions': 'เปรียบเทียบ Session',
    'sessionBefore': 'Session A (ก่อน)',
    'sessionAfter': 'Session B (หลัง)',
    'selectSession': 'เลือก...',
    'improved': 'ดีขึ้น! 🎉',
    'needsWork': 'ต้องพัฒนา 💪',
    'detailComparison': 'เปรียบเทียบรายละเอียด',
    'greatProgress': 'ก้าวหน้ามาก!',
    'tipsForImprovement': 'เคล็ดลับปรับปรุง',
    'needTwoSessions': 'ต้องมีอย่างน้อย 2 sessions จึงจะเปรียบเทียบได้',

    // Company Research
    'researchCompanyTitle': 'วิจัยบริษัท AI',
    'researchAnyCompany': 'วิจัยบริษัทใดก็ได้',
    'companyName': 'ชื่อบริษัท',
    'positionOptional': 'ตำแหน่ง (ไม่บังคับ)',
    'researching': 'กำลังค้นคว้า...',
    'researchBtn': 'วิจัยบริษัท',
    'crHeroSubtitle': 'AI ช่วยค้นคว้าข้อมูลเตรียมสัมภาษณ์',
    'cultureValues': 'วัฒนธรรมและค่านิยม',
    'interviewStyle': 'รูปแบบสัมภาษณ์',
    'interviewTipsLabel': 'เคล็ดลับสัมภาษณ์',
    'whatTheyLookFor': 'สิ่งที่พวกเขามองหา',
    'funFact': 'เกร็ดน่ารู้',

    // Pacing
    'goldenZone': 'จังหวะทอง (60-120 วิ)',
    'startAnswer': 'เริ่มตอบ',
    'stopSave': 'หยุดและบันทึก',
    'answerTimes': 'เวลาตอบ',
    'pacingTips': 'เคล็ดลับจับจังหวะ',
    'buildingUp': 'กำลังสร้างเนื้อหา...',
    'goldenZoneLabel': 'จังหวะทอง!',
    'wrappingUp': 'ใกล้จบ...',
    'tooLong': 'ยาวเกินไป!',
    'ready': 'พร้อม',
    'perfect': 'เยี่ยม!',
    'tooShort': 'สั้นเกินไป',
    'tooLongLabel': 'ยาวเกินไป',
    'pacingTip1': 'ตั้งเป้าตอบ 60-120 วินาที (จังหวะทอง)',
    'pacingTip2': 'ใช้วิธี STAR ในการตอบ',
    'pacingTip3': 'เริ่มด้วยบริบท 10 วิ, รายละเอียด 30 วิ, ผลลัพธ์ 15 วิ',
    'pacingTip4': 'ฝึกสรุป: "สรุปคือ..."',
    'answerLabel': 'คำตอบ',

    // QR Card
    'digitalResumeCard': 'การ์ดเรซูเม่ดิจิทัล',
    'createShareableCard': 'สร้างการ์ดดิจิทัลแชร์ได้',
    'generateCard': 'สร้างการ์ด ✨',
    'scanToSave': 'สแกนเพื่อบันทึกข้อมูล',
    'keySkills': 'ทักษะ (คั่นด้วยเครื่องหมายจุลภาค)',
    'phone': 'โทรศัพท์',
    'linkedinUrl': 'ลิงก์ LinkedIn',
    'jobTitle': 'ตำแหน่งงาน',

    // Knowledge Base
    'kbForYou': 'สำหรับคุณ',
    'kbStar': 'STAR',
    'kbTips': 'เคล็ดลับ',
    'kbIndustry': 'สายงาน',
    'kbPersonalInsights': 'วิเคราะห์เฉพาะบุคคล',
    'kbBasedOnSessions': 'จากการฝึกสัมภาษณ์ {n} ครั้ง',
    'kbCompleteToUnlock': 'ฝึกสัมภาษณ์เพื่อปลดล็อกข้อมูลเชิงลึก',
    'kbAvgScore': 'คะแนนเฉลี่ย',
    'kbSessions': 'ครั้งที่ฝึก',
    'kbFocus': 'ตำแหน่ง',
    'kbAiCoach': 'โค้ช AI ส่วนตัว',
    'kbAiCoachSub': 'เคล็ดลับเฉพาะบุคคลจากข้อมูลผลการฝึก',
    'kbRegenerate': 'สร้างเคล็ดลับใหม่',
    'kbGenerateAi': 'รับเคล็ดลับจาก AI',
    'kbRecommended': 'แนะนำสำหรับคุณ',
    'kbFocusArea': 'จุดที่ต้องพัฒนา: {area}',
    'kbRecentPerf': 'ผลการฝึกล่าสุด',
    'kbStrengthLabel': 'จุดแข็ง: {s}',
    'kbStartJourney': 'เริ่มต้นเส้นทางของคุณ',
    'kbStartJourneySub': 'ฝึกสัมภาษณ์ครั้งแรกเพื่อปลดล็อกคำแนะนำเฉพาะบุคคล',
    'kbStarTitle': 'เทคนิค STAR',
    'kbStarSubtitle': 'มาตรฐานสากลสำหรับการตอบคำถามสัมภาษณ์เชิงพฤติกรรม',
    'kbSituation': 'Situation (สถานการณ์)',
    'kbSituationDesc': 'เล่าบริบท — เกิดอะไรขึ้น ที่ไหน เมื่อไหร่',
    'kbSituationEx': 'ขณะที่ผมเป็น Product Manager ที่บริษัท XYZ ลูกค้ายกเลิกบริการเพิ่มขึ้น 20% ติดต่อกัน 2 ไตรมาส...',
    'kbTask': 'Task (ภารกิจ)',
    'kbTaskDesc': 'อธิบายสิ่งที่คุณต้องรับผิดชอบ',
    'kbTaskEx': 'ผมได้รับมอบหมายให้หาสาเหตุและลดอัตราการยกเลิกอย่างน้อย 15% ภายในไตรมาสที่ 2',
    'kbAction': 'Action (การกระทำ)',
    'kbActionDesc': 'อธิบายขั้นตอนเฉพาะที่คุณทำ',
    'kbActionEx': 'ผมวิเคราะห์ข้อมูลผู้ใช้ 6 เดือน สัมภาษณ์ลูกค้าที่ยกเลิก 20+ ราย พบจุดบกพร่อง 3 จุดในการ onboarding และออกแบบประสบการณ์สัปดาห์แรกใหม่พร้อมทดสอบ A/B',
    'kbResult': 'Result (ผลลัพธ์)',
    'kbResultDesc': 'แชร์ผลลัพธ์ที่วัดได้',
    'kbResultEx': 'ส่งผลให้อัตราการยกเลิกลดลง 22% ผู้ใช้ active เพิ่มขึ้น 15% และประหยัดได้ประมาณ 7 ล้านบาทต่อปี',
    'kbExample': 'ตัวอย่าง',
    'kbBestPractices': 'แนวทางปฏิบัติที่ดี',
    'kbDoSpecific': 'ใช้ตัวเลขและข้อมูลเชิงปริมาณที่เจาะจง',
    'kbDoYourActions': 'เน้นที่การกระทำของ "คุณ" ไม่ใช่ทีม',
    'kbDoKeepTime': 'ตอบให้อยู่ในช่วง 90 วินาที ถึง 2 นาที',
    'kbDontVague': '"ผมทำงานร่วมกับคนอื่นได้ดี" — กว้างเกินไป',
    'kbDontBadmouth': '"หัวหน้าเก่าไม่ดีเลย" — ห้ามพูดลบ',
    'kbDontNoQuestion': '"ไม่มีคำถาม" — ต้องเตรียมคำถามเสมอ',
    'kbPowerPhrases': 'วลีทรงพลัง',
    'kbCommonMistakes': 'ข้อผิดพลาดที่พบบ่อย',
    'kbAdvancedTactics': 'เทคนิคขั้นสูง',
    'kbShowImpact': 'แสดงผลกระทบ',
    'kbShowImpactDesc': 'ระบุผลงานเป็นตัวเลข',
    'kbShowGrowth': 'แสดงการเติบโต',
    'kbShowGrowthDesc': 'แสดงการเรียนรู้อย่างต่อเนื่อง',
    'kbShowFit': 'แสดงความเหมาะสม',
    'kbShowFitDesc': 'เชื่อมโยงกับค่านิยมของบริษัท',
    'kbShowInit': 'แสดงความคิดริเริ่ม',
    'kbShowInitDesc': 'แสดงความเป็นคนลงมือทำ',
    'kbTooVague': 'คลุมเครือเกินไป',
    'kbNegativity': 'พูดในแง่ลบ',
    'kbUnprepared': 'ไม่เตรียมตัว',
    'kbOverRehearsed': 'ท่องจำมากเกินไป',
    'kb2MinRule': 'กฎ 2 นาที',
    'kbMirror': 'เทคนิคกระจก',
    'kbPause': 'พลังแห่งการหยุดคิด',
    'kbFollowUp': 'อีเมลติดตามผล',
    'kbPortfolio': 'หลักฐานผลงาน',
    'kbTech': 'เทคโนโลยีและซอฟต์แวร์',
    'kbFinance': 'การเงินและธนาคาร',
    'kbMarketing': 'การตลาดและครีเอทีฟ',
    'kbHealthcare': 'สาธารณสุข',
    'kbConsulting': 'ที่ปรึกษา',
    'kbTopics': '{n} หัวข้อ',
    'kbFocusAreas': '{n} ด้านสำคัญ',
    'kbShowImpactEx': '"เพิ่มรายได้ 30%" · "ลดต้นทุน 1.5 ล้านบาท" · "นำทีม 8 คน" · "ส่งมอบงานเร็วกว่ากำหนด 2 สัปดาห์"',
    'kbShowGrowthEx': '"จากประสบการณ์นี้ ผมได้เรียนรู้ว่า..." · "ผมแสวงหา feedback อย่างจริงจังและปรับปรุงตัวเอง..."',
    'kbShowFitEx': '"สิ่งนี้สอดคล้องกับความหลงใหลของผม..." · "วิสัยทัศน์ของบริษัทคุณตรงกับผมเพราะว่า..."',
    'kbShowInitEx': '"ผมระบุโอกาสในการ..." · "โดยไม่ต้องรอให้สั่ง ผม..." · "ผมเสนอแนวทางใหม่ที่..."',
    'kbTooVagueSub': 'หลีกเลี่ยงคำตอบทั่วไป',
    'kbTooVagueEx': 'แทนที่จะบอก "ผมทำงานร่วมกับคนอื่นได้ดี"\nให้บอก: "ผมประสานงาน 4 ทีมข้ามสายงานเพื่อส่งมอบฟีเจอร์เร็วกว่ากำหนด 2 สัปดาห์"',
    'kbNegativitySub': 'ห้ามพูดลบหลังเก่านายจ้างเดิม',
    'kbNegativityEx': 'แทนที่จะบอก "หัวหน้าเก่าแย่มาก"\nให้บอก: "ผมเรียนรู้ที่จะปรับตัวเข้ากับสไตล์การบริหารที่แตกต่างและสื่อสารเชิงรุก"',
    'kbUnpreparedSub': 'ต้องเตรียมคำถามไว้เสมอ',
    'kbUnpreparedEx': 'แทนที่จะบอก "ไม่มีคำถามครับ"\nให้ถาม: "ความสำเร็จใน 90 วันแรกควรเป็นอย่างไร?"',
    'kbOverRehearsedSub': 'อย่าพูดเหมือนท่องจำมา',
    'kbOverRehearsedEx': 'แทนที่จะท่องจำคำต่อคำ ให้ฝึกจุดสำคัญและปล่อยให้บทสนทนาไหลเป็นธรรมชาติ',
    'kb2MinRuleSub': 'กระชับและมีโครงสร้าง',
    'kb2MinRuleEx': 'ตอบแต่ละคำถามให้อยู่ระหว่าง 90 วินาที ถึง 2 นาที ใช้ STAR เพื่อให้ตรงประเด็น',
    'kbMirrorSub': 'สร้างความสัมพันธ์อย่างเป็นธรรมชาติ',
    'kbMirrorEx': 'ปรับพลังงาน จังหวะ และภาษากายให้สอดคล้องกับผู้สัมภาษณ์อย่างแนบเนียน',
    'kbPauseSub': 'คิดก่อนตอบ',
    'kbPauseEx': 'รอ 3-5 วินาทีก่อนตอบ พูดว่า "คำถามดีมากครับ ขอคิดสักครู่..."',
    'kbFollowUpSub': 'ปิดท้ายอย่างมืออาชีพ',
    'kbFollowUpEx': 'ส่งอีเมลขอบคุณภายใน 24 ชั่วโมง อ้างอิงประเด็นเฉพาะจากบทสนทนา',
    'kbPortfolioSub': 'แสดงผลงานจริง ไม่ใช่แค่พูด',
    'kbPortfolioEx': 'นำตัวอย่างผลงานหรือ Portfolio มาด้วย หลักฐานที่เห็นได้น่าเชื่อถือกว่าคำพูดมาก',
    'kbTech1': 'เตรียมตัวสำหรับคำถาม System Design และสถาปัตยกรรม',
    'kbTech2': 'ฝึกโจทย์ Coding Challenge และ Algorithm',
    'kbTech3': 'ทบทวน Data Structures และการวิเคราะห์ Complexity',
    'kbTech4': 'เตรียมเรื่องเล่าเชิงพฤติกรรมเกี่ยวกับโปรเจกต์เทคโนโลยี',
    'kbTech5': 'ค้นคว้า Tech Stack และวัฒนธรรมวิศวกรรมของบริษัท',
    'kbTech6': 'พร้อมพูดคุยเรื่อง Scalability และ Trade-offs',
    'kbFinance1': 'ศึกษาการวิเคราะห์ตลาดและ Financial Modeling',
    'kbFinance2': 'ฝึก Case Study และปัญหาท้าทายทางตรรกะ',
    'kbFinance3': 'ติดตามแนวโน้มตลาดและตัวชี้วัดเศรษฐกิจปัจจุบัน',
    'kbFinance4': 'เตรียมตัวสำหรับสถานการณ์การประเมินความเสี่ยง',
    'kbFinance5': 'พร้อมสำหรับคำถามการประมาณการและคำนวณเลข',
    'kbFinance6': 'ทำความเข้าใจกรอบการปฏิบัติตามกฎระเบียบ',
    'kbMarketing1': 'เตรียม Portfolio แคมเปญและผลลัพธ์ที่ผ่านมา',
    'kbMarketing2': 'รู้ตัวชี้วัดสำคัญ: ROI, CAC, LTV, อัตราการแปลง',
    'kbMarketing3': 'พร้อมพูดคุยเรื่องกลยุทธ์แบรนด์และการวางตำแหน่ง',
    'kbMarketing4': 'ฝึกสถานการณ์การแก้ปัญหาเชิงสร้างสรรค์',
    'kbMarketing5': 'แสดงความสามารถในการตัดสินใจด้วยข้อมูล',
    'kbMarketing6': 'พูดคุยเรื่องเทรนด์: โซเชียลมีเดีย, AI ในการตลาด',
    'kbHealthcare1': 'เน้นผลลัพธ์ของผู้ป่วยและโปรโตคอลความปลอดภัย',
    'kbHealthcare2': 'เตรียมตัวสำหรับสถานการณ์ด้านจริยธรรมและการปฏิบัติตามกฎ',
    'kbHealthcare3': 'แสดงทักษะการทำงานร่วมกันและการสื่อสารในทีม',
    'kbHealthcare4': 'พูดคุยเรื่องการตัดสินใจด้วยหลักฐานเชิงประจักษ์',
    'kbHealthcare5': 'รู้กรอบกฎระเบียบ (HIPAA ฯลฯ)',
    'kbHealthcare6': 'พร้อมยกตัวอย่างการแก้ไขความขัดแย้ง',
    'kbConsulting1': 'เชี่ยวชาญ Framework การสัมภาษณ์แบบ Case',
    'kbConsulting2': 'ฝึก Market Sizing และคำถามประมาณการ',
    'kbConsulting3': 'แสดงแนวทางแก้ปัญหาอย่างเป็นระบบ',
    'kbConsulting4': 'เตรียมตัวอย่างงานที่ทำกับลูกค้า',
    'kbConsulting5': 'แสดงทักษะการคิดเชิงวิเคราะห์และเชิงกลยุทธ์',
    'kbConsulting6': 'พร้อมรับคำถามแบบรวดเร็วและกดดัน',
    // Mock Scenarios
    'msChooseChallenge': 'เลือกความท้าทายของคุณ',
    'msSubtitle': 'ฝึกฝนกับสถานการณ์สัมภาษณ์จำลอง',
    'msBeginner': 'เริ่มต้น',
    'msIntermediate': 'ปานกลาง',
    'msAdvanced': 'ขั้นสูง',
    'msExpert': 'ผู้เชี่ยวชาญ',
    'msStandard': 'สัมภาษณ์มาตรฐาน',
    'msStandardInfo': '5 คำถาม · 30 นาที · คำถามผสม',
    'msStandardDesc': 'สัมภาษณ์แบบตัวต่อตัวคลาสสิก มีทั้งคำถามเชิงพฤติกรรมและเทคนิค',
    'msPanel': 'สัมภาษณ์แบบคณะกรรมการ',
    'msPanelInfo': '7 คำถาม · 45 นาที · หลากหลายมุมมอง',
    'msPanelDesc': 'เผชิญหน้ากับคณะผู้สัมภาษณ์ที่มีรูปแบบคำถามหลากหลาย',
    'msRapidFire': 'ตอบเร็วปฏิบัติ',
    'msRapidFireInfo': '10 คำถาม · 15 นาที · ตอบสั้นกระชับ',
    'msRapidFireDesc': 'คิดเร็ว! ตอบคำถามรัวเร็วภายในเวลาจำกัด',
    'msBehavioral': 'เจาะลึกเชิงพฤติกรรม',
    'msBehavioralInfo': '5 คำถาม · 40 นาที · เน้น STAR',
    'msBehavioralDesc': 'คำถามเชิงพฤติกรรมเชิงลึก ต้องตอบด้วย STAR Method อย่างละเอียด',
    'msCaseStudy': 'กรณีศึกษา',
    'msCaseStudyInfo': '3 คำถาม · 60 นาที · แก้ปัญหา',
    'msCaseStudyDesc': 'แก้ปัญหาธุรกิจจริงและอธิบายกระบวนการคิดทีละขั้นตอน',
    'msPressure': 'สัมภาษณ์กดดัน',
    'msPressureInfo': '8 คำถาม · 20 นาที · ความเครียดสูง',
    'msPressureDesc': 'คำถามท้าทายที่ออกแบบมาเพื่อทดสอบความเยือกเย็นภายใต้แรงกดดัน',
  };
}

/// Localization delegate
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final String locale;
  const AppLocalizationsDelegate(this.locale);

  @override
  bool isSupported(Locale locale) => ['en', 'th'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(this.locale);

  @override
  bool shouldReload(covariant AppLocalizationsDelegate old) => old.locale != locale;
}

/// Extension for convenient access: context.tr.someKey
extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this);
}
