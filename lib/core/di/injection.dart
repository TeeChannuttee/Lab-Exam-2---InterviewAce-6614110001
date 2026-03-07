import 'package:get_it/get_it.dart';
import 'package:interview_ace/core/network/dio_client.dart';
import 'package:interview_ace/features/interview/data/datasources/local/database/app_database.dart'
    as db;
import 'package:interview_ace/features/interview/data/datasources/local/hive_cache_service.dart';
import 'package:interview_ace/features/interview/data/datasources/remote/openai_remote_datasource.dart';
import 'package:interview_ace/features/interview/data/repositories/interview_repository_impl.dart';
import 'package:interview_ace/features/interview/domain/repositories/interview_repository.dart';
import 'package:interview_ace/features/interview/domain/usecases/interview_usecases.dart';
import 'package:interview_ace/features/resume_scan/data/repositories/resume_repository_impl.dart';
import 'package:interview_ace/features/resume_scan/domain/repositories/resume_repository.dart';
import 'package:interview_ace/features/interview/presentation/bloc/interview_bloc.dart';
import 'package:interview_ace/features/history/presentation/bloc/history_bloc.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:interview_ace/features/resume_scan/presentation/bloc/resume_scan_bloc.dart';
import 'package:interview_ace/features/resume_scan/data/services/text_recognition_service.dart';
import 'package:interview_ace/features/confidence/data/services/face_detection_service.dart';
import 'package:interview_ace/features/gamification/data/services/gamification_service.dart';

final sl = GetIt.instance;

/// Initialize all dependencies using get_it
Future<void> initDependencies() async {
  // ─────────── CORE ───────────
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // ─────────── DATABASE ───────────
  sl.registerLazySingleton<db.AppDatabase>(() => db.AppDatabase());

  // ─────────── CACHE ───────────
  final cacheService = HiveCacheService();
  await cacheService.init();
  sl.registerLazySingleton<HiveCacheService>(() => cacheService);

  // ─────────── GAMIFICATION ───────────
  final gamificationService = GamificationService();
  await gamificationService.init();
  sl.registerLazySingleton<GamificationService>(() => gamificationService);

  // ─────────── DATA SOURCES ───────────
  sl.registerLazySingleton<OpenAIRemoteDataSource>(
    () => OpenAIRemoteDataSource(dioClient: sl<DioClient>()),
  );

  // ─────────── REPOSITORIES ───────────
  sl.registerLazySingleton<InterviewRepository>(
    () => InterviewRepositoryImpl(
      database: sl<db.AppDatabase>(),
      cacheService: sl<HiveCacheService>(),
      remoteDataSource: sl<OpenAIRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ResumeRepository>(
    () => ResumeRepositoryImpl(
      database: sl<db.AppDatabase>(),
      cacheService: sl<HiveCacheService>(),
      remoteDataSource: sl<OpenAIRemoteDataSource>(),
    ),
  );

  // ─────────── USE CASES ───────────
  sl.registerLazySingleton(
    () => GenerateQuestionsUseCase(sl<InterviewRepository>()),
  );
  sl.registerLazySingleton(
    () => EvaluateAnswerUseCase(sl<InterviewRepository>()),
  );
  sl.registerLazySingleton(
    () => GetAllSessionsUseCase(sl<InterviewRepository>()),
  );
  sl.registerLazySingleton(
    () => GetSessionByIdUseCase(sl<InterviewRepository>()),
  );
  sl.registerLazySingleton(
    () => DeleteSessionUseCase(sl<InterviewRepository>()),
  );

  // ─────────── BLOCS ───────────
  sl.registerFactory(
    () => InterviewBloc(
      repository: sl<InterviewRepository>(),
      remoteDataSource: sl<OpenAIRemoteDataSource>(),
      gamificationService: sl<GamificationService>(),
    ),
  );
  sl.registerFactory(
    () => HistoryBloc(repository: sl<InterviewRepository>()),
  );
  sl.registerFactory(() => SettingsBloc());
  sl.registerFactory(
    () => ResumeScanBloc(repository: sl<ResumeRepository>()),
  );

  // ─────────── ML KIT SERVICES ───────────
  sl.registerFactory(() => TextRecognitionService());
  sl.registerFactory(() => FaceDetectionService());
}
