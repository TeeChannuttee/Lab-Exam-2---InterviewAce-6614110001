import 'package:drift/drift.dart';

/// Interview Sessions table
class InterviewSessions extends Table {
  TextColumn get id => text()();
  TextColumn get position => text()();
  TextColumn get company => text()();
  TextColumn get level => text()();
  TextColumn get questionType => text().named('question_type')();
  TextColumn get language => text().withDefault(const Constant('en'))();
  IntColumn get questionCount => integer().named('question_count')();
  IntColumn get timePerQuestion =>
      integer().named('time_per_question').withDefault(const Constant(0))();
  RealColumn get totalScore => real().named('total_score').nullable()();
  TextColumn get overallFeedback =>
      text().named('overall_feedback').nullable()();
  TextColumn get strengths => text().nullable()();
  TextColumn get weaknesses => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Interview Questions table
class InterviewQuestions extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().named('session_id').references(InterviewSessions, #id)();
  IntColumn get questionNumber => integer().named('question_number')();
  TextColumn get questionText => text().named('question_text')();
  TextColumn get category => text()();
  TextColumn get answerText => text().named('answer_text').nullable()();
  RealColumn get score => real().nullable()();
  TextColumn get feedback => text().nullable()();
  TextColumn get idealAnswer => text().named('ideal_answer').nullable()();
  TextColumn get starAnalysis => text().named('star_analysis').nullable()();
  TextColumn get suggestedKeywords =>
      text().named('suggested_keywords').nullable()(); // JSON array as string

  @override
  Set<Column> get primaryKey => {id};
}

/// Resume Profiles table
class ResumeProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get extractedText => text().named('extracted_text')();
  TextColumn get analysis => text().nullable()();
  TextColumn get strengths => text().nullable()(); // JSON array as string
  TextColumn get weaknesses => text().nullable()(); // JSON array as string
  TextColumn get suggestedQuestions =>
      text().named('suggested_questions').nullable()(); // JSON array as string
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
