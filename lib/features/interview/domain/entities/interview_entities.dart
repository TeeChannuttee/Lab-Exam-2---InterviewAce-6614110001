import 'package:uuid/uuid.dart';

/// Domain entity for an interview session
class InterviewSession {
  final String id;
  final String position;
  final String company;
  final String level; // junior, mid, senior, lead
  final String questionType; // behavioral, technical, situational, mixed
  final String language; // en, th
  final int questionCount;
  final int timePerQuestion; // seconds, 0 = unlimited
  final double? totalScore;
  final String? overallFeedback;
  final String? strengths;
  final String? weaknesses;
  final DateTime createdAt;

  const InterviewSession({
    required this.id,
    required this.position,
    required this.company,
    required this.level,
    required this.questionType,
    required this.language,
    required this.questionCount,
    this.timePerQuestion = 0,
    this.totalScore,
    this.overallFeedback,
    this.strengths,
    this.weaknesses,
    required this.createdAt,
  });

  factory InterviewSession.create({
    required String position,
    required String company,
    required String level,
    required String questionType,
    required String language,
    required int questionCount,
    int timePerQuestion = 0,
  }) {
    return InterviewSession(
      id: const Uuid().v4(),
      position: position,
      company: company,
      level: level,
      questionType: questionType,
      language: language,
      questionCount: questionCount,
      timePerQuestion: timePerQuestion,
      createdAt: DateTime.now(),
    );
  }

  InterviewSession copyWith({
    double? totalScore,
    String? overallFeedback,
    String? strengths,
    String? weaknesses,
  }) {
    return InterviewSession(
      id: id,
      position: position,
      company: company,
      level: level,
      questionType: questionType,
      language: language,
      questionCount: questionCount,
      timePerQuestion: timePerQuestion,
      totalScore: totalScore ?? this.totalScore,
      overallFeedback: overallFeedback ?? this.overallFeedback,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      createdAt: createdAt,
    );
  }
}

/// Domain entity for an interview question
class InterviewQuestion {
  final String id;
  final String sessionId;
  final int questionNumber;
  final String questionText;
  final String category; // behavioral, technical, situational
  final String? answerText;
  final double? score;
  final String? feedback;
  final String? idealAnswer;
  final String? starAnalysis; // STAR method breakdown
  final List<String>? suggestedKeywords;

  const InterviewQuestion({
    required this.id,
    required this.sessionId,
    required this.questionNumber,
    required this.questionText,
    required this.category,
    this.answerText,
    this.score,
    this.feedback,
    this.idealAnswer,
    this.starAnalysis,
    this.suggestedKeywords,
  });

  InterviewQuestion copyWith({
    String? answerText,
    double? score,
    String? feedback,
    String? idealAnswer,
    String? starAnalysis,
    List<String>? suggestedKeywords,
  }) {
    return InterviewQuestion(
      id: id,
      sessionId: sessionId,
      questionNumber: questionNumber,
      questionText: questionText,
      category: category,
      answerText: answerText ?? this.answerText,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
      idealAnswer: idealAnswer ?? this.idealAnswer,
      starAnalysis: starAnalysis ?? this.starAnalysis,
      suggestedKeywords: suggestedKeywords ?? this.suggestedKeywords,
    );
  }
}

/// Domain entity for resume analysis
class ResumeProfile {
  final String id;
  final String extractedText;
  final String? analysis;
  final List<String>? strengths;
  final List<String>? weaknesses;
  final List<String>? suggestedQuestions;
  final int? atsScore;
  final List<String>? keywordsFound;
  final List<String>? keywordsMissing;
  final Map<String, bool>? formatChecks;
  final List<String>? improvementTips;
  final DateTime createdAt;

  const ResumeProfile({
    required this.id,
    required this.extractedText,
    this.analysis,
    this.strengths,
    this.weaknesses,
    this.suggestedQuestions,
    this.atsScore,
    this.keywordsFound,
    this.keywordsMissing,
    this.formatChecks,
    this.improvementTips,
    required this.createdAt,
  });
}
