import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:interview_ace/core/error/failures.dart';
import 'package:interview_ace/features/interview/data/datasources/local/database/app_database.dart'
    as db;
import 'package:interview_ace/features/interview/data/datasources/local/hive_cache_service.dart';
import 'package:interview_ace/features/interview/data/datasources/remote/openai_remote_datasource.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';
import 'package:interview_ace/features/resume_scan/domain/repositories/resume_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementation of ResumeRepository
class ResumeRepositoryImpl implements ResumeRepository {
  final db.AppDatabase database;
  final HiveCacheService cacheService;
  final OpenAIRemoteDataSource remoteDataSource;

  ResumeRepositoryImpl({
    required this.database,
    required this.cacheService,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ResumeProfile>> analyzeResume(
      String extractedText, {String language = 'en'}) async {
    try {
      final cacheKey = 'resume|$language|$extractedText';
      final cachedResponse = cacheService.getCachedAIResponse(cacheKey);

      Map<String, dynamic> analysis;

      if (cachedResponse != null) {
        analysis = jsonDecode(cachedResponse) as Map<String, dynamic>;
      } else {
        analysis = await remoteDataSource.analyzeResume(extractedText, language: language);
        await cacheService.cacheAIResponse(cacheKey, jsonEncode(analysis));
      }

      final profile = ResumeProfile(
        id: const Uuid().v4(),
        extractedText: extractedText,
        analysis: analysis['analysis'] as String?,
        atsScore: (analysis['ats_score'] as num?)?.toInt(),
        strengths: analysis['strengths'] != null
            ? List<String>.from(analysis['strengths'].map((e) => e.toString()))
            : null,
        weaknesses: analysis['weaknesses'] != null
            ? List<String>.from(analysis['weaknesses'].map((e) => e.toString()))
            : null,
        keywordsFound: analysis['keywords_found'] != null
            ? List<String>.from(analysis['keywords_found'].map((e) => e.toString()))
            : null,
        keywordsMissing: analysis['keywords_missing'] != null
            ? List<String>.from(analysis['keywords_missing'].map((e) => e.toString()))
            : null,
        formatChecks: analysis['format_checks'] != null
            ? Map<String, bool>.from((analysis['format_checks'] as Map).map(
                (k, v) => MapEntry(k.toString(), v == true)))
            : null,
        suggestedQuestions: analysis['suggested_questions'] != null
            ? List<String>.from(analysis['suggested_questions'].map((e) => e.toString()))
            : null,
        improvementTips: analysis['improvement_tips'] != null
            ? List<String>.from(analysis['improvement_tips'].map((e) => e.toString()))
            : null,
        createdAt: DateTime.now(),
      );

      // Save to local DB
      await database.insertResumeProfileData(
        id: profile.id,
        extractedText: profile.extractedText,
        analysis: profile.analysis,
        strengthsJson:
            profile.strengths != null ? jsonEncode(profile.strengths) : null,
        weaknessesJson:
            profile.weaknesses != null ? jsonEncode(profile.weaknesses) : null,
        suggestedQuestionsJson: profile.suggestedQuestions != null
            ? jsonEncode(profile.suggestedQuestions)
            : null,
        createdAt: profile.createdAt,
      );

      return Right(profile);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveResumeProfile(
      ResumeProfile profile) async {
    try {
      await database.insertResumeProfileData(
        id: profile.id,
        extractedText: profile.extractedText,
        analysis: profile.analysis,
        strengthsJson:
            profile.strengths != null ? jsonEncode(profile.strengths) : null,
        weaknessesJson:
            profile.weaknesses != null ? jsonEncode(profile.weaknesses) : null,
        suggestedQuestionsJson: profile.suggestedQuestions != null
            ? jsonEncode(profile.suggestedQuestions)
            : null,
        createdAt: profile.createdAt,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ResumeProfile>>> getAllResumeProfiles() async {
    try {
      final rows = await database.getAllResumeProfileRows();
      return Right(rows.map(_mapResumeRow).toList());
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ResumeProfile>> getResumeProfileById(
      String id) async {
    try {
      final rows = await database.getAllResumeProfileRows();
      final row = rows.firstWhere((r) => r.id == id);
      return Right(_mapResumeRow(row));
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  /// Maps Drift-generated row → domain ResumeProfile entity
  ResumeProfile _mapResumeRow(dynamic row) {
    return ResumeProfile(
      id: row.id as String,
      extractedText: row.extractedText as String,
      analysis: row.analysis as String?,
      strengths: row.strengths != null
          ? List<String>.from(jsonDecode(row.strengths as String))
          : null,
      weaknesses: row.weaknesses != null
          ? List<String>.from(jsonDecode(row.weaknesses as String))
          : null,
      suggestedQuestions: row.suggestedQuestions != null
          ? List<String>.from(jsonDecode(row.suggestedQuestions as String))
          : null,
      createdAt: row.createdAt as DateTime,
    );
  }
}
