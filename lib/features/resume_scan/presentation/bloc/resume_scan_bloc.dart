import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';
import 'package:interview_ace/features/resume_scan/domain/repositories/resume_repository.dart';

// ─────────── EVENTS ───────────

abstract class ResumeScanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnalyzeResumeEvent extends ResumeScanEvent {
  final String extractedText;
  final String language;
  AnalyzeResumeEvent({required this.extractedText, this.language = 'en'});

  @override
  List<Object?> get props => [extractedText, language];
}

class LoadResumeHistoryEvent extends ResumeScanEvent {}

// ─────────── STATES ───────────

abstract class ResumeScanState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResumeScanInitial extends ResumeScanState {}

class ResumeScanLoading extends ResumeScanState {}

class ResumeScanAnalyzed extends ResumeScanState {
  final ResumeProfile profile;
  ResumeScanAnalyzed({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ResumeScanHistoryLoaded extends ResumeScanState {
  final List<ResumeProfile> profiles;
  ResumeScanHistoryLoaded({required this.profiles});

  @override
  List<Object?> get props => [profiles];
}

class ResumeScanError extends ResumeScanState {
  final String message;
  ResumeScanError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─────────── BLOC ───────────

class ResumeScanBloc extends Bloc<ResumeScanEvent, ResumeScanState> {
  final ResumeRepository repository;

  ResumeScanBloc({required this.repository}) : super(ResumeScanInitial()) {
    on<AnalyzeResumeEvent>(_onAnalyze);
    on<LoadResumeHistoryEvent>(_onLoadHistory);
  }

  Future<void> _onAnalyze(
      AnalyzeResumeEvent event, Emitter<ResumeScanState> emit) async {
    emit(ResumeScanLoading());

    final result = await repository.analyzeResume(event.extractedText, language: event.language);
    result.fold(
      (failure) => emit(ResumeScanError(message: failure.message)),
      (profile) => emit(ResumeScanAnalyzed(profile: profile)),
    );
  }

  Future<void> _onLoadHistory(
      LoadResumeHistoryEvent event, Emitter<ResumeScanState> emit) async {
    emit(ResumeScanLoading());

    final result = await repository.getAllResumeProfiles();
    result.fold(
      (failure) => emit(ResumeScanError(message: failure.message)),
      (profiles) => emit(ResumeScanHistoryLoaded(profiles: profiles)),
    );
  }
}
