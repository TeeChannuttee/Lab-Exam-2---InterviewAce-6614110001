import 'package:dartz/dartz.dart';
import 'package:interview_ace/core/error/failures.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';

/// Abstract repository for resume scanning feature
abstract class ResumeRepository {
  /// Analyze resume text using OpenAI
  Future<Either<Failure, ResumeProfile>> analyzeResume(String extractedText, {String language = 'en'});

  /// Save resume profile to local DB
  Future<Either<Failure, void>> saveResumeProfile(ResumeProfile profile);

  /// Get all resume profiles
  Future<Either<Failure, List<ResumeProfile>>> getAllResumeProfiles();

  /// Get resume profile by ID
  Future<Either<Failure, ResumeProfile>> getResumeProfileById(String id);
}
