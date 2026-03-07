import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Confetti animation widget — show particle confetti for celebrations
class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool trigger;

  const ConfettiOverlay({super.key, required this.child, this.trigger = false});

  @override
  State<ConfettiOverlay> createState() => ConfettiOverlayState();
}

class ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<_ConfettiPiece> _pieces = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _pieces = []);
        }
      });
  }

  @override
  void didUpdateWidget(ConfettiOverlay old) {
    super.didUpdateWidget(old);
    if (widget.trigger && !old.trigger) fire();
  }

  void fire() {
    setState(() {
      _pieces = List.generate(80, (_) => _ConfettiPiece(
        x: _random.nextDouble(),
        y: -_random.nextDouble() * 0.3,
        speedX: (_random.nextDouble() - 0.5) * 0.4,
        speedY: _random.nextDouble() * 0.5 + 0.3,
        rotation: _random.nextDouble() * math.pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        color: [
          const Color(0xFFFF6B6B),
          const Color(0xFF4ECDC4),
          const Color(0xFFFFE66D),
          const Color(0xFF6C5CE7),
          const Color(0xFFFF85A2),
          const Color(0xFF00D2D3),
          const Color(0xFFFF9FF3),
          const Color(0xFF54A0FF),
        ][_random.nextInt(8)],
        size: _random.nextDouble() * 8 + 4,
        shape: _random.nextInt(3),
      ));
    });
    _controller.forward(from: 0);
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
        widget.child,
        if (_pieces.isNotEmpty)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: _ConfettiPainter(
                  pieces: _pieces,
                  progress: _controller.value,
                ),
              );
            },
          ),
      ],
    );
  }
}

class _ConfettiPiece {
  final double x, y, speedX, speedY, rotation, rotationSpeed, size;
  final Color color;
  final int shape; // 0 = rect, 1 = circle, 2 = strip

  const _ConfettiPiece({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.size,
    required this.shape,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double progress;

  _ConfettiPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      final x = (p.x + p.speedX * progress) * size.width;
      final y = (p.y + p.speedY * progress + 0.5 * progress * progress) * size.height; // gravity
      final opacity = (1 - progress).clamp(0.0, 1.0);

      if (y > size.height) continue;

      final paint = Paint()..color = p.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + p.rotationSpeed * progress);

      switch (p.shape) {
        case 0:
          canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6), paint);
          break;
        case 1:
          canvas.drawCircle(Offset.zero, p.size * 0.4, paint);
          break;
        case 2:
          canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size * 0.3, height: p.size * 1.2), paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => true;
}
