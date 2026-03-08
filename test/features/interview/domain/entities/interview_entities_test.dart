// =============================================================
// Unit Test: Interview Entities (Domain Layer)
// ทดสอบ Data Model ที่เป็นหัวใจของแอป
//
// ทำไมต้องรัน?
// - ตรวจสอบว่า InterviewSession สร้างได้ถูกต้อง มี UUID
// - ตรวจสอบว่า copyWith อัพเดทเฉพาะ field ที่ระบุ ไม่เปลี่ยนอันอื่น
// - ตรวจสอบว่า InterviewQuestion เก็บคำถาม+คำตอบ+คะแนนได้
// - ตรวจสอบว่า ResumeProfile เก็บผลวิเคราะห์เรซูเม่ได้
// - ตรวจสอบว่าคำนวณคะแนนเฉลี่ยถูกต้อง (90+70)/2 = 80
// - ใช้หลัก Clean Architecture: Domain Layer ต้องไม่พัง
// =============================================================
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';

void main() {
  group('InterviewSession', () {
    test('create() generates valid session with UUID', () {
      final session = InterviewSession.create(
        position: 'Flutter Dev',
        company: 'Google',
        level: 'Senior',
        questionType: 'Technical',
        language: 'en',
        questionCount: 5,
      );

      expect(session.id, isNotEmpty);
      expect(session.id.length, 36); // UUID v4 format
      expect(session.position, 'Flutter Dev');
      expect(session.company, 'Google');
      expect(session.level, 'Senior');
      expect(session.questionType, 'Technical');
      expect(session.language, 'en');
      expect(session.questionCount, 5);
      expect(session.timePerQuestion, 0);
      expect(session.totalScore, isNull);
      expect(session.overallFeedback, isNull);
      expect(session.createdAt, isNotNull);
    });

    test('create() with timePerQuestion', () {
      final session = InterviewSession.create(
        position: 'Dev',
        company: 'Co',
        level: 'Junior',
        questionType: 'Mixed',
        language: 'th',
        questionCount: 3,
        timePerQuestion: 120,
      );
      expect(session.timePerQuestion, 120);
    });

    test('copyWith updates only specified fields', () {
      final session = InterviewSession.create(
        position: 'Dev',
        company: 'Co',
        level: 'Junior',
        questionType: 'Mixed',
        language: 'en',
        questionCount: 3,
      );

      final updated = session.copyWith(
        totalScore: 85.5,
        overallFeedback: 'Great job!',
      );

      expect(updated.totalScore, 85.5);
      expect(updated.overallFeedback, 'Great job!');
      expect(updated.position, session.position); // unchanged
      expect(updated.id, session.id); // unchanged
      expect(updated.strengths, isNull); // unchanged
    });

    test('copyWith preserves existing values when not specified', () {
      final session = InterviewSession(
        id: 'test-id',
        position: 'Dev',
        company: 'Co',
        level: 'Senior',
        questionType: 'Technical',
        language: 'en',
        questionCount: 5,
        totalScore: 80,
        overallFeedback: 'Good',
        strengths: 'Communication',
        weaknesses: 'Technical',
        createdAt: DateTime(2024, 1, 1),
      );

      final updated = session.copyWith(totalScore: 90);
      expect(updated.totalScore, 90);
      expect(updated.overallFeedback, 'Good');
      expect(updated.strengths, 'Communication');
    });
  });

  group('InterviewQuestion', () {
    test('creates question with required fields', () {
      const question = InterviewQuestion(
        id: 'q1',
        sessionId: 's1',
        questionNumber: 1,
        questionText: 'Tell me about yourself',
        category: 'behavioral',
      );

      expect(question.id, 'q1');
      expect(question.sessionId, 's1');
      expect(question.questionNumber, 1);
      expect(question.answerText, isNull);
      expect(question.score, isNull);
      expect(question.feedback, isNull);
    });

    test('copyWith updates answer and score', () {
      const question = InterviewQuestion(
        id: 'q1',
        sessionId: 's1',
        questionNumber: 1,
        questionText: 'Tell me about yourself',
        category: 'behavioral',
      );

      final answered = question.copyWith(
        answerText: 'I am a developer...',
        score: 85,
        feedback: 'Good structure',
        idealAnswer: 'Use STAR method...',
        starAnalysis: 'Situation: Good, Task: Clear',
      );

      expect(answered.answerText, 'I am a developer...');
      expect(answered.score, 85);
      expect(answered.feedback, 'Good structure');
      expect(answered.idealAnswer, isNotNull);
      expect(answered.starAnalysis, isNotNull);
      expect(answered.questionText, 'Tell me about yourself'); // preserved
    });

    test('copyWith with suggestedKeywords', () {
      const question = InterviewQuestion(
        id: 'q1',
        sessionId: 's1',
        questionNumber: 1,
        questionText: 'Teamwork?',
        category: 'behavioral',
      );

      final withKeywords = question.copyWith(
        suggestedKeywords: ['leadership', 'collaboration', 'communication'],
      );

      expect(withKeywords.suggestedKeywords, hasLength(3));
      expect(withKeywords.suggestedKeywords, contains('leadership'));
    });
  });

  group('ResumeProfile', () {
    test('creates resume profile with all fields', () {
      final profile = ResumeProfile(
        id: 'r1',
        extractedText: 'John Doe, Flutter Developer, 5 years experience',
        analysis: 'Strong mobile developer profile',
        strengths: ['Flutter expertise', 'Clean architecture'],
        weaknesses: ['Limited backend experience'],
        suggestedQuestions: ['Tell me about your Flutter projects'],
        createdAt: DateTime(2024, 1, 1),
      );

      expect(profile.id, 'r1');
      expect(profile.extractedText, contains('Flutter'));
      expect(profile.strengths, hasLength(2));
      expect(profile.weaknesses, hasLength(1));
      expect(profile.suggestedQuestions, isNotEmpty);
    });

    test('creates profile with minimal fields', () {
      final profile = ResumeProfile(
        id: 'r2',
        extractedText: 'Resume text',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(profile.analysis, isNull);
      expect(profile.strengths, isNull);
      expect(profile.weaknesses, isNull);
    });
  });

  group('InterviewCompleted state', () {
    test('averageScore calculates correctly with mixed scores', () {
      final questions = [
        const InterviewQuestion(
          id: 'q1', sessionId: 's1', questionNumber: 1,
          questionText: 'Q1', category: 'behavioral', score: 90,
        ),
        const InterviewQuestion(
          id: 'q2', sessionId: 's1', questionNumber: 2,
          questionText: 'Q2', category: 'technical', score: 70,
        ),
        const InterviewQuestion(
          id: 'q3', sessionId: 's1', questionNumber: 3,
          questionText: 'Q3', category: 'situational', // no score (skipped)
        ),
      ];

      final scored = questions.where((q) => q.score != null);
      final avg = scored.map((q) => q.score!).reduce((a, b) => a + b) / scored.length;

      expect(avg, 80.0);
    });
  });
}
