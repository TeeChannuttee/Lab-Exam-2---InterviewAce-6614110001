import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:async';
import 'dart:ui' show Size;

/// Service for real-time face detection and confidence analysis
/// Tracks: smile probability, eye openness, head position → confidence score
class FaceDetectionService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true, // smile, eyes open
      enableTracking: true,
      enableLandmarks: true,
      enableContours: false,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  final _confidenceStreamController = StreamController<ConfidenceSnapshot>.broadcast();

  /// Stream of real-time confidence snapshots
  Stream<ConfidenceSnapshot> get confidenceStream => _confidenceStreamController.stream;

  /// Accumulated snapshots for session analysis
  final List<ConfidenceSnapshot> _sessionSnapshots = [];
  List<ConfidenceSnapshot> get sessionSnapshots => List.unmodifiable(_sessionSnapshots);

  /// Process a camera image for face detection
  Future<ConfidenceSnapshot?> processImage(InputImage inputImage) async {
    final faces = await _faceDetector.processImage(inputImage);
    if (faces.isEmpty) {
      final snapshot = ConfidenceSnapshot(
        timestamp: DateTime.now(),
        faceDetected: false,
      );
      _confidenceStreamController.add(snapshot);
      _sessionSnapshots.add(snapshot);
      return snapshot;
    }

    final face = faces.first;

    // Calculate confidence metrics
    final smileProb = face.smilingProbability ?? 0;
    final leftEyeOpenProb = face.leftEyeOpenProbability ?? 0;
    final rightEyeOpenProb = face.rightEyeOpenProbability ?? 0;
    final headEulerY = face.headEulerAngleY ?? 0; // left/right
    final headEulerZ = face.headEulerAngleZ ?? 0; // tilt

    // Compute composite confidence score (0-100)
    final eyeContact = ((leftEyeOpenProb + rightEyeOpenProb) / 2) * 100;
    final smileScore = smileProb * 100;
    final posture = _calculatePostureScore(headEulerY, headEulerZ);

    // Weighted confidence: eye contact 40%, smile 25%, posture 35%
    final overallConfidence = (eyeContact * 0.4) + (smileScore * 0.25) + (posture * 0.35);

    final snapshot = ConfidenceSnapshot(
      timestamp: DateTime.now(),
      faceDetected: true,
      smileProbability: smileProb,
      leftEyeOpen: leftEyeOpenProb,
      rightEyeOpen: rightEyeOpenProb,
      headRotationY: headEulerY,
      headRotationZ: headEulerZ,
      eyeContactScore: eyeContact,
      smileScore: smileScore,
      postureScore: posture,
      overallConfidence: overallConfidence,
    );

    _confidenceStreamController.add(snapshot);
    _sessionSnapshots.add(snapshot);
    return snapshot;
  }

  /// Calculate posture score from head rotation
  /// Perfect = facing forward (0,0), score decreases with rotation
  double _calculatePostureScore(double eulerY, double eulerZ) {
    final yDeviation = eulerY.abs();
    final zDeviation = eulerZ.abs();

    // Max acceptable rotation: 30 degrees
    final yScore = ((30 - yDeviation.clamp(0, 30)) / 30) * 100;
    final zScore = ((30 - zDeviation.clamp(0, 30)) / 30) * 100;

    return (yScore + zScore) / 2;
  }

  /// Get session summary after interview
  ConfidenceSessionSummary getSessionSummary() {
    if (_sessionSnapshots.isEmpty) {
      return ConfidenceSessionSummary.empty();
    }

    final validSnapshots = _sessionSnapshots.where((s) => s.faceDetected).toList();
    if (validSnapshots.isEmpty) {
      return ConfidenceSessionSummary.empty();
    }

    final avgConfidence =
        validSnapshots.map((s) => s.overallConfidence).reduce((a, b) => a + b) /
            validSnapshots.length;
    final avgSmile =
        validSnapshots.map((s) => s.smileScore).reduce((a, b) => a + b) /
            validSnapshots.length;
    final avgEyeContact =
        validSnapshots.map((s) => s.eyeContactScore).reduce((a, b) => a + b) /
            validSnapshots.length;
    final avgPosture =
        validSnapshots.map((s) => s.postureScore).reduce((a, b) => a + b) /
            validSnapshots.length;

    final peakConfidence =
        validSnapshots.map((s) => s.overallConfidence).reduce((a, b) => a > b ? a : b);
    final lowestConfidence =
        validSnapshots.map((s) => s.overallConfidence).reduce((a, b) => a < b ? a : b);

    // Calculate face detection rate
    final detectionRate = validSnapshots.length / _sessionSnapshots.length * 100;

    return ConfidenceSessionSummary(
      averageConfidence: avgConfidence,
      averageSmile: avgSmile,
      averageEyeContact: avgEyeContact,
      averagePosture: avgPosture,
      peakConfidence: peakConfidence,
      lowestConfidence: lowestConfidence,
      faceDetectionRate: detectionRate,
      totalSnapshots: _sessionSnapshots.length,
      validSnapshots: validSnapshots.length,
    );
  }

  /// Reset session data
  void resetSession() {
    _sessionSnapshots.clear();
  }

  /// Convert CameraImage to InputImage for ML Kit
  static InputImage? cameraImageToInputImage(
    CameraImage image,
    CameraDescription camera,
    int sensorOrientation,
  ) {
    final rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw as int);
    if (format == null) return null;

    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  /// Dispose resources
  void dispose() {
    _faceDetector.close();
    _confidenceStreamController.close();
  }
}

