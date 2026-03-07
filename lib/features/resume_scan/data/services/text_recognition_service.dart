import 'dart:io';
import 'dart:ui' show Rect;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

/// Service for recognizing text from images using Google ML Kit
/// Used for: Resume scanning, handwriting recognition during interviews
class TextRecognitionService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick image using file browser (Files app) - works on Simulator
  /// Uses FileType.custom to force UIDocumentPicker instead of PHPicker
  Future<TextRecognitionResult?> recognizeFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'heic', 'webp', 'bmp', 'gif'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty || result.files.single.path == null) {
      return null;
    }
    return await _processImage(File(result.files.single.path!));
  }

  /// Pick image from Photos gallery (image_picker) - works on real iPhone
  Future<TextRecognitionResult?> recognizeFromPhotos() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 90,
    );
    if (pickedFile == null) return null;
    return await _processImage(File(pickedFile.path));
  }

  /// Capture image from camera and recognize text
  Future<TextRecognitionResult?> recognizeFromCamera() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 90,
    );
    if (pickedFile == null) return null;
    return await _processImage(File(pickedFile.path));
  }

  /// Process a file directly (from custom photo picker)
  Future<TextRecognitionResult?> recognizeFromFile(File file) async {
    return await _processImage(file);
  }

  /// Process an image file for text recognition
  Future<TextRecognitionResult> _processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    // Extract structured data
    final blocks = <TextBlockData>[];
    for (final block in recognizedText.blocks) {
      final lines = <TextLineData>[];
      for (final line in block.lines) {
        lines.add(TextLineData(
          text: line.text,
          boundingBox: line.boundingBox,
        ));
      }
      blocks.add(TextBlockData(
        text: block.text,
        boundingBox: block.boundingBox,
        lines: lines,
      ));
    }

    return TextRecognitionResult(
      fullText: recognizedText.text,
      blocks: blocks,
      imagePath: imageFile.path,
    );
  }

  /// Recognize text from a specific file path
  Future<TextRecognitionResult> recognizeFromPath(String path) async {
    return await _processImage(File(path));
  }

  /// Dispose resources
  void dispose() {
    _textRecognizer.close();
  }
}

/// Result of text recognition
class TextRecognitionResult {
  final String fullText;
  final List<TextBlockData> blocks;
  final String imagePath;

  TextRecognitionResult({
    required this.fullText,
    required this.blocks,
    required this.imagePath,
  });

  bool get isEmpty => fullText.trim().isEmpty;
  int get wordCount => fullText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  int get lineCount => blocks.fold(0, (sum, b) => sum + b.lines.length);
}

/// Individual text block data
class TextBlockData {
  final String text;
  final Rect? boundingBox;
  final List<TextLineData> lines;

  TextBlockData({
    required this.text,
    this.boundingBox,
    required this.lines,
  });
}

/// Individual text line data
class TextLineData {
  final String text;
  final Rect? boundingBox;

  TextLineData({
    required this.text,
    this.boundingBox,
  });
}
