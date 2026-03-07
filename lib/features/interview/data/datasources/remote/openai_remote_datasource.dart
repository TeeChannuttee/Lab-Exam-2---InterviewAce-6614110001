import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:interview_ace/core/network/dio_client.dart';
import 'package:uuid/uuid.dart';

/// Remote data source for OpenAI API calls
class OpenAIRemoteDataSource {
  final DioClient dioClient;

  OpenAIRemoteDataSource({required this.dioClient});

  String get _model => dotenv.env['OPENAI_MODEL'] ?? 'gpt-4o-mini';

  /// Generate interview questions
  Future<List<Map<String, dynamic>>> generateQuestions({
    required String position,
    required String company,
    required String level,
    required String questionType,
    required String language,
    required int count,
  }) async {
    final langInstruction =
        language == 'th' ? 'Respond in Thai language.' : 'Respond in English.';

    final prompt = '''
You are an expert HR interviewer at $company. Generate $count $questionType interview questions for a $level $position candidate.

$langInstruction

Return a JSON array of objects with these fields:
- "question": the interview question text
- "category": one of "behavioral", "technical", "situational"

Only return the JSON array, no other text.

Example:
[
  {"question": "Tell me about a time...", "category": "behavioral"},
  {"question": "How would you design...", "category": "technical"}
]
''';

    final response = await dioClient.dio.post(
      '/chat/completions',
      data: {
        'model': _model,
        'messages': [
          {'role': 'system', 'content': 'You are an expert HR interviewer. Always respond with valid JSON only.'},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.8,
        'max_tokens': 2000,
      },
    );

    final content = response.data['choices'][0]['message']['content'] as String;
    // Parse the JSON array from the response
    final cleanedContent = _extractJson(content);
    final List<dynamic> questions = jsonDecode(cleanedContent);
    return questions.cast<Map<String, dynamic>>();
  }

  /// Evaluate a user's answer
  Future<Map<String, dynamic>> evaluateAnswer({
    required String question,
    required String answer,
    required String level,
    required String language,
  }) async {
    final langInstruction =
        language == 'th' ? 'Respond in Thai language.' : 'Respond in English.';

    final prompt = '''
You are an expert HR interviewer evaluating a $level candidate's answer.

Question: "$question"
Candidate's Answer: "$answer"

$langInstruction

Evaluate the answer and return a JSON object with:
- "score": number from 0-100
- "feedback": detailed feedback (2-3 sentences)
- "ideal_answer": an example of an ideal answer (2-3 sentences)
- "star_analysis": STAR method breakdown - which parts (Situation/Task/Action/Result) were present and which were missing
- "suggested_keywords": array of 3-5 keywords the candidate should have used

Only return the JSON object, no other text.
''';

    final response = await dioClient.dio.post(
      '/chat/completions',
      data: {
        'model': _model,
        'messages': [
          {'role': 'system', 'content': 'You are an expert HR interviewer. Always respond with valid JSON only.'},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.5,
        'max_tokens': 1500,
      },
    );

    final content = response.data['choices'][0]['message']['content'] as String;
    final cleanedContent = _extractJson(content);
    return jsonDecode(cleanedContent) as Map<String, dynamic>;
  }

  /// Analyze resume text
  Future<Map<String, dynamic>> analyzeResume(String resumeText, {String language = 'en'}) async {
    final langInstruction =
        language == 'th' ? 'Respond in Thai language.' : 'Respond in English.';

    final prompt = '''
You are an expert ATS (Applicant Tracking System) analyzer used by top companies like Google, Amazon, and LINE.

Resume text:
"""
$resumeText
"""

Analyze this resume like a real ATS system would and return a JSON object with:

1. "ats_score": number 0-100 (how likely this resume passes ATS screening)
2. "analysis": overall analysis of the resume quality (3-4 sentences)
3. "strengths": array of 3-5 strong points found in the resume
4. "weaknesses": array of 3-5 areas that need improvement
5. "keywords_found": array of important professional keywords/skills found in resume
6. "keywords_missing": array of common keywords that are MISSING but SHOULD be included for better ATS compatibility
7. "format_checks": object with boolean values for resume format compliance:
   - "has_contact_info": does it have email/phone/linkedin?
   - "has_summary": does it have a professional summary or objective?
   - "has_education": does it list education?
   - "has_experience": does it list work experience?
   - "has_skills": does it have a skills section?
   - "proper_length": is the content appropriate length (not too short/long)?
   - "has_achievements": does it include measurable achievements?
8. "suggested_questions": array of 3-5 interview questions likely to be asked based on this resume
9. "improvement_tips": array of 3-5 specific, actionable tips to improve this resume for ATS compatibility

$langInstruction

Only return the JSON object, no other text.
''';

    final response = await dioClient.dio.post(
      '/chat/completions',
      data: {
        'model': _model,
        'messages': [
          {'role': 'system', 'content': 'You are an expert ATS system analyzer. Always respond with valid JSON only.'},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.5,
        'max_tokens': 3000,
      },
    );

    final content = response.data['choices'][0]['message']['content'] as String;
    final cleanedContent = _extractJson(content);
    return jsonDecode(cleanedContent) as Map<String, dynamic>;
  }

  /// Generate overall session feedback
  Future<Map<String, dynamic>> generateSessionFeedback({
    required String position,
    required String company,
    required String level,
    required List<Map<String, dynamic>> questionsAndAnswers,
    required String language,
  }) async {
    final langInstruction =
        language == 'th' ? 'Respond in Thai language.' : 'Respond in English.';

    final qaText = questionsAndAnswers
        .map((qa) =>
            'Q: ${qa['question']}\nA: ${qa['answer'] ?? "Skipped"}\nScore: ${qa['score'] ?? "N/A"}')
        .join('\n\n');

    final prompt = '''
You are an expert HR interviewer providing overall session feedback for a $level $position candidate at $company.

$langInstruction

Here are the questions and answers:
$qaText

Return a JSON object with:
- "overall_feedback": comprehensive feedback about the interview performance (3-4 sentences)
- "strengths": array of 2-3 key strengths demonstrated
- "weaknesses": array of 2-3 areas for improvement
- "total_score": overall average score (0-100)

Only return the JSON object, no other text.
''';

    final response = await dioClient.dio.post(
      '/chat/completions',
      data: {
        'model': _model,
        'messages': [
          {'role': 'system', 'content': 'You are an expert HR interviewer. Always respond with valid JSON only.'},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.5,
        'max_tokens': 1500,
      },
    );

    final content = response.data['choices'][0]['message']['content'] as String;
    final cleanedContent = _extractJson(content);
    return jsonDecode(cleanedContent) as Map<String, dynamic>;
  }

  /// Chat with AI interview coach (free-form conversation)
  Future<String> chatWithCoach({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
    String language = 'en',
  }) async {
    final langInstruction =
        language == 'th' ? 'Always respond in Thai language.' : 'Always respond in English.';

    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content': '''You are InterviewAce Coach — a friendly, expert interview coach with years of HR experience.

$langInstruction

Your personality:
- Encouraging but honest
- Use practical examples and actionable advice
- Keep responses concise but thorough (2-4 paragraphs max)
- Use emojis sparingly for friendliness
- Reference the STAR method when applicable
- Provide specific tips, not generic advice

You can help with:
- Interview question practice & mock interviews
- STAR method guidance
- Resume & cover letter tips
- Salary negotiation strategies
- Body language and confidence building
- Industry-specific interview prep'''
      },
      ...conversationHistory.map((m) => {
            'role': m['role'] ?? 'user',
            'content': m['content'] ?? '',
          }),
    ];

    final response = await dioClient.dio.post(
      '/chat/completions',
      data: {
        'model': _model,
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 1000,
      },
    );

    return response.data['choices'][0]['message']['content'] as String;
  }

  /// Analyze interview personality based on answer history
  Future<Map<String, dynamic>> analyzePersonality({
    required List<Map<String, dynamic>> answerHistory,
  }) async {
    final answersText = answerHistory
        .map((a) => 'Q: ${a['question']}\nA: ${a['answer']}')
        .join('\n\n');

    final prompt = '''
You are an expert career psychologist analyzing a candidate's interview personality based on their answers.

Here are the candidate's interview answers:
$answersText

Analyze their communication style, personality traits, and interview approach.

Return a JSON object with:
- "type": a 4-letter MBTI-style type (e.g., "ENTJ", "INFP", "ESTP", etc.)
- "title": a creative title for this type (e.g., "The Commander", "The Mediator")
- "subtitle": one-line description of this personality
- "traits": object with 6 traits scored 0.0-1.0: "Leadership", "Communication", "Analytical", "Adaptability", "Creativity", "Empathy"
- "strengths": array of 3-4 interview strengths
- "growth_areas": array of 2-3 areas to improve
- "ideal_roles": array of 3-4 job roles that suit this personality

Only return the JSON object, no other text.
''';

    final response = await dioClient.dio.post(
      '/chat/completions',
      data: {
        'model': _model,
        'messages': [
          {'role': 'system', 'content': 'You are an expert career psychologist. Always respond with valid JSON only.'},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.7,
        'max_tokens': 1500,
      },
    );

    final content = response.data['choices'][0]['message']['content'] as String;
    final cleanedContent = _extractJson(content);
    return jsonDecode(cleanedContent) as Map<String, dynamic>;
  }

  /// Generate interview questions from a Job Description
  Future<Map<String, dynamic>> generateQuestionsFromJD({
    required String jobDescription,
  }) async {
    final prompt = '''
You are an expert HR consultant. Analyze this job description and generate tailored interview preparation.

Job Description:
$jobDescription

Return a JSON object with:
- "job_title": extracted job title
- "company": extracted company name (or "Unknown")
- "key_skills": array of 5-8 key skills required
- "questions": array of 8 objects, each with:
  - "question": tailored interview question
  - "category": "behavioral" | "technical" | "situational"
  - "difficulty": "easy" | "medium" | "hard"
  - "tips": brief answer guidance
- "preparation_tips": array of 4-5 overall preparation tips

Only return the JSON object, no other text.
''';

    final response = await dioClient.dio.post(
      '/chat/completions',
      data: {
        'model': _model,
        'messages': [
          {'role': 'system', 'content': 'You are an expert HR consultant. Always respond with valid JSON only.'},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.7,
        'max_tokens': 2500,
      },
    );

    final content = response.data['choices'][0]['message']['content'] as String;
    return jsonDecode(_extractJson(content)) as Map<String, dynamic>;
  }

  /// Research a company for interview preparation
  Future<Map<String, dynamic>> researchCompany({
    required String companyName,
    String? position,
    String language = 'en',
  }) async {
    final langInstruction =
        language == 'th' ? 'Respond in Thai language.' : 'Respond in English.';
    final positionContext = position != null ? ' for a $position position' : '';
    final prompt = '''
You are a career research expert. Research "$companyName" and provide comprehensive interview preparation$positionContext.

$langInstruction

Return a JSON object with:
- "company_name": "$companyName"
- "industry": the company's industry
- "overview": 2-3 sentence company overview
- "culture_values": array of 4-5 key culture values
- "interview_style": description of their typical interview process
- "common_questions": array of 5 frequently asked questions at this company
- "tips": array of 5 specific tips for interviewing at this company
- "what_they_look_for": array of 4-5 traits they value in candidates
- "salary_range": estimated salary range for this role (or "Varies by role")
- "fun_fact": one interesting fact about the company

Only return the JSON object, no other text.
''';

    final response = await dioClient.dio.post(
      '/chat/completions',
      data: {
        'model': _model,
        'messages': [
          {'role': 'system', 'content': 'You are a career research expert. Always respond with valid JSON only.'},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.7,
        'max_tokens': 2000,
      },
    );

    final content = response.data['choices'][0]['message']['content'] as String;
    return jsonDecode(_extractJson(content)) as Map<String, dynamic>;
  }

  /// Salary negotiation chat — AI plays HR role
  Future<String> negotiateSalary({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
    required String difficulty, // 'easy', 'medium', 'hard'
  }) async {
    final personality = difficulty == 'easy'
        ? 'You are a friendly, flexible HR manager willing to negotiate.'
        : difficulty == 'hard'
            ? 'You are a tough, budget-conscious HR manager. Push back firmly but fairly.'
            : 'You are a balanced HR manager. You\'re open to discussion but have limits.';

    final messages = [
      {
        'role': 'system',
        'content': '''$personality
You are conducting a salary negotiation with a job candidate.
- Start by offering a reasonable salary
- Respond to their counter-offers realistically
- Consider benefits, bonuses, equity as alternatives
- Keep responses concise (2-4 sentences)
- After 5-6 exchanges, indicate the final offer
- Be realistic and professional'''
      },
      ...conversationHistory.map((m) => {
            'role': m['role'] ?? 'user',
            'content': m['content'] ?? '',
          }),
    ];

    final response = await dioClient.dio.post(
      '/chat/completions',
      data: {
        'model': _model,
        'messages': messages,
        'temperature': 0.8,
        'max_tokens': 500,
      },
    );

    return response.data['choices'][0]['message']['content'] as String;
  }

  /// Extract JSON from potential markdown code blocks
  String _extractJson(String text) {
    // Remove markdown code block markers if present
    var cleaned = text.trim();
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    return cleaned.trim();
  }
}
