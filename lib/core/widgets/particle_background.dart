import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Subtle animated particle background — clean corporate style
class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final List<Color>? colors;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 8,
    this.colors,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _particles = List.generate(widget.particleCount, (_) => _generateParticle());
  }

  _Particle _generateParticle() {
    final colors = widget.colors ?? [
      const Color(0xFF1B2A4A).withValues(alpha: 0.03),
      const Color(0xFF2D4A7A).withValues(alpha: 0.025),
      const Color(0xFF8B7355).withValues(alpha: 0.02),
      const Color(0xFF6B7280).withValues(alpha: 0.02),
    ];

    return _Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      radius: _random.nextDouble() * 50 + 15,
      speedX: (_random.nextDouble() - 0.5) * 0.015,
      speedY: (_random.nextDouble() - 0.5) * 0.01,
      color: colors[_random.nextInt(colors.length)],
      phase: _random.nextDouble() * math.pi * 2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: Size.infinite,
              painter: _ParticlePainter(
                particles: _particles,
                time: _controller.value,
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _Particle {
  double x;
  double y;
  final double radius;
  final double speedX;
  final double speedY;
  final Color color;
  final double phase;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.color,
    required this.phase,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double time;

  _ParticlePainter({required this.particles, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final x = (p.x + math.sin(time * math.pi * 2 + p.phase) * 0.04) * size.width;
      final y = (p.y + math.cos(time * math.pi * 2 + p.phase) * 0.03) * size.height;

      final paint = Paint()
        ..color = p.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 0.7);

      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => true;
}
