import 'package:flutter/material.dart';

/// Animated Score Counter — slot-machine style number animation
class AnimatedScoreCounter extends StatelessWidget {
  final double score;
  final TextStyle? style;
  final Duration duration;
  final String suffix;

  const AnimatedScoreCounter({
    super.key,
    required this.score,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
    this.suffix = '%',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: score),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Text(
          '${value.toInt()}$suffix',
          style: style ?? TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
          ),
        );
      },
    );
  }
}

/// Animated XP Counter with level glow
class AnimatedXPCounter extends StatelessWidget {
  final int xp;
  final Color color;

  const AnimatedXPCounter({super.key, required this.xp, required this.color});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: xp.toDouble()),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeOutExpo,
      builder: (context, value, _) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
          ).createShader(bounds),
          child: Text(
            '${value.toInt()} XP',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
