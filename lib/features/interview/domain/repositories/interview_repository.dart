import 'package:dartz/dartz.dart';
import 'package:interview_ace/core/error/failures.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';

/// Abstract repository for interview feature (Domain layer)
abstract class InterviewRepository {
  /// Generate interview questions using OpenAI
  Future<Either<Failure, List<InterviewQuestion>>> generateQuestions({
    required String position,
    required String company,
    required String level,
    required String questionType,
    required String language,
    required int count,
    required String sessionId,
  });

  /// Evaluate a user's answer using OpenAI
  Future<Either<Failure, InterviewQuestion>> evaluateAnswer({
    required InterviewQuestion question,
    required String answer,
    required String level,
    required String language,
  });

  /// Save interview session to local DB
  Future<Either<Failure, void>> saveSession(InterviewSession session);

  /// Save question to local DB
  Future<Either<Failure, void>> saveQuestion(InterviewQuestion question);

  /// Get all sessions from local DB
  Future<Either<Failure, List<InterviewSession>>> getAllSessions();

  /// Get session by ID
  Future<Either<Failure, InterviewSession>> getSessionById(String id);

  /// Get questions for a session
  Future<Either<Failure, List<InterviewQuestion>>> getQuestionsForSession(
      String sessionId);

  /// Delete a session and its questions
  Future<Either<Failure, void>> deleteSession(String id);

  /// Update session with results
  Future<Either<Failure, void>> updateSessionResults({
    required String sessionId,
    required double totalScore,
    required String overallFeedback,
    required String strengths,
    required String weaknesses,
  });
}
