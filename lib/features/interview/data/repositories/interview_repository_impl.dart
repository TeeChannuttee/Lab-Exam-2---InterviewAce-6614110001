import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:interview_ace/core/error/failures.dart';
import 'package:interview_ace/features/interview/data/datasources/local/database/app_database.dart'
    as db;
import 'package:interview_ace/features/interview/data/datasources/local/hive_cache_service.dart';
import 'package:interview_ace/features/interview/data/datasources/remote/openai_remote_datasource.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';
import 'package:interview_ace/features/interview/domain/repositories/interview_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementation of InterviewRepository
/// Coordinates between local DB (Drift), cache (Hive), and remote (OpenAI)
class InterviewRepositoryImpl implements InterviewRepository {
  final db.AppDatabase database;
  final HiveCacheService cacheService;
  final OpenAIRemoteDataSource remoteDataSource;

  InterviewRepositoryImpl({
    required this.database,
    required this.cacheService,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<InterviewQuestion>>> generateQuestions({
    required String position,
    required String company,
    required String level,
    required String questionType,
    required String language,
    required int count,
    required String sessionId,
  }) async {
    try {
      // Always generate fresh questions from AI (no cache)
      final rawQuestions = await remoteDataSource.generateQuestions(
        position: position,
        company: company,
        level: level,
        questionType: questionType,
        language: language,
        count: count,
      );

      // Map to domain entities
      final questions = rawQuestions.asMap().entries.map((entry) {
        final idx = entry.key;
        final q = entry.value;
        return InterviewQuestion(
          id: const Uuid().v4(),
          sessionId: sessionId,
          questionNumber: idx + 1,
          questionText: q['question'] as String,
          category: q['category'] as String? ?? questionType,
        );
      }).toList();

      // Save questions to local DB
      for (final question in questions) {
        await database.insertQuestionData(
          id: question.id,
          sessionId: question.sessionId,
          questionNumber: question.questionNumber,
          questionText: question.questionText,
          category: question.category,
        );
      }

      return Right(questions);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InterviewQuestion>> evaluateAnswer({
    required InterviewQuestion question,
    required String answer,
    required String level,
    required String language,
  }) async {
    try {
      final cacheKey = '${question.questionText}|$answer|$level';
      final cachedResponse = cacheService.getCachedAIResponse(cacheKey);

      Map<String, dynamic> evaluation;

      if (cachedResponse != null) {
        evaluation = jsonDecode(cachedResponse) as Map<String, dynamic>;
      } else {
        evaluation = await remoteDataSource.evaluateAnswer(
          question: question.questionText,
          answer: answer,
          level: level,
          language: language,
        );
        await cacheService.cacheAIResponse(cacheKey, jsonEncode(evaluation));
      }

      // Safely extract string fields (AI may return Map instead of String for some fields)
      String? _safeString(dynamic val) {
        if (val == null) return null;
        if (val is String) return val;
        return jsonEncode(val);
      }

      final updatedQuestion = question.copyWith(
        answerText: answer,
        score: (evaluation['score'] as num).toDouble(),
        feedback: _safeString(evaluation['feedback']),
        idealAnswer: _safeString(evaluation['ideal_answer']),
        starAnalysis: _safeString(evaluation['star_analysis']),
        suggestedKeywords: evaluation['suggested_keywords'] != null
            ? List<String>.from(evaluation['suggested_keywords'].map((e) => e.toString()))
            : null,
      );

      // Save to DB
      await database.updateQuestionData(
        id: updatedQuestion.id,
        answerText: updatedQuestion.answerText,
        score: updatedQuestion.score,
        feedback: updatedQuestion.feedback,
        idealAnswer: updatedQuestion.idealAnswer,
        starAnalysis: updatedQuestion.starAnalysis,
        suggestedKeywordsJson: updatedQuestion.suggestedKeywords != null
            ? jsonEncode(updatedQuestion.suggestedKeywords)
            : null,
      );

      return Right(updatedQuestion);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSession(InterviewSession session) async {
    try {
      await database.insertSessionData(
        id: session.id,
        position: session.position,
        company: session.company,
        level: session.level,
        questionType: session.questionType,
        language: session.language,
        questionCount: session.questionCount,
        timePerQuestion: session.timePerQuestion,
        createdAt: session.createdAt,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveQuestion(InterviewQuestion question) async {
    try {
      await database.insertQuestionData(
        id: question.id,
        sessionId: question.sessionId,
        questionNumber: question.questionNumber,
        questionText: question.questionText,
        category: question.category,
        answerText: question.answerText,
        score: question.score,
        feedback: question.feedback,
        idealAnswer: question.idealAnswer,
        starAnalysis: question.starAnalysis,
        suggestedKeywordsJson: question.suggestedKeywords != null
            ? jsonEncode(question.suggestedKeywords)
            : null,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InterviewSession>>> getAllSessions() async {
    try {
      final rows = await database.getAllSessionRows();
      return Right(rows.map(_mapSessionRow).toList());
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InterviewSession>> getSessionById(String id) async {
    try {
      final row = await database.getSessionRowById(id);
      if (row == null) {
        return const Left(DatabaseFailure(message: 'Session not found'));
      }
      return Right(_mapSessionRow(row));
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InterviewQuestion>>> getQuestionsForSession(
      String sessionId) async {
    try {
      final rows = await database.getQuestionRowsForSession(sessionId);
      return Right(rows.map(_mapQuestionRow).toList());
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(String id) async {
    try {
      await database.deleteSessionAndQuestions(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSessionResults({
    required String sessionId,
    required double totalScore,
    required String overallFeedback,
    required String strengths,
    required String weaknesses,
  }) async {
    try {
      await database.updateSessionResultsData(
        sessionId: sessionId,
        totalScore: totalScore,
        overallFeedback: overallFeedback,
        strengths: strengths,
        weaknesses: weaknesses,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  // ─────────── ROW MAPPERS ───────────

  /// Maps Drift-generated InterviewSession row → domain InterviewSession entity
  InterviewSession _mapSessionRow(dynamic row) {
    return InterviewSession(
      id: row.id as String,
      position: row.position as String,
      company: row.company as String,
      level: row.level as String,
      questionType: row.questionType as String,
      language: row.language as String,
      questionCount: row.questionCount as int,
      timePerQuestion: row.timePerQuestion as int,
      totalScore: row.totalScore as double?,
      overallFeedback: row.overallFeedback as String?,
      strengths: row.strengths as String?,
      weaknesses: row.weaknesses as String?,
      createdAt: row.createdAt as DateTime,
    );
  }

  /// Maps Drift-generated InterviewQuestion row → domain InterviewQuestion entity
  InterviewQuestion _mapQuestionRow(dynamic row) {
    return InterviewQuestion(
      id: row.id as String,
      sessionId: row.sessionId as String,
      questionNumber: row.questionNumber as int,
      questionText: row.questionText as String,
      category: row.category as String,
      answerText: row.answerText as String?,
      score: row.score as double?,
      feedback: row.feedback as String?,
      idealAnswer: row.idealAnswer as String?,
      starAnalysis: row.starAnalysis as String?,
      suggestedKeywords: row.suggestedKeywords != null
          ? List<String>.from(jsonDecode(row.suggestedKeywords as String))
          : null,
    );
  }
}
