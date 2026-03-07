import 'package:flutter/material.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'dart:math';

/// AI Tips of the Day — rotating interview tips with premium card design
class AiTipOfTheDay extends StatelessWidget {
  const AiTipOfTheDay({super.key});

  static final _tips = [
    _Tip('💡', 'Use the STAR Method', 'Structure your answers: Situation → Task → Action → Result. This keeps your responses organized and impactful.'),
    _Tip('🎯', 'Research the Company', 'Spend 30 minutes researching the company culture, recent news, and key products before your interview.'),
    _Tip('🗣️', 'Practice Out Loud', 'Rehearsing answers out loud helps you sound more natural and confident during the actual interview.'),
    _Tip('⏱️', 'Keep Answers 2-3 Minutes', 'Long answers lose attention. Aim for 2-3 minute responses that hit key points concisely.'),
    _Tip('🤝', 'Ask Thoughtful Questions', 'Prepare 3-5 questions about the role, team, or company growth to show genuine interest.'),
    _Tip('📊', 'Quantify Your Achievements', 'Use numbers! "Increased sales by 30%" is far more impactful than "improved sales."'),
    _Tip('😊', 'Mirror Body Language', 'Subtly match the interviewer\'s energy and posture to build unconscious rapport.'),
    _Tip('🚫', 'Never Speak Negatively', 'Avoid negative comments about previous employers. Frame challenges as learning opportunities.'),
    _Tip('💪', 'Own Your Weaknesses', 'Turn weaknesses into growth stories: "I used to struggle with X, so I developed Y approach."'),
    _Tip('📝', 'Follow Up Within 24hrs', 'Send a thank-you email that references specific conversation points from the interview.'),
    _Tip('🎭', 'Prepare Your Elevator Pitch', 'Have a 60-second intro ready: who you are, key achievements, and why this role excites you.'),
    _Tip('👀', 'Maintain Eye Contact', 'Look at the interviewer\'s forehead triangle (eyes to nose) for natural, confident eye contact.'),
    _Tip('🔄', 'Prepare for Common Questions', '"Tell me about yourself" and "Why this company?" come up in 90% of interviews. Nail these first.'),
    _Tip('🌟', 'Show Enthusiasm', 'Genuine excitement about the role is one of the top factors interviewers use to make hiring decisions.'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todayIndex = DateTime.now().day % _tips.length;
    final tip = _tips[todayIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.15 : 0.08),
            const Color(0xFFEC4899).withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(tip.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tip of the Day',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8B5CF6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      tip.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF8B5CF6)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            tip.description,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tip {
  final String emoji;
  final String title;
  final String description;
  const _Tip(this.emoji, this.title, this.description);
}
