// =============================================================
// Unit Test: DataExportService
// ทดสอบระบบ Export ข้อมูลสัมภาษณ์เป็น CSV, JSON, Summary Report
//
// ทำไมต้องรัน?
// - ตรวจสอบว่า Export CSV มี header ถูกต้อง + ข้อมูลครบ
// - ตรวจสอบว่า Export JSON มีโครงสร้างถูกต้อง + format สวย
// - ตรวจสอบว่า Summary Report มีข้อมูลภาพรวมครบ
// - ตรวจสอบว่าระบบรองรับกรณีไม่มี session (empty list)
// - ตรวจสอบว่าคำนวณคะแนนเฉลี่ยถูกต้อง (85+72)/2 = 78%
// =============================================================
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_ace/features/analytics/data/services/data_export_service.dart';
import 'package:interview_ace/features/interview/domain/entities/interview_entities.dart';

void main() {
  late DataExportService exportService;

  setUp(() {
    exportService = DataExportService();
  });

  final tSessions = [
    InterviewSession(
      id: 'session-1',
      position: 'Flutter Developer',
      company: 'Google',
      level: 'Senior',
      questionType: 'Technical',
      language: 'en',
      questionCount: 5,
      totalScore: 85,
      createdAt: DateTime(2024, 1, 15),
    ),
    InterviewSession(
      id: 'session-2',
      position: 'iOS Developer',
      company: 'Apple',
      level: 'Mid-level',
      questionType: 'Behavioral',
      language: 'en',
      questionCount: 3,
      totalScore: 72,
      createdAt: DateTime(2024, 1, 20),
    ),
  ];

  group('DataExportService - CSV', () {
    test('exports valid CSV with header', () {
      final csv = exportService.exportToCSV(tSessions);

      expect(csv, contains('Session ID,Position,Company,Level'));
      expect(csv.split('\n').length, greaterThanOrEqualTo(3)); // header + 2 rows
    });

    test('CSV contains session data', () {
      final csv = exportService.exportToCSV(tSessions);

      expect(csv, contains('session-1'));
      expect(csv, contains('"Flutter Developer"'));
      expect(csv, contains('"Google"'));
      expect(csv, contains('85'));
    });

    test('handles empty sessions list', () {
      final csv = exportService.exportToCSV([]);

      expect(csv, contains('Session ID')); // header still present
      expect(csv.split('\n').length, 2); // header + empty line
    });
  });

  group('DataExportService - JSON', () {
    test('exports valid JSON', () {
      final json = exportService.exportToJSON(tSessions);

      expect(json, contains('"exportDate"'));
      expect(json, contains('"totalSessions": 2'));
      expect(json, contains('"sessions"'));
    });

    test('JSON contains session data', () {
      final json = exportService.exportToJSON(tSessions);

      expect(json, contains('"Flutter Developer"'));
      expect(json, contains('"Google"'));
      expect(json, contains('"score": 85'));
    });

    test('JSON is properly formatted with indentation', () {
      final json = exportService.exportToJSON(tSessions);

      expect(json, contains('  '));
    });
  });

  group('DataExportService - Summary Report', () {
    test('generates report with overview', () {
      final report = exportService.generateSummaryReport(tSessions);

      expect(report, contains('InterviewAce Progress Report'));
      expect(report, contains('Total Sessions: 2'));
      expect(report, contains('Average Score:'));
    });

    test('report contains recent sessions', () {
      final report = exportService.generateSummaryReport(tSessions);

      expect(report, contains('Flutter Developer'));
      expect(report, contains('Google'));
    });

    test('handles empty sessions', () {
      final report = exportService.generateSummaryReport([]);

      expect(report, 'No sessions to report.');
    });

    test('calculates average score correctly', () {
      final report = exportService.generateSummaryReport(tSessions);

      // (85 + 72) / 2 = 78.5, truncated to 78
      expect(report, contains('Average Score: 78%'));
    });
  });
}
