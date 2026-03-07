import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/gamification/data/services/gamification_service.dart';

/// Learning Path — REAL progress from gamification data (Hive)
@RoutePage()
class LearningPathPage extends StatefulWidget {
  const LearningPathPage({super.key});

  @override
  State<LearningPathPage> createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage> {
  static const _boxName = 'learning_progress';
  late Box _box;
  bool _initialized = false;
  late final GamificationService _gamification;

  @override
  void initState() {
    super.initState();
    _gamification = sl<GamificationService>();
    _initBox();
  }

  Future<void> _initBox() async {
    _box = await Hive.openBox(_boxName);
    if (mounted) setState(() => _initialized = true);
  }

  bool _isMissionDone(String id) => _box.get(id, defaultValue: false);

  Future<void> _toggleMission(String id) async {
    await _box.put(id, !_isMissionDone(id));
    setState(() {});
  }

  List<_Track> get _tracks {
    final level = _gamification.level;
    final sessions = _gamification.totalSessions;
    final streak = _gamification.currentStreak;
    final tr = context.tr;

    return [
      _Track(
        level: 1,
        title: tr.lpFoundation,
        emoji: '🌱',
        color: Colors.green,
        unlocked: true,
        missions: [
          _Mission('f1', tr.lpM_f1, autoComplete: sessions >= 1),
          _Mission('f2', tr.lpM_f2, autoComplete: false),
          _Mission('f3', tr.lpM_f3, autoComplete: false),
          _Mission('f4', tr.lpM_f4, autoComplete: sessions >= 1),
        ],
      ),
      _Track(
        level: 2,
        title: tr.lpBuildingSkills,
        emoji: '📚',
        color: Colors.blue,
        unlocked: level >= 2,
        missions: [
          _Mission('b1', tr.lpM_b1, autoComplete: sessions >= 3),
          _Mission('b2', tr.lpM_b2, autoComplete: false),
          _Mission('b3', tr.lpM_b3, autoComplete: streak >= 3),
          _Mission('b4', tr.lpM_b4, autoComplete: false),
        ],
      ),
      _Track(
        level: 3,
        title: tr.lpIntermediate,
        emoji: '💪',
        color: Colors.orange,
        unlocked: level >= 3,
        missions: [
          _Mission('i1', tr.lpM_i1, autoComplete: sessions >= 5),
          _Mission('i2', tr.lpM_i2, autoComplete: false),
          _Mission('i3', tr.lpM_i3, autoComplete: false),
          _Mission('i4', tr.lpM_i4, autoComplete: level >= 3),
          _Mission('i5', tr.lpM_i5, autoComplete: streak >= 7),
        ],
      ),
      _Track(
        level: 4,
        title: tr.lpAdvanced,
        emoji: '🔥',
        color: Colors.deepOrange,
        unlocked: level >= 5,
        missions: [
          _Mission('a1', tr.lpM_a1, autoComplete: sessions >= 10),
          _Mission('a2', tr.lpM_a2, autoComplete: false),
          _Mission('a3', tr.lpM_a3, autoComplete: false),
          _Mission('a4', tr.lpM_a4, autoComplete: level >= 5),
          _Mission('a5', tr.lpM_a5, autoComplete: false),
        ],
      ),
      _Track(
        level: 5,
        title: tr.lpMaster,
        emoji: '👑',
        color: Colors.purple,
        unlocked: level >= 7,
        missions: [
          _Mission('m1', tr.lpM_m1, autoComplete: sessions >= 25),
          _Mission('m2', tr.lpM_m2, autoComplete: level >= 7),
          _Mission('m3', tr.lpM_m3, autoComplete: streak >= 30),
          _Mission('m4', tr.lpM_m4, autoComplete: false),
          _Mission('m5', tr.lpM_m5, autoComplete: false),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_initialized) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr.learningPath), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final tracks = _tracks;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.learningPath), centerTitle: true),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // Real data badge
          Center(
            child: Container(
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
                  Text(context.tr.lpProgress(_gamification.level, _gamification.totalSessions),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          ...tracks.asMap().entries.map((entry) {
            final idx = entry.key;
            final track = entry.value;
            return _buildTrack(track, idx, isDark);
          }),
        ],
      ),
    );
  }

  Widget _buildTrack(_Track track, int index, bool isDark) {
    int completedCount = 0;
    for (final m in track.missions) {
      if (m.autoComplete || _isMissionDone(m.id)) completedCount++;
    }
    final progress = track.missions.isNotEmpty ? completedCount / track.missions.length : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: track.unlocked ? 1.0 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
          ),
          child: ExpansionTile(
            initiallyExpanded: index == 0,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            leading: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [track.color.withValues(alpha: 0.2), track.color.withValues(alpha: 0.05)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(track.emoji, style: const TextStyle(fontSize: 20))),
            ),
            title: Row(
              children: [
                Text(track.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(width: 8),
                if (!track.unlocked)
                  Icon(Icons.lock_rounded, size: 14, color: isDark ? Colors.white24 : Colors.grey[400]),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress, minHeight: 5,
                          backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(track.color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$completedCount/${track.missions.length}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: track.color)),
                  ],
                ),
              ],
            ),
            children: track.missions.map((m) {
              final done = m.autoComplete || _isMissionDone(m.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: GestureDetector(
                  onTap: track.unlocked && !m.autoComplete ? () => _toggleMission(m.id) : null,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          color: done ? track.color : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: done ? track.color : (isDark ? Colors.white24 : Colors.grey[300]!), width: 2),
                        ),
                        child: done ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(m.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: done
                                  ? (isDark ? Colors.white38 : Colors.grey[400])
                                  : (isDark ? Colors.white70 : Colors.grey[700]),
                              decoration: done ? TextDecoration.lineThrough : null,
                            )),
                      ),
                      if (m.autoComplete)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('AUTO', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.success)),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _Track {
  final int level;
  final String title;
  final String emoji;
  final Color color;
  final bool unlocked;
  final List<_Mission> missions;
  const _Track({required this.level, required this.title, required this.emoji, required this.color, required this.unlocked, required this.missions});
}

class _Mission {
  final String id;
  final String label;
  final bool autoComplete;
  const _Mission(this.id, this.label, {this.autoComplete = false});
}
