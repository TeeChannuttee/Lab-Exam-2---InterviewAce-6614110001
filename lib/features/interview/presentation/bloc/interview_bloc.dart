import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';
import 'package:interview_ace/features/interview/domain/repositories/interview_repository.dart';
import 'package:interview_ace/features/interview/data/datasources/remote/openai_remote_datasource.dart';
import 'package:interview_ace/features/gamification/data/services/gamification_service.dart';

// ─────────── EVENTS ───────────

abstract class InterviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetupInterviewEvent extends InterviewEvent {
  final String position;
  final String company;
  final String level;
  final String questionType;
  final String language;
  final int questionCount;
  final int timePerQuestion;

  SetupInterviewEvent({
    required this.position,
    required this.company,
    required this.level,
    required this.questionType,
    required this.language,
    required this.questionCount,
    this.timePerQuestion = 0,
  });

  @override
  List<Object?> get props =>
      [position, company, level, questionType, language, questionCount, timePerQuestion];
}

class GenerateQuestionsEvent extends InterviewEvent {}

class SubmitAnswerEvent extends InterviewEvent {
  final String answer;
  SubmitAnswerEvent({required this.answer});

  @override
  List<Object?> get props => [answer];
}

class SkipQuestionEvent extends InterviewEvent {}

class NextQuestionEvent extends InterviewEvent {}

class FinishInterviewEvent extends InterviewEvent {}

class ScanHandwritingEvent extends InterviewEvent {
  final String scannedText;
  ScanHandwritingEvent({required this.scannedText});

  @override
  List<Object?> get props => [scannedText];
}

// ─────────── STATES ───────────

abstract class InterviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InterviewInitial extends InterviewState {}

class InterviewLoading extends InterviewState {
  final String message;
  InterviewLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

class InterviewSetupComplete extends InterviewState {
  final InterviewSession session;
  InterviewSetupComplete({required this.session});

  @override
  List<Object?> get props => [session];
}

class InterviewQuestionsReady extends InterviewState {
  final InterviewSession session;
  final List<InterviewQuestion> questions;
  final int currentIndex;

  InterviewQuestionsReady({
    required this.session,
    required this.questions,
    required this.currentIndex,
  });

  InterviewQuestion get currentQuestion => questions[currentIndex];
  bool get isLastQuestion => currentIndex == questions.length - 1;
  double get progress => (currentIndex + 1) / questions.length;

  @override
  List<Object?> get props => [session, questions, currentIndex];
}

class InterviewEvaluating extends InterviewState {
  final InterviewSession session;
  final List<InterviewQuestion> questions;
  final int currentIndex;

  InterviewEvaluating({
    required this.session,
    required this.questions,
    required this.currentIndex,
  });

  @override
  List<Object?> get props => [session, questions, currentIndex];
}

class InterviewAnswerEvaluated extends InterviewState {
  final InterviewSession session;
  final List<InterviewQuestion> questions;
  final int currentIndex;
  final InterviewQuestion evaluatedQuestion;

  InterviewAnswerEvaluated({
    required this.session,
    required this.questions,
    required this.currentIndex,
    required this.evaluatedQuestion,
  });

  @override
  List<Object?> get props => [session, questions, currentIndex, evaluatedQuestion];
}

class InterviewCompleted extends InterviewState {
  final InterviewSession session;
  final List<InterviewQuestion> questions;

  InterviewCompleted({
    required this.session,
    required this.questions,
  });

  double get averageScore {
    final scored = questions.where((q) => q.score != null);
    if (scored.isEmpty) return 0;
    return scored.map((q) => q.score!).reduce((a, b) => a + b) / scored.length;
  }

  @override
  List<Object?> get props => [session, questions];
}

class InterviewError extends InterviewState {
  final String message;
  InterviewError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─────────── BLOC ───────────

class InterviewBloc extends Bloc<InterviewEvent, InterviewState> {
  final InterviewRepository repository;
  final OpenAIRemoteDataSource remoteDataSource;
  final GamificationService gamificationService;

  InterviewSession? _currentSession;
  List<InterviewQuestion> _questions = [];
  int _currentIndex = 0;

  InterviewBloc({
    required this.repository,
    required this.remoteDataSource,
    required this.gamificationService,
  }) : super(InterviewInitial()) {
    on<SetupInterviewEvent>(_onSetup);
    on<GenerateQuestionsEvent>(_onGenerateQuestions);
    on<SubmitAnswerEvent>(_onSubmitAnswer);
    on<SkipQuestionEvent>(_onSkipQuestion);
    on<NextQuestionEvent>(_onNextQuestion);
    on<FinishInterviewEvent>(_onFinishInterview);
    on<ScanHandwritingEvent>(_onScanHandwriting);
  }

