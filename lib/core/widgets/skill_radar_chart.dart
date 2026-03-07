import 'dart:math';
import 'package:flutter/material.dart';
import 'package:interview_ace/core/constants/app_colors.dart';

/// Custom-painted Radar Chart widget — white/navy corporate theme
/// Displays interview scores across multiple skill dimensions
class SkillRadarChart extends StatefulWidget {
  final Map<String, double> skills; // "Skill Name" → 0.0 to 1.0
  final double size;

  const SkillRadarChart({
    super.key,
    required this.skills,
    this.size = 220,
  });

  @override
  State<SkillRadarChart> createState() => _SkillRadarChartState();
}

class _SkillRadarChartState extends State<SkillRadarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size + 16,
          child: CustomPaint(
            painter: _RadarChartPainter(
              scores: widget.skills,
              progress: _animation.value,
              isDark: isDark,
            ),
          ),
        );
      },
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final Map<String, double> scores;
  final double progress;
  final bool isDark;

  _RadarChartPainter({
    required this.scores,
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 8);
    final radius = size.width / 2 - 30;
    final keys = scores.keys.toList();
    final n = keys.length;
    if (n < 3) return;

    final angleStep = 2 * pi / n;
    final startAngle = -pi / 2;

    // Grid rings (3 concentric polygons)
    for (int ring = 1; ring <= 3; ring++) {
      final r = radius * ring / 3;
      final gridPaint = Paint()
        ..color = isDark
            ? Colors.white.withValues(alpha: 0.07)
            : const Color(0xFFE5E7EB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;

      final path = Path();
      for (int i = 0; i <= n; i++) {
        final angle = startAngle + angleStep * (i % n);
        final point = Offset(
          center.dx + r * cos(angle),
          center.dy + r * sin(angle),
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(path, gridPaint);
    }

    // Axis lines
    final axisPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.05)
          : const Color(0xFFF0F0F0)
      ..strokeWidth = 0.6;

    for (int i = 0; i < n; i++) {
      final angle = startAngle + angleStep * i;
      final end = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(center, end, axisPaint);
    }

    // Data polygon — animated fill
    final dataPath = Path();
    final dataPoints = <Offset>[];
    for (int i = 0; i <= n; i++) {
      final idx = i % n;
      final angle = startAngle + angleStep * idx;
      final value = (scores[keys[idx]] ?? 0) * progress;
      final r = radius * value;
      final point = Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );
      dataPoints.add(point);
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }

    // Fill
    final fillPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Stroke
    final strokePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(dataPath, strokePaint);

    // Data dots
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    for (int i = 0; i < n; i++) {
      canvas.drawCircle(dataPoints[i], 3, dotPaint);
    }

    // Labels
    for (int i = 0; i < n; i++) {
      final angle = startAngle + angleStep * i;
      final labelRadius = radius + 18;
      final labelPos = Offset(
        center.dx + labelRadius * cos(angle),
        center.dy + labelRadius * sin(angle),
      );

      final textSpan = TextSpan(
        text: keys[i],
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white54 : AppColors.lightTextSecondary,
          fontFamily: 'Inter',
        ),
      );
      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(
        labelPos.dx - tp.width / 2,
        labelPos.dy - tp.height / 2,
      ));
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter old) =>
      old.progress != progress || old.scores != scores;
}
