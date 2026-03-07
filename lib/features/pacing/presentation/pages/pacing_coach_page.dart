import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'dart:async';

/// Answer Pacing Coach — real-time timer showing ideal answer length
@RoutePage()
class PacingCoachPage extends StatefulWidget {
  const PacingCoachPage({super.key});

  @override
  State<PacingCoachPage> createState() => _PacingCoachPageState();
}

class _PacingCoachPageState extends State<PacingCoachPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  final List<int> _laps = [];

  static const int _minIdeal = 60;
  static const int _maxIdeal = 120;
  static const int _tooLong = 180;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isRunning) {
      _timer?.cancel();
      _laps.add(_seconds);
      setState(() { _isRunning = false; });
    } else {
      _seconds = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _seconds++);
      });
      setState(() { _isRunning = true; });
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _seconds = 0;
      _laps.clear();
    });
  }

  Color get _zoneColor {
    if (_seconds < _minIdeal) return AppColors.primary;
    if (_seconds <= _maxIdeal) return AppColors.success;
    if (_seconds <= _tooLong) return AppColors.warning;
    return AppColors.error;
  }

  String get _zoneLabel {
    if (!_isRunning && _seconds == 0) return context.tr.ready;
    if (_seconds < _minIdeal) return context.tr.buildingUp;
    if (_seconds <= _maxIdeal) return context.tr.goldenZoneLabel;
    if (_seconds <= _tooLong) return context.tr.wrappingUp;
    return context.tr.tooLong;
  }

  String _formatTime(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = (_seconds / _tooLong).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.pacingCoach), centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Timer Circle
            AnimatedBuilder(
              animation: _pulseController,
              builder: (ctx, _) {
                final scale = _isRunning ? 0.97 + _pulseController.value * 0.06 : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _zoneColor.withValues(alpha: 0.15),
                          _zoneColor.withValues(alpha: 0.02),
                        ],
                      ),
                      border: Border.all(color: _zoneColor.withValues(alpha: 0.3), width: 3),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_formatTime(_seconds), style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: _zoneColor, fontFeatures: const [FontFeature.tabularFigures()])),
                          const SizedBox(height: 4),
                          Text(_zoneLabel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _zoneColor)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Progress Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0s', style: TextStyle(fontSize: 10, color: isDark ? Colors.white24 : Colors.grey[400])),
                      Text('60s', style: TextStyle(fontSize: 10, color: AppColors.success.withValues(alpha: 0.6))),
                      Text('120s', style: TextStyle(fontSize: 10, color: AppColors.success.withValues(alpha: 0.6))),
                      Text('180s', style: TextStyle(fontSize: 10, color: isDark ? Colors.white24 : Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    children: [
                      // Background zones
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          children: [
                            Expanded(flex: _minIdeal, child: Container(height: 10, color: AppColors.primary.withValues(alpha: 0.2))),
                            Expanded(flex: _maxIdeal - _minIdeal, child: Container(height: 10, color: AppColors.success.withValues(alpha: 0.3))),
                            Expanded(flex: _tooLong - _maxIdeal, child: Container(height: 10, color: AppColors.warning.withValues(alpha: 0.2))),
                          ],
                        ),
                      ),
                      // Actual progress
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 10,
                          width: MediaQuery.of(context).size.width * 0.85 * progress,
                          decoration: BoxDecoration(
                            color: _zoneColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 4),
                      Text(context.tr.goldenZone, style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.grey[500])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggle,
                    icon: Icon(_isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded),
                    label: Text(_isRunning ? context.tr.stopSave : context.tr.startAnswer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning ? AppColors.error : AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                if (_laps.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Lap History
            if (_laps.isNotEmpty) ...[
              Text(context.tr.answerTimes, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 10),
              ...List.generate(_laps.length, (i) {
                final lap = _laps[i];
                final color = lap >= _minIdeal && lap <= _maxIdeal ? AppColors.success : lap > _tooLong ? AppColors.error : AppColors.warning;
                final label = lap >= _minIdeal && lap <= _maxIdeal ? context.tr.perfect : lap > _tooLong ? context.tr.tooLongLabel : lap < _minIdeal ? context.tr.tooShort : '';
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.1 : 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Text('${context.tr.answerLabel} ${i + 1}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const Spacer(),
                      Text(_formatTime(lap), style: TextStyle(fontWeight: FontWeight.w700, color: color, fontFeatures: const [FontFeature.tabularFigures()])),
                      const SizedBox(width: 8),
                      Text(label, style: TextStyle(fontSize: 11, color: color)),
                    ],
                  ),
                );
              }),
            ],

            // Tips
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.blue[50],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr.pacingTips, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  ...[context.tr.pacingTip1,
                      context.tr.pacingTip2,
                      context.tr.pacingTip3,
                      context.tr.pacingTip4,
                  ].map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400])),
                        Expanded(child: Text(t, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600], height: 1.4))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
