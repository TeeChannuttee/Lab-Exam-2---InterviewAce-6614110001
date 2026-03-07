import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/interview/data/datasources/remote/openai_remote_datasource.dart';
import 'dart:math' as math;

/// Salary Negotiation Simulator — practice negotiating with AI HR manager
@RoutePage()
class SalaryNegotiationPage extends StatefulWidget {
  const SalaryNegotiationPage({super.key});

  @override
  State<SalaryNegotiationPage> createState() => _SalaryNegotiationPageState();
}

class _SalaryNegotiationPageState extends State<SalaryNegotiationPage>
    with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMsg> _messages = [];
  bool _isTyping = false;
  String _difficulty = 'medium';
  bool _started = false;
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  void _startNegotiation() {
    setState(() {
      _started = true;
      _messages.clear();
      _messages.add(_ChatMsg(
        text: context.tr.salaryWelcome,
        isUser: false,
      ));
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMsg(text: text, isUser: true));
      _isTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    try {
      final openai = sl<OpenAIRemoteDataSource>();
      final history = _messages.map((m) => {
        'role': m.isUser ? 'user' : 'assistant',
        'content': m.text,
      }).toList();

      final response = await openai.negotiateSalary(
        userMessage: text,
        conversationHistory: history,
        difficulty: _difficulty,
      );

      if (mounted) {
        setState(() {
          _messages.add(_ChatMsg(text: response, isUser: false));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMsg(text: context.tr.salaryConnError, isUser: false));
          _isTyping = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tr = context.tr;

    if (!_started) return _buildSetupScreen(isDark);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.business_center, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('HR Manager', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                Text(
                  _difficulty == 'easy' ? tr.salaryFriendly : _difficulty == 'hard' ? tr.salaryTough : tr.salaryBalanced,
                  style: const TextStyle(fontSize: 11, color: AppColors.warning),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i == _messages.length && _isTyping) return _buildTypingDots(isDark);
                return _buildBubble(_messages[i], isDark);
              },
            ),
          ),
          _buildInput(isDark),
        ],
      ),
    );
  }

  Widget _buildSetupScreen(bool isDark) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr.salaryNegotiation), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  const Color(0xFFEF4444).withValues(alpha: 0.04),
                ]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.monetization_on_outlined, size: 56, color: Color(0xFFF59E0B)),
                  const SizedBox(height: 14),
                  Text(context.tr.salarySimTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(context.tr.salarySimSub,
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600], fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Text(context.tr.selectDifficulty, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...['easy', 'medium', 'hard'].map((d) {
              final isSelected = _difficulty == d;
              final icon = d == 'easy' ? Icons.sentiment_satisfied_alt : d == 'hard' ? Icons.sentiment_very_dissatisfied : Icons.sentiment_neutral;
              final label = d == 'easy' ? context.tr.salaryDiffEasy : d == 'hard' ? context.tr.salaryDiffHard : context.tr.salaryDiffMedium;
              final desc = d == 'easy' ? context.tr.salaryDiffEasyDesc : d == 'hard' ? context.tr.salaryDiffHardDesc : context.tr.salaryDiffMediumDesc;
              final color = d == 'easy' ? AppColors.success : d == 'hard' ? AppColors.error : AppColors.warning;

              return GestureDetector(
                onTap: () => setState(() => _difficulty = d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: isDark ? 0.12 : 0.06) : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSelected ? color : (isDark ? Colors.white10 : Colors.grey[200]!), width: isSelected ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, size: 28, color: color),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: isSelected ? color : null)),
                            Text(desc, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
                          ],
                        ),
                      ),
                      if (isSelected) Icon(Icons.check_circle, color: color, size: 22),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startNegotiation,
                icon: const Icon(Icons.handshake_rounded),
                label: Text(context.tr.startNegotiation),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(_ChatMsg msg, bool isDark) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28, height: 28,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.business_center, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[100]),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
              ),
              child: Text(msg.text, style: TextStyle(
                color: isUser ? Colors.white : (isDark ? Colors.white70 : Colors.grey[800]),
                fontSize: 14, height: 1.4,
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDots(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.business_center, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomRight: Radius.circular(18), bottomLeft: Radius.circular(4),
              ),
            ),
            child: AnimatedBuilder(
              animation: _dotController,
              builder: (ctx, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final t = ((_dotController.value - i * 0.33) % 1).clamp(0.0, 1.0);
                  return Transform.translate(
                    offset: Offset(0, -math.sin(t * math.pi) * 4),
                    child: Container(
                      width: 8, height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.5 + t * 0.5), shape: BoxShape.circle),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: 3, minLines: 1,
              decoration: InputDecoration(
                hintText: context.tr.yourCounterOffer,
                hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.grey[400]),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                filled: true,
                fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44, height: 44,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: () => _sendMessage(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMsg {
  final String text;
  final bool isUser;
  _ChatMsg({required this.text, required this.isUser});
}
