import 'package:hive_flutter/hive_flutter.dart';

/// Notification preferences & scheduling service
/// Uses Hive for persistence of notification settings
class NotificationService {
  static const _boxName = 'notifications';
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  bool get isEnabled => _box.get('enabled', defaultValue: true);

  Future<void> setEnabled(bool value) async {
    await _box.put('enabled', value);
  }

  String get reminderTime => _box.get('reminderTime', defaultValue: '09:00');

  Future<void> setReminderTime(String time) async {
    await _box.put('reminderTime', time);
  }

  String get reminderMessage {
    final messages = [
      '🔥 Don\'t break your streak! Practice today.',
      '🎯 Your interview skills are waiting to level up!',
      '💪 Champions practice daily. Are you ready?',
      '📈 One session a day keeps rejection away!',
      '🏆 You\'re one practice away from leveling up!',
    ];
    final dayIndex = DateTime.now().day % messages.length;
    return messages[dayIndex];
  }

  /// Schedule daily reminder (stub — requires flutter_local_notifications in production)
  Future<void> scheduleDailyReminder() async {
    if (!isEnabled) return;
    // In production, integrate with flutter_local_notifications:
    // final notification = FlutterLocalNotificationsPlugin();
    // await notification.zonedSchedule(...);
    // For now, the UI and logic are ready.
  }

  Future<void> cancelReminder() async {
    // Cancel scheduled notifications
  }
}