  Future<void> _onSetup(
      SetupInterviewEvent event, Emitter<InterviewState> emit) async {
    // Create session
    final session = InterviewSession.create(
      position: event.position,
      company: event.company,
      level: event.level,
      questionType: event.questionType,
      language: event.language,
      questionCount: event.questionCount,
      timePerQuestion: event.timePerQuestion,
    );

    // Save to DB
    await repository.saveSession(session);
    _currentSession = session;

    emit(InterviewSetupComplete(session: session));

    // Automatically generate questions
    add(GenerateQuestionsEvent());
  }

  Future<void> _onGenerateQuestions(
      GenerateQuestionsEvent event, Emitter<InterviewState> emit) async {
    if (_currentSession == null) return;

    emit(InterviewLoading(message: 'Generating questions with AI...'));

    final result = await repository.generateQuestions(
      position: _currentSession!.position,
      company: _currentSession!.company,
      level: _currentSession!.level,
      questionType: _currentSession!.questionType,
      language: _currentSession!.language,
      count: _currentSession!.questionCount,
      sessionId: _currentSession!.id,
    );

    result.fold(
      (failure) => emit(InterviewError(message: failure.message)),
      (questions) {
        _questions = questions;
        _currentIndex = 0;
        emit(InterviewQuestionsReady(
          session: _currentSession!,
          questions: _questions,
          currentIndex: _currentIndex,
        ));
      },
    );
  }

  Future<void> _onSubmitAnswer(
      SubmitAnswerEvent event, Emitter<InterviewState> emit) async {
    if (_currentSession == null || _questions.isEmpty) return;

    emit(InterviewEvaluating(
      session: _currentSession!,
      questions: _questions,
      currentIndex: _currentIndex,
    ));

    final result = await repository.evaluateAnswer(
      question: _questions[_currentIndex],
      answer: event.answer,
      level: _currentSession!.level,
      language: _currentSession!.language,
    );

    result.fold(
      (failure) => emit(InterviewError(message: failure.message)),
      (evaluatedQuestion) {
        _questions[_currentIndex] = evaluatedQuestion;
        emit(InterviewAnswerEvaluated(
          session: _currentSession!,
          questions: _questions,
          currentIndex: _currentIndex,
          evaluatedQuestion: evaluatedQuestion,
        ));
      },
    );
  }

  void _onSkipQuestion(
      SkipQuestionEvent event, Emitter<InterviewState> emit) {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      emit(InterviewQuestionsReady(
        session: _currentSession!,
        questions: _questions,
        currentIndex: _currentIndex,
      ));
    } else {
      add(FinishInterviewEvent());
    }
  }

  void _onNextQuestion(
      NextQuestionEvent event, Emitter<InterviewState> emit) {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      emit(InterviewQuestionsReady(
        session: _currentSession!,
        questions: _questions,
        currentIndex: _currentIndex,
      ));
    } else {
      add(FinishInterviewEvent());
    }
  }

  Future<void> _onFinishInterview(
      FinishInterviewEvent event, Emitter<InterviewState> emit) async {
    emit(InterviewLoading(message: 'Generating overall feedback...'));

    try {
      // Generate session feedback
      final questionsAndAnswers = _questions
          .map((q) => {
                'question': q.questionText,
                'answer': q.answerText,
                'score': q.score,
              })
          .toList();

      final feedback = await remoteDataSource.generateSessionFeedback(
        position: _currentSession!.position,
        company: _currentSession!.company,
        level: _currentSession!.level,
        questionsAndAnswers: questionsAndAnswers,
        language: _currentSession!.language,
      );

      final totalScore = (feedback['total_score'] as num).toDouble();
      final overallFeedback = feedback['overall_feedback'] as String;
      final strengths = (feedback['strengths'] as List).join(', ');
      final weaknesses = (feedback['weaknesses'] as List).join(', ');

      // Update session in DB
      await repository.updateSessionResults(
        sessionId: _currentSession!.id,
        totalScore: totalScore,
        overallFeedback: overallFeedback,
        strengths: strengths,
        weaknesses: weaknesses,
      );

      _currentSession = _currentSession!.copyWith(
        totalScore: totalScore,
        overallFeedback: overallFeedback,
        strengths: strengths,
        weaknesses: weaknesses,
      );

      emit(InterviewCompleted(
        session: _currentSession!,
        questions: _questions,
      ));

      // Record gamification
      await gamificationService.recordSession(score: totalScore);
    } catch (e) {
      // Still complete even if feedback generation fails
      final scored = _questions.where((q) => q.score != null);
      final avgScore = scored.isEmpty
          ? 0.0
          : scored.map((q) => q.score!).reduce((a, b) => a + b) / scored.length;

      _currentSession = _currentSession!.copyWith(totalScore: avgScore);

      emit(InterviewCompleted(
        session: _currentSession!,
        questions: _questions,
      ));

      // Record gamification even on feedback failure
      await gamificationService.recordSession(score: avgScore);
    }
  }

  void _onScanHandwriting(
      ScanHandwritingEvent event, Emitter<InterviewState> emit) {
    // This just passes the scanned text — the UI will put it in the text field
    emit(InterviewQuestionsReady(
      session: _currentSession!,
      questions: _questions,
      currentIndex: _currentIndex,
    ));
  }
}