/// Single confidence measurement snapshot
class ConfidenceSnapshot {
  final DateTime timestamp;
  final bool faceDetected;
  final double smileProbability;
  final double leftEyeOpen;
  final double rightEyeOpen;
  final double headRotationY;
  final double headRotationZ;
  final double eyeContactScore;
  final double smileScore;
  final double postureScore;
  final double overallConfidence;

  ConfidenceSnapshot({
    required this.timestamp,
    required this.faceDetected,
    this.smileProbability = 0,
    this.leftEyeOpen = 0,
    this.rightEyeOpen = 0,
    this.headRotationY = 0,
    this.headRotationZ = 0,
    this.eyeContactScore = 0,
    this.smileScore = 0,
    this.postureScore = 0,
    this.overallConfidence = 0,
  });
}

/// Summary of confidence metrics for a full session
class ConfidenceSessionSummary {
  final double averageConfidence;
  final double averageSmile;
  final double averageEyeContact;
  final double averagePosture;
  final double peakConfidence;
  final double lowestConfidence;
  final double faceDetectionRate;
  final int totalSnapshots;
  final int validSnapshots;

  ConfidenceSessionSummary({
    required this.averageConfidence,
    required this.averageSmile,
    required this.averageEyeContact,
    required this.averagePosture,
    required this.peakConfidence,
    required this.lowestConfidence,
    required this.faceDetectionRate,
    required this.totalSnapshots,
    required this.validSnapshots,
  });

  factory ConfidenceSessionSummary.empty() {
    return ConfidenceSessionSummary(
      averageConfidence: 0,
      averageSmile: 0,
      averageEyeContact: 0,
      averagePosture: 0,
      peakConfidence: 0,
      lowestConfidence: 0,
      faceDetectionRate: 0,
      totalSnapshots: 0,
      validSnapshots: 0,
    );
  }

  String get confidenceGrade {
    if (averageConfidence >= 80) return 'A';
    if (averageConfidence >= 60) return 'B';
    if (averageConfidence >= 40) return 'C';
    return 'D';
  }

  List<String> get tips {
    final tips = <String>[];
    if (averageEyeContact < 60) tips.add('Try to maintain more eye contact with the camera');
    if (averageSmile < 30) tips.add('A natural smile shows confidence and friendliness');
    if (averagePosture < 60) tips.add('Keep your head straight facing the camera');
    if (faceDetectionRate < 80) tips.add('Stay within the camera frame during the interview');
    if (tips.isEmpty) tips.add('Great job! Your confidence level is excellent!');
    return tips;
  }
}
