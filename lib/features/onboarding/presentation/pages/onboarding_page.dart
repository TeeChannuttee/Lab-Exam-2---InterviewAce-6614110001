import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'dart:math' as math;

/// Premium Liquid-style Onboarding with page indicators and animated illustrations
@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _iconBounce;
  late AnimationController _bgController;

  final _pages = const [
    _OnboardingData(
      icon: Icons.psychology_rounded,
      title: 'AI-Powered Coaching',
      subtitle: 'Practice with an intelligent AI coach that\nadapts to your skill level and provides\nreal-time, personalized feedback.',
      gradient: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      emoji: '🧠',
    ),
    _OnboardingData(
      icon: Icons.mic_rounded,
      title: 'Voice Interview',
      subtitle: 'Answer questions using your voice.\nSpeech-to-Text technology captures\nyour responses for AI evaluation.',
      gradient: [Color(0xFFEC4899), Color(0xFFF472B6)],
      emoji: '🎤',
    ),
    _OnboardingData(
      icon: Icons.face_retouching_natural,
      title: 'Confidence Tracking',
      subtitle: 'ML Kit face detection monitors your\nconfidence in real-time — eye contact,\nsmile, and posture analysis.',
      gradient: [Color(0xFF10B981), Color(0xFF34D399)],
      emoji: '😊',
    ),
    _OnboardingData(
      icon: Icons.emoji_events_rounded,
      title: 'Gamified Learning',
      subtitle: 'Earn XP, unlock badges, maintain streaks,\nand level up from Beginner to\nInterview God!',
      gradient: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
      emoji: '🏆',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconBounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconBounce.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: _LiquidBgPainter(
                  progress: _bgController.value,
                  color: _pages[_currentPage].gradient[0],
                  isDark: isDark,
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.router.replaceNamed('/home'),
                    child: Text(
                      context.tr.skip,
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey[500],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: _pages.length,
                    itemBuilder: (ctx, i) => _buildPage(_pages[i], isDark),
                  ),
                ),
                // Indicators + button
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    children: [
                      // Page indicators
                      ...List.generate(_pages.length, (i) {
                        final isActive = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isActive ? 28 : 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: isActive
                                ? _pages[_currentPage].gradient[0]
                                : (isDark ? Colors.white24 : Colors.grey[300]),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                      const Spacer(),
                      // Next / Get Started button
                      GestureDetector(
                        onTap: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutCubic,
                            );
                          } else {
                            context.router.replaceNamed('/home');
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: _currentPage == _pages.length - 1 ? 28 : 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: _pages[_currentPage].gradient),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _pages[_currentPage].gradient[0].withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _pages.length - 1 ? context.tr.getStarted : context.tr.next,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingData data, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon
          AnimatedBuilder(
            animation: _iconBounce,
            builder: (context, _) {
              final y = math.sin(_iconBounce.value * math.pi) * 12;
              return Transform.translate(
                offset: Offset(0, -y),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: data.gradient),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: data.gradient[0].withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(data.emoji, style: const TextStyle(fontSize: 48)),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final String emoji;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.emoji,
  });
}

/// Liquid animated background painter
class _LiquidBgPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isDark;

  _LiquidBgPainter({required this.progress, required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: isDark ? 0.06 : 0.04)
      ..style = PaintingStyle.fill;

    // Blob 1
    final path1 = Path();
    final cx1 = size.width * (0.3 + math.sin(progress * math.pi * 2) * 0.1);
    final cy1 = size.height * (0.2 + math.cos(progress * math.pi * 2) * 0.05);
    path1.addOval(Rect.fromCenter(center: Offset(cx1, cy1), width: size.width * 0.8, height: size.width * 0.6));
    canvas.drawPath(path1, paint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60));

    // Blob 2
    final cx2 = size.width * (0.7 + math.cos(progress * math.pi * 2 + 1) * 0.08);
    final cy2 = size.height * (0.7 + math.sin(progress * math.pi * 2 + 1) * 0.06);
    final path2 = Path();
    path2.addOval(Rect.fromCenter(center: Offset(cx2, cy2), width: size.width * 0.6, height: size.width * 0.5));
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidBgPainter old) => true;
}
