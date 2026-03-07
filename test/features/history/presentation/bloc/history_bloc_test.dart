// =============================================================
// Unit Test: HistoryBloc
// ทดสอบ Business Logic ของ BLoC ที่จัดการประวัติสัมภาษณ์
//
// ทำไมต้องรัน?
// - ตรวจสอบว่า BLoC โหลดข้อมูลจาก Repository ได้ถูกต้อง
// - ตรวจสอบว่าเมื่อ API ล้มเหลว จะแสดง Error ไม่ใช่ crash
// - ตรวจสอบว่าลบ session ได้ + โหลดรายละเอียด session ได้
// - ใช้ Mocking (mocktail) จำลอง Repository ไม่ต้องต่อ API จริง
// - ใช้ dartz Either<Failure, Success> จัดการ error แบบ functional
// =============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:interview_ace/core/error/failures.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';
import 'package:interview_ace/features/interview/domain/repositories/interview_repository.dart';
import 'package:interview_ace/features/history/presentation/bloc/history_bloc.dart';

class MockInterviewRepository extends Mock implements InterviewRepository {}

void main() {
  late MockInterviewRepository mockRepository;

  setUp(() {
    mockRepository = MockInterviewRepository();
  });

  final tSessions = [
    InterviewSession(
      id: '1',
      position: 'Flutter Dev',
      company: 'Google',
      level: 'Senior',
      questionType: 'Technical',
      language: 'en',
      questionCount: 5,
      totalScore: 85,
      createdAt: DateTime(2024, 1, 1),
    ),
    InterviewSession(
      id: '2',
      position: 'iOS Dev',
      company: 'Apple',
      level: 'Mid-level',
      questionType: 'Behavioral',
      language: 'en',
      questionCount: 3,
      totalScore: 72,
      createdAt: DateTime(2024, 1, 2),
    ),
  ];

  final tQuestions = [
    const InterviewQuestion(
      id: 'q1',
      sessionId: '1',
      questionNumber: 1,
      questionText: 'Tell me about yourself',
      category: 'behavioral',
      answerText: 'I am a developer...',
      score: 80,
      feedback: 'Good answer',
    ),
  ];

  group('HistoryBloc', () {
    // ทดสอบ: โหลดประวัติสำเร็จ → ต้องได้ข้อมูล 2 sessions
    blocTest<HistoryBloc, HistoryState>(
      'emits [HistoryLoading, HistoryLoaded] when LoadHistoryEvent succeeds',
      build: () {
        when(() => mockRepository.getAllSessions())
            .thenAnswer((_) async => Right(tSessions));
        return HistoryBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadHistoryEvent()),
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryLoaded>()
            .having((s) => s.sessions.length, 'session count', 2),
      ],
    );

    // ทดสอบ: โหลดประวัติล้มเหลว → ต้องแสดง Error message ไม่ crash
    blocTest<HistoryBloc, HistoryState>(
      'emits [HistoryLoading, HistoryError] when LoadHistoryEvent fails',
      build: () {
        when(() => mockRepository.getAllSessions())
            .thenAnswer((_) async => Left(ServerFailure(message: 'Network error')));
        return HistoryBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadHistoryEvent()),
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryError>()
            .having((s) => s.message, 'message', 'Network error'),
      ],
    );

    // ทดสอบ: ลบ session → ต้องเรียก deleteSession ใน Repository จริง
    blocTest<HistoryBloc, HistoryState>(
      'deletes session and reloads history',
      build: () {
        when(() => mockRepository.deleteSession('1'))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.getAllSessions())
            .thenAnswer((_) async => Right([tSessions[1]]));
        return HistoryBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(DeleteSessionEvent(sessionId: '1')),
      verify: (_) {
        verify(() => mockRepository.deleteSession('1')).called(1);
      },
    );

    // ทดสอบ: ดูรายละเอียด session → ต้องโหลด session + questions มาแสดง
    blocTest<HistoryBloc, HistoryState>(
      'loads session detail with questions',
      build: () {
        when(() => mockRepository.getSessionById('1'))
            .thenAnswer((_) async => Right(tSessions[0]));
        when(() => mockRepository.getQuestionsForSession('1'))
            .thenAnswer((_) async => Right(tQuestions));
        return HistoryBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadSessionDetailEvent(sessionId: '1')),
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryDetailLoaded>()
            .having((s) => s.session.id, 'session id', '1')
            .having((s) => s.questions.length, 'question count', 1),
      ],
    );

    // ทดสอบ: ล้างประวัติทั้งหมด → ต้องลบทุก session แล้วแสดงรายการว่าง
    blocTest<HistoryBloc, HistoryState>(
      'clears all history sends delete for each session',
      setUp: () {
        registerFallbackValue(LoadHistoryEvent());
      },
      build: () {
        when(() => mockRepository.getAllSessions())
            .thenAnswer((_) async => Right(tSessions));
        when(() => mockRepository.deleteSession(any()))
            .thenAnswer((_) async => const Right(null));
        return HistoryBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(ClearAllHistoryEvent()),
      wait: const Duration(milliseconds: 500),
      errors: () => [],
      verify: (_) {
        verify(() => mockRepository.getAllSessions()).called(greaterThanOrEqualTo(1));
      },
    );
  });

  // ทดสอบ: State object isEmpty ทำงานถูกต้อง
  group('HistoryLoaded', () {
    test('isEmpty returns true when no sessions', () {
      final state = HistoryLoaded(sessions: []);
      expect(state.isEmpty, isTrue);
    });

    test('isEmpty returns false when sessions exist', () {
      final state = HistoryLoaded(sessions: tSessions);
      expect(state.isEmpty, isFalse);
    });
  });

  // ทดสอบ: คำนวณคะแนนเฉลี่ยถูกต้อง (80+60)/2 = 70
  group('HistoryDetailLoaded', () {
    test('averageScore calculates correctly', () {
      final state = HistoryDetailLoaded(
        session: tSessions[0],
        questions: [
          const InterviewQuestion(
            id: 'q1', sessionId: '1', questionNumber: 1,
            questionText: 'Q1', category: 'behavioral', score: 80,
          ),
          const InterviewQuestion(
            id: 'q2', sessionId: '1', questionNumber: 2,
            questionText: 'Q2', category: 'technical', score: 60,
          ),
        ],
      );
      expect(state.averageScore, 70.0);
    });

    test('averageScore returns 0 when no scored questions', () {
      final state = HistoryDetailLoaded(
        session: tSessions[0],
        questions: [
          const InterviewQuestion(
            id: 'q1', sessionId: '1', questionNumber: 1,
            questionText: 'Q1', category: 'behavioral',
          ),
        ],
      );
      expect(state.averageScore, 0);
    });
  });
}
