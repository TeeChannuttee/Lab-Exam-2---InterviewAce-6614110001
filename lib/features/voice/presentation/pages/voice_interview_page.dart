import 'dart:convert';
import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/core/widgets/particle_background.dart';
import 'package:interview_ace/features/interview/data/datasources/remote/openai_remote_datasource.dart';
import 'package:interview_ace/features/interview/data/datasources/local/database/app_database.dart';
import 'package:interview_ace/features/gamification/data/services/gamification_service.dart';
import 'package:uuid/uuid.dart';

/// Voice interview — generates AI questions, supports Thai/EN speech, saves to DB
@RoutePage()
class VoiceInterviewPage extends StatefulWidget {
  const VoiceInterviewPage({super.key});

  @override
  State<VoiceInterviewPage> createState() => _VoiceInterviewPageState();
}

class _VoiceInterviewPageState extends State<VoiceInterviewPage>
    with TickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isAvailable = false;
  String _recognizedText = '';
  String _feedback = '';
  bool _isEvaluating = false;
  int _questionIndex = 0;
  double _soundLevel = 0;

  // Setup params (from SetupInterviewPage)
  String _position = '';
  String _company = '';
  String _level = 'junior';
  String _questionType = 'behavioral';
  String _language = 'en';
  int _count = 5;

  // AI-generated questions
  List<Map<String, dynamic>> _questions = [];
  bool _isLoadingQuestions = true;
  String? _loadError;

  // DB session tracking
  String _sessionId = '';
  final List<String> _questionIds = [];
  final List<double> _scores = [];

  late AnimationController _waveController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
    _initSpeech();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sessionId.isEmpty) {
      _loadSetupParams();
    }
  }

  void _loadSetupParams() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _position = args['position'] ?? '';
      _company = args['company'] ?? '';
      _level = args['level'] ?? 'junior';
      _questionType = args['type'] ?? 'behavioral';
      _language = args['language'] ?? 'en';
      _count = args['count'] ?? 5;
    } else {
      // Fallback: determine language from app locale
      final appLang = context.tr.locale;
      _language = appLang;
      _position = _language == 'th' ? 'ทั่วไป' : 'General';
      _company = '';
      _level = 'junior';
      _count = 5;
    }
    _createSessionAndLoadQuestions();
  }

  Future<void> _createSessionAndLoadQuestions() async {
    final uuid = const Uuid();
    _sessionId = uuid.v4();

    // Save session to DB
    try {
      final db = sl<AppDatabase>();
      await db.insertSessionData(
        id: _sessionId,
        position: _position,
        company: _company.isEmpty ? 'General' : _company,
        level: _level,
        questionType: _questionType,
        language: _language,
        questionCount: _count,
        timePerQuestion: 0,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('DB session insert error: $e');
    }

    // Generate questions via AI
    try {
      final openai = sl<OpenAIRemoteDataSource>();
      final questions = await openai.generateQuestions(
        position: _position,
        company: _company.isEmpty ? 'a company' : _company,
        level: _level,
        questionType: _questionType,
        language: _language,
        count: _count,
      );

      // Save questions to DB
      final db = sl<AppDatabase>();
      for (int i = 0; i < questions.length; i++) {
        final qId = uuid.v4();
        _questionIds.add(qId);
        await db.insertQuestionData(
          id: qId,
          sessionId: _sessionId,
          questionNumber: i + 1,
          questionText: questions[i]['question'] ?? '',
          category: questions[i]['category'] ?? 'behavioral',
        );
      }

      if (mounted) {
        setState(() {
          _questions = questions;
          _isLoadingQuestions = false;
        });
      }
    } catch (e) {
      debugPrint('Question generation error: $e');
      if (mounted) {
        setState(() {
          _loadError = e.toString();
          _isLoadingQuestions = false;
        });
      }
    }
  }

  Future<void> _initSpeech() async {
    _isAvailable = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
      onError: (error) {
        if (mounted) setState(() => _isListening = false);
      },
    );
    if (mounted) setState(() {});
  }

  void _toggleListening() async {
    if (!_isAvailable) return;

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() {
        _recognizedText = '';
        _feedback = '';
      });
      final localeId = _language == 'th' ? 'th_TH' : 'en_US';
      await _speech.listen(
        onResult: (result) {
          setState(() => _recognizedText = result.recognizedWords);
        },
        onSoundLevelChange: (level) {
          setState(() => _soundLevel = level.clamp(0, 10) / 10);
        },
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 5),
        localeId: localeId,
      );
      setState(() => _isListening = true);
    }
  }

  Future<void> _evaluateAnswer() async {
    if (_recognizedText.trim().isEmpty) return;
    setState(() => _isEvaluating = true);

    try {
      final openai = sl<OpenAIRemoteDataSource>();
      final currentQ = _questions[_questionIndex]['question'] ?? '';
      final result = await openai.evaluateAnswer(
        question: currentQ,
        answer: _recognizedText,
        level: _level,
        language: _language,
      );

      final score = (result['score'] as num?)?.toDouble() ?? 0;
      _scores.add(score);

      // Save answer to DB
      if (_questionIndex < _questionIds.length) {
        final db = sl<AppDatabase>();
        await db.updateQuestionData(
          id: _questionIds[_questionIndex],
          answerText: _recognizedText,
          score: score,
          feedback: result['feedback']?.toString(),
          idealAnswer: result['ideal_answer']?.toString(),
          starAnalysis: result['star_analysis'] is Map
              ? jsonEncode(result['star_analysis'])
              : result['star_analysis']?.toString(),
          suggestedKeywordsJson: result['suggested_keywords'] is List
              ? jsonEncode(result['suggested_keywords'])
              : null,
        );
      }

      if (mounted) {
        final tr = context.tr;
        setState(() {
          _feedback = '${tr.overallScore}: ${score.toInt()}/100\n\n'
              '${tr.feedback}: ${result['feedback']}\n\n'
              '${result['ideal_answer'] != null ? '${tr.kbExample}: ${result['ideal_answer']}' : ''}';
          _isEvaluating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _feedback = 'Error evaluating. Please try again.';
          _isEvaluating = false;
        });
      }
    }
  }

  void _nextQuestion() {
    if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
        _recognizedText = '';
        _feedback = '';
      });
    } else {
      _finishSession();
    }
  }

  Future<void> _finishSession() async {
    // Calculate final score and update DB
    double avgScore = 0;
    if (_scores.isNotEmpty) {
      avgScore = _scores.reduce((a, b) => a + b) / _scores.length;
      try {
        final db = sl<AppDatabase>();
        await db.updateSessionResultsData(
          sessionId: _sessionId,
          totalScore: avgScore,
          overallFeedback: 'Voice interview completed with ${_scores.length} questions answered.',
          strengths: 'Completed voice interview practice',
          weaknesses: '',
        );
      } catch (e) {
        debugPrint('DB update error: $e');
      }
    }

    // Record gamification (XP, badges, streak)
    try {
      final gamification = sl<GamificationService>();
      await gamification.recordSession(score: avgScore);
    } catch (e) {
      debugPrint('Gamification error: $e');
    }

    if (mounted) {
      final tr = context.tr;
      final displayScore = avgScore.toInt();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 28),
            const SizedBox(width: 10),
            Text(tr.interviewResult),
          ]),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('$displayScore%', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: displayScore >= 70 ? AppColors.success : AppColors.warning)),
            const SizedBox(height: 8),
            Text(tr.overallScore, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('${_scores.length}/${_questions.length} ${tr.questionLabel}', style: const TextStyle(fontSize: 13)),
          ]),
          actions: [
            TextButton(
              onPressed: () { Navigator.of(ctx).pop(); Navigator.of(context).pop(); },
              child: Text(tr.backToHome),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.voiceInterview),
        centerTitle: true,
        actions: [
          if (_questions.isNotEmpty && _feedback.isNotEmpty)
            TextButton.icon(
              onPressed: _nextQuestion,
              icon: Icon(_questionIndex < _questions.length - 1 ? Icons.skip_next_rounded : Icons.check_rounded, size: 18),
              label: Text(_questionIndex < _questions.length - 1 ? tr.nextQuestion : tr.finishInterview),
            ),
        ],
      ),
      body: ParticleBackground(
        particleCount: 8,
        child: SafeArea(
          child: _isLoadingQuestions
              ? _buildLoadingState(isDark)
              : _loadError != null
                  ? _buildErrorState(isDark)
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        _buildQuestionCard(isDark),
                        const SizedBox(height: 20),
                        Expanded(child: _buildVoiceVisualizer(isDark)),
                        if (_recognizedText.isNotEmpty) ...[_buildRecognizedText(isDark), const SizedBox(height: 12)],
                        if (_feedback.isNotEmpty) ...[_buildFeedbackCard(isDark), const SizedBox(height: 12)],
                        _buildActionButtons(isDark),
                        const SizedBox(height: 12),
                      ]),
                    ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    final tr = context.tr;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 20),
        Text(_language == 'th' ? 'กำลังสร้างคำถามสัมภาษณ์...' : 'Generating interview questions...',
            style: TextStyle(fontSize: 15, color: isDark ? Colors.white54 : Colors.grey[600])),
        const SizedBox(height: 8),
        Text('$_position · $_level', style: TextStyle(fontSize: 13, color: isDark ? Colors.white38 : Colors.grey[400])),
      ]),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(_language == 'th' ? 'ไม่สามารถสร้างคำถามได้' : 'Failed to generate questions',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(_loadError!, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              setState(() { _isLoadingQuestions = true; _loadError = null; });
              _createSessionAndLoadQuestions();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(_language == 'th' ? 'ลองอีกครั้ง' : 'Try Again'),
          ),
        ]),
      ),
    );
  }

  Widget _buildQuestionCard(bool isDark) {
    final q = _questions[_questionIndex];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.12), AppColors.accent.withValues(alpha: 0.06)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: Text('Q${_questionIndex + 1}/${_questions.length}',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text((q['category'] ?? '').toString().toUpperCase(),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
          ),
          const Spacer(),
          Icon(Icons.mic, size: 18, color: AppColors.primary.withValues(alpha: 0.5)),
        ]),
        const SizedBox(height: 12),
        Text(q['question'] ?? '', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.4)),
      ]),
    );
  }

  Widget _buildVoiceVisualizer(bool isDark) {
    return Center(
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, _) {
          return GestureDetector(
            onTap: _toggleListening,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: _isListening
                      ? [AppColors.error.withValues(alpha: 0.1 + _soundLevel * 0.2), Colors.transparent]
                      : [AppColors.primary.withValues(alpha: 0.05), Colors.transparent],
                ),
              ),
              child: Stack(alignment: Alignment.center, children: [
                if (_isListening)
                  ...List.generate(3, (i) {
                    final scale = 1.0 + ((_waveController.value + i * 0.33) % 1.0) * 0.5 + _soundLevel * 0.3;
                    final opacity = (1.0 - ((_waveController.value + i * 0.33) % 1.0)) * 0.3;
                    return Transform.scale(
                      scale: scale,
                      child: Container(width: 100, height: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                          border: Border.all(color: AppColors.error.withValues(alpha: opacity), width: 2))),
                    );
                  }),
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    final scale = _isListening ? 1.0 + _pulseController.value * 0.08 + _soundLevel * 0.1 : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isListening ? [AppColors.error, const Color(0xFFFF6B6B)] : [AppColors.primary, AppColors.accent],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: (_isListening ? AppColors.error : AppColors.primary).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 6))],
                        ),
                        child: Icon(_isListening ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 36),
                      ),
                    );
                  },
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecognizedText(bool isDark) {
    final tr = context.tr;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 100),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_language == 'th' ? 'คำตอบของคุณ:' : 'Your Answer:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(_recognizedText, style: TextStyle(fontSize: 13, height: 1.5, color: isDark ? Colors.white70 : Colors.grey[800])),
        ]),
      ),
    );
  }

  Widget _buildFeedbackCard(bool isDark) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 150),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: isDark ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: SingleChildScrollView(
        child: Text(_feedback, style: TextStyle(fontSize: 13, height: 1.5, color: isDark ? Colors.white70 : Colors.grey[800])),
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    final tr = context.tr;
    return Row(children: [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: _isListening ? null : _toggleListening,
          icon: Icon(_isListening ? Icons.hearing : Icons.mic_rounded, size: 18),
          label: Text(_isListening ? tr.listening : (_language == 'th' ? 'เริ่มพูด' : 'Start Speaking')),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      if (_recognizedText.isNotEmpty && !_isListening) ...[
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isEvaluating ? null : _evaluateAnswer,
            icon: _isEvaluating
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.auto_awesome, size: 18),
            label: Text(_isEvaluating ? (_language == 'th' ? 'กำลังประเมิน...' : 'Evaluating...') : (_language == 'th' ? 'ประเมิน AI' : 'AI Evaluate')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success, foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    ]);
  }
}
