import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/features/confidence/data/services/face_detection_service.dart';
import 'dart:async';
import 'dart:math' as math;

@RoutePage()
class ConfidencePage extends StatefulWidget {
  const ConfidencePage({super.key});

  @override
  State<ConfidencePage> createState() => _ConfidencePageState();
}

class _ConfidencePageState extends State<ConfidencePage>
    with TickerProviderStateMixin {
  late final FaceDetectionService _faceDetectionService;
  late final AnimationController _pulseController;
  late final AnimationController _slideController;

  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  StreamSubscription<ConfidenceSnapshot>? _confidenceSubscription;
  ConfidenceSnapshot? _latestSnapshot;
  ConfidenceSessionSummary? _sessionSummary;
  bool _isTracking = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _faceDetectionService = FaceDetectionService();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _confidenceSubscription?.cancel();
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _faceDetectionService.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _startTracking() async {
    // Init camera
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          final isTh = context.tr.locale == 'th';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isTh ? 'ไม่พบกล้อง (Simulator ไม่รองรับ)' : 'No camera found (Simulator not supported)')),
          );
        }
        return;
      }

      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        front,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
        _isTracking = true;
        _sessionSummary = null;
      });

      _faceDetectionService.resetSession();

      // Listen to confidence snapshots
      _confidenceSubscription = _faceDetectionService.confidenceStream.listen(
        (snapshot) {
          if (mounted) setState(() => _latestSnapshot = snapshot);
        },
      );

      // Start image stream for face detection
      final sensorOrientation = front.sensorOrientation;
      _cameraController!.startImageStream((CameraImage image) {
        if (_isProcessing) return;
        _isProcessing = true;

        final inputImage = FaceDetectionService.cameraImageToInputImage(
          image, front, sensorOrientation,
        );

        if (inputImage != null) {
          _faceDetectionService.processImage(inputImage).then((_) {
            _isProcessing = false;
          }).catchError((_) {
            _isProcessing = false;
          });
        } else {
          _isProcessing = false;
        }
      });
    } catch (e) {
      debugPrint('Camera init error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e')),
        );
      }
    }
  }

  void _stopTracking() {
    _confidenceSubscription?.cancel();
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _cameraController = null;

    setState(() {
      _sessionSummary = _faceDetectionService.getSessionSummary();
      _isTracking = false;
      _isCameraInitialized = false;
    });
  }

  void _toggleTracking() {
    if (_isTracking) {
      _stopTracking();
    } else {
      _startTracking();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tr = context.tr;
    final isThLang = tr.locale == 'th';

    return Scaffold(
      appBar: AppBar(title: Text(tr.confidenceAnalysis), centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          _buildHeroSection(isDark, isThLang),
          const SizedBox(height: 24),
          if (!_isTracking && _sessionSummary == null) _buildFeatureCards(isDark, isThLang),
          if (_isTracking) _buildLiveTracking(isDark, isThLang),
          if (_sessionSummary != null && !_isTracking) _buildSessionSummary(isDark, isThLang),
          const SizedBox(height: 16),
          _buildTrackingButton(isDark, isThLang),
          const SizedBox(height: 24),
          _buildTips(isDark, isThLang),
        ]),
      ),
    );
  }

  Widget _buildHeroSection(bool isDark, bool isTh) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic)),
      child: FadeTransition(
        opacity: _slideController,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppColors.success.withValues(alpha: 0.15), AppColors.primary.withValues(alpha: 0.08)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
          ),
          child: Column(children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) => Transform.scale(scale: 0.9 + (_pulseController.value * 0.2), child: child),
              child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.success, AppColors.primary]),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.success.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: const Icon(Icons.face_retouching_natural, color: Colors.white, size: 36),
              ),
            ),
            const SizedBox(height: 16),
            Text(isTh ? 'โค้ชความมั่นใจ' : 'Confidence Coach',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
              isTh ? 'AI ติดตามสีหน้าขณะฝึกสัมภาษณ์\nและให้ feedback ความมั่นใจแบบ real-time'
                  : 'AI tracks your facial expressions during practice\nand gives real-time confidence feedback',
              style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600], fontSize: 14, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildFeatureCards(bool isDark, bool isTh) {
    final features = [
      _FeatureItem(Icons.visibility, isTh ? 'สบตา' : 'Eye Contact', isTh ? 'ตรวจจับการมองกล้อง' : 'Tracks where you look', AppColors.primary),
      _FeatureItem(Icons.sentiment_satisfied_alt, isTh ? 'รอยยิ้ม' : 'Smile Detection', isTh ? 'ความเป็นมิตรตามธรรมชาติ' : 'Natural friendliness', AppColors.success),
      _FeatureItem(Icons.straighten, isTh ? 'ท่าทาง' : 'Posture', isTh ? 'ตำแหน่งศีรษะและความนิ่ง' : 'Head position & stability', AppColors.accent),
      _FeatureItem(Icons.insights, isTh ? 'คะแนนและคำแนะนำ' : 'Score & Tips', isTh ? 'ได้เกรด A-D พร้อมคำแนะนำ' : 'Get Grade A-D with tips', AppColors.warning),
    ];

    return Column(
      children: features.asMap().entries.map((entry) {
        final i = entry.key;
        final f = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(
              parent: _slideController,
              curve: Interval((i * 0.1) + 0.2, ((i * 0.1) + 0.6).clamp(0, 1), curve: Curves.easeOutCubic),
            )),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
              ),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: f.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: Icon(f.icon, color: f.color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(f.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(f.subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
                ])),
                Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white24 : Colors.grey[300]),
              ]),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLiveTracking(bool isDark, bool isTh) {
    final snapshot = _latestSnapshot;
    final confidence = snapshot?.overallConfidence ?? 0;
    final faceDetected = snapshot?.faceDetected ?? false;

    final color = confidence >= 70 ? AppColors.success : confidence >= 40 ? AppColors.warning : AppColors.error;

    return Column(children: [
      // Camera preview
      if (_isCameraInitialized && _cameraController != null)
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: CameraPreview(_cameraController!),
          ),
        ),
      const SizedBox(height: 16),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(isTh ? 'กำลังติดตาม' : 'LIVE TRACKING',
                style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 1)),
          ]),
          const SizedBox(height: 20),

          // Confidence gauge
          SizedBox(
            width: 140, height: 140,
            child: CustomPaint(
              painter: _ConfidenceGaugePainter(value: confidence / 100, color: color, bgColor: isDark ? Colors.white12 : Colors.grey[200]!),
              child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(faceDetected ? '${confidence.toInt()}' : '?',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: color)),
                Text(faceDetected ? (isTh ? 'ความมั่นใจ' : 'confidence') : (isTh ? 'ไม่พบใบหน้า' : 'no face'),
                    style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
              ])),
            ),
          ),
          const SizedBox(height: 20),

          if (faceDetected) ...[
            Row(children: [
              _LiveMetric(Icons.visibility, isTh ? 'สบตา' : 'Eye Contact', '${snapshot!.eyeContactScore.toInt()}%', isDark),
              _LiveMetric(Icons.sentiment_satisfied_alt, isTh ? 'ยิ้ม' : 'Smile', '${snapshot.smileScore.toInt()}%', isDark),
              _LiveMetric(Icons.straighten, isTh ? 'ท่าทาง' : 'Posture', '${snapshot.postureScore.toInt()}%', isDark),
            ]),
          ] else
            Text(isTh ? 'ส่องหน้าให้อยู่ในกล้อง' : 'Position your face in front of the camera',
                style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500])),
        ]),
      ),
    ]);
  }

  Widget _buildSessionSummary(bool isDark, bool isTh) {
    final summary = _sessionSummary!;
    final grade = summary.confidenceGrade;
    final gradeColor = grade == 'A' ? AppColors.success : grade == 'B' ? AppColors.primary : grade == 'C' ? AppColors.warning : AppColors.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [gradeColor.withValues(alpha: 0.12), gradeColor.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gradeColor.withValues(alpha: 0.2)),
      ),
      child: Column(children: [
        Text(context.tr.interviewResult,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: gradeColor.withValues(alpha: 0.15), shape: BoxShape.circle, border: Border.all(color: gradeColor, width: 3)),
          child: Center(child: Text(grade, style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: gradeColor))),
        ),
        const SizedBox(height: 16),
        Text('${isTh ? 'คะแนนรวม' : 'Overall'}: ${summary.averageConfidence.toInt()}%',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 16),
        Row(children: [
          _SummaryMetric(isTh ? 'สบตา' : 'Eye Contact', '${summary.averageEyeContact.toInt()}%', isDark),
          _SummaryMetric(isTh ? 'ยิ้ม' : 'Smile', '${summary.averageSmile.toInt()}%', isDark),
          _SummaryMetric(isTh ? 'ท่าทาง' : 'Posture', '${summary.averagePosture.toInt()}%', isDark),
        ]),
        const SizedBox(height: 16),
        ...summary.tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.lightbulb_outline, size: 16, color: AppColors.warning),
                const SizedBox(width: 8),
                Expanded(child: Text(tip, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[700], fontSize: 13))),
              ]),
            )),
      ]),
    );
  }

  Widget _buildTrackingButton(bool isDark, bool isTh) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _toggleTracking,
        icon: Icon(_isTracking ? Icons.stop_rounded : Icons.play_arrow_rounded),
        label: Text(
          _isTracking ? (isTh ? 'หยุดติดตาม' : 'Stop Tracking') : (isTh ? 'เริ่มวิเคราะห์ความมั่นใจ' : 'Start Confidence Tracking'),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isTracking ? AppColors.error : AppColors.success,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildTips(bool isDark, bool isTh) {
    final tips = isTh
        ? ['มองกล้องเหมือนกำลังมองผู้สัมภาษณ์', 'ยิ้มเป็นธรรมชาติแสดงความมั่นใจ', 'ให้หน้าอยู่ตรงกลางและนิ่ง', 'ฝึกในห้องที่มีแสงสว่างเพียงพอ']
        : ['Maintain eye contact with the camera as if it were the interviewer', 'A natural smile shows confidence and approachability', 'Keep your face centered and your head steady', 'Practice in a well-lit room for best results'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.blue[50],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(isTh ? 'เคล็ดลับ' : 'Pro Tips', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ]),
        const SizedBox(height: 8),
        ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('• ', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400])),
                Expanded(child: Text(tip, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600], height: 1.4))),
              ]),
            )),
      ]),
    );
  }
}

// ─────────── HELPER WIDGETS ───────────

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  _FeatureItem(this.icon, this.title, this.subtitle, this.color);
}

class _LiveMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _LiveMetric(this.icon, this.label, this.value, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
      ]),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _SummaryMetric(this.label, this.value, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
      ]),
    );
  }
}

// Custom gauge painter
class _ConfidenceGaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final Color bgColor;

  _ConfidenceGaugePainter({required this.value, required this.color, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75, math.pi * 1.5, false,
      Paint()..color = bgColor..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75, math.pi * 1.5 * value.clamp(0, 1), false,
      Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ConfidenceGaugePainter old) => old.value != value || old.color != color;
}
