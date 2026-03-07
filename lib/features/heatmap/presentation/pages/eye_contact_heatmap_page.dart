import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/confidence/data/services/face_detection_service.dart';
import 'dart:math' as math;

/// Eye Contact Heatmap — uses REAL FaceDetectionService data from ML Kit
@RoutePage()
class EyeContactHeatmapPage extends StatefulWidget {
  const EyeContactHeatmapPage({super.key});

  @override
  State<EyeContactHeatmapPage> createState() => _EyeContactHeatmapPageState();
}

class _EyeContactHeatmapPageState extends State<EyeContactHeatmapPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late final FaceDetectionService _faceService;
  List<ConfidenceSnapshot> _snapshots = [];

  @override
  void initState() {
    super.initState();
    _faceService = sl<FaceDetectionService>();
    _snapshots = _faceService.sessionSnapshots
        .where((s) => s.faceDetected)
        .toList();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasData = _snapshots.isNotEmpty;

    // Calculate real eye contact percentage
    final eyeContactPct = hasData
        ? _snapshots.map((s) => s.eyeContactScore).reduce((a, b) => a + b) /
            _snapshots.length
        : 0.0;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.eyeContactHeatmap), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (!hasData) _buildNoData(isDark) else ...[
              // Real data badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text('Real ML Kit Data · ${_snapshots.length} frames analyzed',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Score card
              _buildScoreCard(eyeContactPct, isDark),
              const SizedBox(height: 20),

              // Heatmap
              Container(
                width: double.infinity,
                height: 340,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, _) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: _HeatmapPainter(
                          snapshots: _snapshots,
                          progress: _animController.value,
                          isDark: isDark,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Legend
              _buildLegend(isDark),
              const SizedBox(height: 20),

              // Detailed metrics
              _buildDetailedMetrics(isDark),
              const SizedBox(height: 20),

              // Tips
              _buildTips(eyeContactPct, isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoData(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            const Text('👁️', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(context.tr.noData,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            Text(context.tr.useConfidenceFirst,
                textAlign: TextAlign.center,
                style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.router.pushNamed('/confidence'),
              icon: const Icon(Icons.camera_alt_rounded),
              label: Text(context.tr.confidenceTracker),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(double pct, bool isDark) {
    final color = pct >= 70 ? AppColors.success : pct >= 40 ? AppColors.warning : AppColors.error;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Text('👁️', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Eye Contact Score', style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: pct),
                duration: const Duration(milliseconds: 1500),
                builder: (_, v, __) => Text('${v.toInt()}%',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: color)),
              ),
            ],
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
            child: Text(pct >= 70 ? 'Great!' : pct >= 40 ? 'Fair' : 'Improve',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMetrics(bool isDark) {
    final avgSmile = _snapshots.map((s) => s.smileScore).reduce((a, b) => a + b) / _snapshots.length;
    final avgPosture = _snapshots.map((s) => s.postureScore).reduce((a, b) => a + b) / _snapshots.length;
    final avgEye = _snapshots.map((s) => s.eyeContactScore).reduce((a, b) => a + b) / _snapshots.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📊 Detailed Metrics (from ML Kit)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 12),
          _metricRow('Eye Contact', avgEye, isDark),
          _metricRow('Smile', avgSmile, isDark),
          _metricRow('Posture', avgPosture, isDark),
        ],
      ),
    );
  }

  Widget _metricRow(String label, double value, bool isDark) {
    final color = value >= 70 ? AppColors.success : value >= 40 ? AppColors.warning : AppColors.error;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: TextStyle(fontSize: 12))),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value / 100),
              duration: const Duration(milliseconds: 1500),
              builder: (_, v, __) => ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: v, minHeight: 6,
                  backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 36, child: Text('${value.toInt()}%',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
        ],
      ),
    );
  }

  Widget _buildLegend(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Low', style: TextStyle(fontSize: 10, color: isDark ? Colors.white24 : Colors.grey[400])),
        const SizedBox(width: 6),
        ...List.generate(5, (i) => Container(
              width: 20, height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: Color.lerp(Colors.blue.withValues(alpha: 0.1), Colors.red, i / 4)!.withValues(alpha: 0.5 + i * 0.12),
                borderRadius: BorderRadius.circular(2),
              ))),
        const SizedBox(width: 6),
        Text('High', style: TextStyle(fontSize: 10, color: isDark ? Colors.white24 : Colors.grey[400])),
      ],
    );
  }

  Widget _buildTips(double pct, bool isDark) {
    final tips = pct >= 70
        ? ['Excellent eye contact! Keep it natural.', 'Your gaze is well-centered on the interviewer.']
        : pct >= 40
            ? ['Try to maintain eye contact for 4-5 seconds at a time.', 'Look at the forehead triangle (eyes + nose) for natural contact.']
            : ['Practice looking at the camera/interviewer more consistently.', 'Avoid looking down at your notes too often.', 'Use the 50/70 rule: eye contact 50% when speaking, 70% when listening.'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡 Tips', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          ...tips.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: AppColors.primary)),
                    Expanded(child: Text(t, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600], height: 1.4))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

/// Heatmap painter using REAL face detection snapshots
class _HeatmapPainter extends CustomPainter {
  final List<ConfidenceSnapshot> snapshots;
  final double progress;
  final bool isDark;

  _HeatmapPainter({required this.snapshots, required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw face outline
    final facePaint = Paint()
      ..color = (isDark ? Colors.white : Colors.grey[800]!).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.45), width: size.width * 0.5, height: size.height * 0.6),
      facePaint,
    );
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * 0.38, size.height * 0.38), width: 30, height: 16), facePaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * 0.62, size.height * 0.38), width: 30, height: 16), facePaint);

    // Map real gaze data to heatmap positions
    final visibleCount = (snapshots.length * progress).toInt();
    final rng = math.Random(42);

    for (int i = 0; i < visibleCount; i++) {
      final s = snapshots[i];

      // Use head rotation to approximate gaze direction
      // headRotationY: left/right (-30 to 30), headRotationZ: tilt
      final normalizedX = 0.5 + (s.headRotationY / 60).clamp(-0.5, 0.5);
      final normalizedY = 0.4 + (s.headRotationZ / 60).clamp(-0.3, 0.3);

      // Add slight jitter for natural distribution
      final x = (normalizedX + (rng.nextDouble() - 0.5) * 0.05) * size.width;
      final y = (normalizedY + (rng.nextDouble() - 0.5) * 0.04) * size.height;

      final intensity = s.eyeContactScore / 100;
      final color = Color.lerp(
        Colors.blue.withValues(alpha: 0.15),
        Colors.red.withValues(alpha: 0.5),
        intensity,
      )!;

      canvas.drawCircle(
        Offset(x.clamp(0, size.width), y.clamp(0, size.height)),
        8 + intensity * 14,
        Paint()
          ..color = color
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter old) => old.progress != progress;
}
