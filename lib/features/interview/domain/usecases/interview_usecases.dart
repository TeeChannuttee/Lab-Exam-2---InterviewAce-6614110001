import 'package:dartz/dartz.dart';
import 'package:interview_ace/core/error/failures.dart';
import 'package:interview_ace/core/usecases/usecase.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';
import 'package:interview_ace/features/interview/domain/repositories/interview_repository.dart';

/// Use case: Generate interview questions via OpenAI
class GenerateQuestionsUseCase
    implements UseCase<List<InterviewQuestion>, GenerateQuestionsParams> {
  final InterviewRepository repository;

  GenerateQuestionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<InterviewQuestion>>> call(
      GenerateQuestionsParams params) {
    return repository.generateQuestions(
      position: params.position,
      company: params.company,
      level: params.level,
      questionType: params.questionType,
      language: params.language,
      count: params.count,
      sessionId: params.sessionId,
    );
  }
}

class GenerateQuestionsParams {
  final String position;
  final String company;
  final String level;
  final String questionType;
  final String language;
  final int count;
  final String sessionId;

  const GenerateQuestionsParams({
    required this.position,
    required this.company,
    required this.level,
    required this.questionType,
    required this.language,
    required this.count,
    required this.sessionId,
  });
}

/// Use case: Evaluate an answer via OpenAI
class EvaluateAnswerUseCase
    implements UseCase<InterviewQuestion, EvaluateAnswerParams> {
  final InterviewRepository repository;

  EvaluateAnswerUseCase(this.repository);

  @override
  Future<Either<Failure, InterviewQuestion>> call(
      EvaluateAnswerParams params) {
    return repository.evaluateAnswer(
      question: params.question,
      answer: params.answer,
      level: params.level,
      language: params.language,
    );
  }
}

class EvaluateAnswerParams {
  final InterviewQuestion question;
  final String answer;
  final String level;
  final String language;

  const EvaluateAnswerParams({
    required this.question,
    required this.answer,
    required this.level,
    required this.language,
  });
}

/// Use case: Get all interview sessions
class GetAllSessionsUseCase
    implements UseCase<List<InterviewSession>, NoParams> {
  final InterviewRepository repository;

  GetAllSessionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<InterviewSession>>> call(NoParams params) {
    return repository.getAllSessions();
  }
}

/// Use case: Get session by ID
class GetSessionByIdUseCase
    implements UseCase<InterviewSession, String> {
  final InterviewRepository repository;

  GetSessionByIdUseCase(this.repository);

  @override
  Future<Either<Failure, InterviewSession>> call(String id) {
    return repository.getSessionById(id);
  }
}

/// Use case: Delete a session
class DeleteSessionUseCase implements UseCase<void, String> {
  final InterviewRepository repository;

  DeleteSessionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteSession(id);
  }
}
