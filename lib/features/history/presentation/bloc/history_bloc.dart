import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';
import 'package:interview_ace/features/interview/domain/repositories/interview_repository.dart';

// ─────────── EVENTS ───────────

abstract class HistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {}

class DeleteSessionEvent extends HistoryEvent {
  final String sessionId;
  DeleteSessionEvent({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class LoadSessionDetailEvent extends HistoryEvent {
  final String sessionId;
  LoadSessionDetailEvent({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class ClearAllHistoryEvent extends HistoryEvent {}

// ─────────── STATES ───────────

abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<InterviewSession> sessions;
  HistoryLoaded({required this.sessions});

  bool get isEmpty => sessions.isEmpty;

  @override
  List<Object?> get props => [sessions];
}

class HistoryDetailLoaded extends HistoryState {
  final InterviewSession session;
  final List<InterviewQuestion> questions;

  HistoryDetailLoaded({required this.session, required this.questions});

  double get averageScore {
    final scored = questions.where((q) => q.score != null);
    if (scored.isEmpty) return 0;
    return scored.map((q) => q.score!).reduce((a, b) => a + b) / scored.length;
  }

  @override
  List<Object?> get props => [session, questions];
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─────────── BLOC ───────────

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final InterviewRepository repository;

  HistoryBloc({required this.repository}) : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<DeleteSessionEvent>(_onDeleteSession);
    on<LoadSessionDetailEvent>(_onLoadSessionDetail);
    on<ClearAllHistoryEvent>(_onClearAll);
  }

  Future<void> _onLoadHistory(
      LoadHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());

    final result = await repository.getAllSessions();
    result.fold(
      (failure) => emit(HistoryError(message: failure.message)),
      (sessions) => emit(HistoryLoaded(sessions: sessions)),
    );
  }

  Future<void> _onDeleteSession(
      DeleteSessionEvent event, Emitter<HistoryState> emit) async {
    await repository.deleteSession(event.sessionId);
    // Reload
    add(LoadHistoryEvent());
  }

  Future<void> _onLoadSessionDetail(
      LoadSessionDetailEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());

    final sessionResult = await repository.getSessionById(event.sessionId);
    final questionsResult =
        await repository.getQuestionsForSession(event.sessionId);

    sessionResult.fold(
      (failure) => emit(HistoryError(message: failure.message)),
      (session) {
        questionsResult.fold(
          (failure) => emit(HistoryError(message: failure.message)),
          (questions) => emit(HistoryDetailLoaded(
            session: session,
            questions: questions,
          )),
        );
      },
    );
  }

  Future<void> _onClearAll(
      ClearAllHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    final result = await repository.getAllSessions();
    if (result.isLeft()) {
      emit(HistoryError(message: result.fold((f) => f.message, (_) => '')));
      return;
    }
    final sessions = result.getOrElse(() => []);
    for (final session in sessions) {
      await repository.deleteSession(session.id);
    }
    emit(HistoryLoaded(sessions: []));
  }
}
