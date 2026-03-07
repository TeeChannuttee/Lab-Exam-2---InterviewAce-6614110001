import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:interview_ace/features/interview/data/datasources/local/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [InterviewSessions, InterviewQuestions, ResumeProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // For testing
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  // ─────────── SESSION OPERATIONS ───────────

  Future<void> insertSessionData({
    required String id,
    required String position,
    required String company,
    required String level,
    required String questionType,
    required String language,
    required int questionCount,
    required int timePerQuestion,
    required DateTime createdAt,
  }) async {
    await into(interviewSessions).insert(InterviewSessionsCompanion.insert(
      id: id,
      position: position,
      company: company,
      level: level,
      questionType: questionType,
      language: Value(language),
      questionCount: questionCount,
      timePerQuestion: Value(timePerQuestion),
      createdAt: Value(createdAt),
    ));
  }

  /// Drift generates `InterviewSession` from `InterviewSessions` table.
  /// We use the generated type directly.
  Future<List<InterviewSession>> getAllSessionRows() async {
    return await (select(interviewSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<InterviewSession?> getSessionRowById(String id) async {
    return await (select(interviewSessions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> updateSessionResultsData({
    required String sessionId,
    required double totalScore,
    required String overallFeedback,
    required String strengths,
    required String weaknesses,
  }) async {
    await (update(interviewSessions)..where((t) => t.id.equals(sessionId)))
        .write(InterviewSessionsCompanion(
      totalScore: Value(totalScore),
      overallFeedback: Value(overallFeedback),
      strengths: Value(strengths),
      weaknesses: Value(weaknesses),
    ));
  }

  Future<void> deleteSessionAndQuestions(String sessionId) async {
    await (delete(interviewQuestions)
          ..where((t) => t.sessionId.equals(sessionId)))
        .go();
    await (delete(interviewSessions)..where((t) => t.id.equals(sessionId)))
        .go();
  }

  Future<int> getSessionCount() async {
    final count = countAll();
    final query = selectOnly(interviewSessions)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ─────────── QUESTION OPERATIONS ───────────

  Future<void> insertQuestionData({
    required String id,
    required String sessionId,
    required int questionNumber,
    required String questionText,
    required String category,
    String? answerText,
    double? score,
    String? feedback,
    String? idealAnswer,
    String? starAnalysis,
    String? suggestedKeywordsJson,
  }) async {
    await into(interviewQuestions).insert(InterviewQuestionsCompanion.insert(
      id: id,
      sessionId: sessionId,
      questionNumber: questionNumber,
      questionText: questionText,
      category: category,
      answerText: Value(answerText),
      score: Value(score),
      feedback: Value(feedback),
      idealAnswer: Value(idealAnswer),
      starAnalysis: Value(starAnalysis),
      suggestedKeywords: Value(suggestedKeywordsJson),
    ));
  }

  Future<void> updateQuestionData({
    required String id,
    String? answerText,
    double? score,
    String? feedback,
    String? idealAnswer,
    String? starAnalysis,
    String? suggestedKeywordsJson,
  }) async {
    await (update(interviewQuestions)..where((t) => t.id.equals(id)))
        .write(InterviewQuestionsCompanion(
      answerText: Value(answerText),
      score: Value(score),
      feedback: Value(feedback),
      idealAnswer: Value(idealAnswer),
      starAnalysis: Value(starAnalysis),
      suggestedKeywords: Value(suggestedKeywordsJson),
    ));
  }

  Future<List<InterviewQuestion>> getQuestionRowsForSession(
      String sessionId) async {
    return await (select(interviewQuestions)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.questionNumber)]))
        .get();
  }

  Future<int> getTotalQuestionsAnswered() async {
    final count = countAll();
    final query = selectOnly(interviewQuestions)
      ..addColumns([count])
      ..where(interviewQuestions.answerText.isNotNull());
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ─────────── RESUME OPERATIONS ───────────

  Future<void> insertResumeProfileData({
    required String id,
    required String extractedText,
    String? analysis,
    String? strengthsJson,
    String? weaknessesJson,
    String? suggestedQuestionsJson,
    required DateTime createdAt,
  }) async {
    await into(resumeProfiles).insert(ResumeProfilesCompanion.insert(
      id: id,
      extractedText: extractedText,
      analysis: Value(analysis),
      strengths: Value(strengthsJson),
      weaknesses: Value(weaknessesJson),
      suggestedQuestions: Value(suggestedQuestionsJson),
      createdAt: Value(createdAt),
    ));
  }

  Future<List<ResumeProfile>> getAllResumeProfileRows() async {
    return await (select(resumeProfiles)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // ─────────── STATISTICS ───────────

  Future<double?> getAverageScore() async {
    final avg = interviewSessions.totalScore.avg();
    final query = selectOnly(interviewSessions)
      ..addColumns([avg])
      ..where(interviewSessions.totalScore.isNotNull());
    final result = await query.getSingle();
    return result.read(avg);
  }

  // ─────────── CLEAR DATA ───────────

  Future<void> clearAllData() async {
    await delete(interviewQuestions).go();
    await delete(interviewSessions).go();
    await delete(resumeProfiles).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return NativeDatabase.memory();
  });
}
