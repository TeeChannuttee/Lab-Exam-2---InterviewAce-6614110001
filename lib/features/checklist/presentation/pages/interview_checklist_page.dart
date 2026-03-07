import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview_ace/core/constants/app_colors.dart';

/// Interview Checklist — PERSISTED in Hive (real offline storage)
@RoutePage()
class InterviewChecklistPage extends StatefulWidget {
  const InterviewChecklistPage({super.key});

  @override
  State<InterviewChecklistPage> createState() => _InterviewChecklistPageState();
}

class _InterviewChecklistPageState extends State<InterviewChecklistPage> {
  static const _boxName = 'interview_checklist';
  late Box _box;
  bool _initialized = false;

  List<_CheckSection> _buildSections(BuildContext context) => <_CheckSection>[
    _CheckSection(context.tr.cl24hBefore, [
      _CheckItem('research_company', context.tr.clResearchCompany),
      _CheckItem('review_job', context.tr.clReviewJob),
      _CheckItem('prepare_stories', context.tr.clPrepareStories),
      _CheckItem('plan_outfit', context.tr.clPlanOutfit),
      _CheckItem('check_route', context.tr.clCheckRoute),
      _CheckItem('prepare_questions', context.tr.clPrepareQuestions),
      _CheckItem('review_resume', context.tr.clReviewResume),
      _CheckItem('sleep_early', context.tr.clSleepEarly),
    ]),
    _CheckSection(context.tr.cl1hBefore, [
      _CheckItem('eat_light', context.tr.clEatLight),
      _CheckItem('review_notes', context.tr.clReviewNotes),
      _CheckItem('charge_devices', context.tr.clChargeDevices),
      _CheckItem('quiet_space', context.tr.clQuietSpace),
      _CheckItem('test_camera', context.tr.clTestCamera),
      _CheckItem('gather_materials', context.tr.clGatherMaterials),
    ]),
    _CheckSection(context.tr.cl5minBefore, [
      _CheckItem('deep_breaths', context.tr.clDeepBreaths),
      _CheckItem('power_pose', context.tr.clPowerPose),
      _CheckItem('smile', context.tr.clSmile),
      _CheckItem('silence_phone', context.tr.clSilencePhone),
      _CheckItem('water_ready', context.tr.clWaterReady),
      _CheckItem('positive_thought', context.tr.clPositiveThought),
      _CheckItem('remember_name', context.tr.clRememberName),
      _CheckItem('open_notes', context.tr.clOpenNotes),
      _CheckItem('final_check', context.tr.clFinalCheck),
      _CheckItem('join_early', context.tr.clJoinEarly),
    ]),
  ];

  @override
  void initState() {
    super.initState();
    _initBox();
  }

  Future<void> _initBox() async {
    _box = await Hive.openBox(_boxName);
    if (mounted) setState(() => _initialized = true);
  }

  bool _isChecked(String id) => _box.get(id, defaultValue: false);

  Future<void> _toggle(String id) async {
    await _box.put(id, !_isChecked(id));
    setState(() {});
  }

  Future<void> _resetAll() async {
    await _box.clear();
    setState(() {});
  }

  int get _totalItems {
    int count = 0;
    // Count based on known item IDs
    final ids = ['research_company','review_job','prepare_stories','plan_outfit','check_route','prepare_questions','review_resume','sleep_early','eat_light','review_notes','charge_devices','quiet_space','test_camera','gather_materials','deep_breaths','power_pose','smile','silence_phone','water_ready','positive_thought','remember_name','open_notes','final_check','join_early'];
    return ids.length;
  }
  int get _checkedItems {
    final ids = ['research_company','review_job','prepare_stories','plan_outfit','check_route','prepare_questions','review_resume','sleep_early','eat_light','review_notes','charge_devices','quiet_space','test_camera','gather_materials','deep_breaths','power_pose','smile','silence_phone','water_ready','positive_thought','remember_name','open_notes','final_check','join_early'];
    int count = 0;
    for (final id in ids) {
      if (_isChecked(id)) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_initialized) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr.interviewChecklist), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final progress = _totalItems > 0 ? _checkedItems / _totalItems : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.interviewChecklist),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(context.tr.reset),
                content: Text(context.tr.clearAllDialog),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.tr.cancel)),
                  FilledButton(
                    onPressed: () { _resetAll(); Navigator.pop(ctx); },
                    child: Text(context.tr.reset),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // Progress header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.success.withValues(alpha: progress > 0.8 ? 0.15 : 0.08),
                AppColors.primary.withValues(alpha: 0.05),
              ]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$_checkedItems / $_totalItems ${context.tr.completed}',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text('${(progress * 100).toInt()}%',
                        style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.success, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 800),
                    builder: (_, v, __) => LinearProgressIndicator(
                      value: v, minHeight: 8,
                      backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(AppColors.success),
                    ),
                  ),
                ),
                if (progress >= 1.0) ...[
                  const SizedBox(height: 10),
                  const Text('🎉 You\'re fully prepared!', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.success)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(context.tr.clSavedLocal,
                style: TextStyle(fontSize: 10, color: isDark ? Colors.white24 : Colors.grey[400])),
          ),
          const SizedBox(height: 16),

          // Sections
          ..._buildSections(context).map((section) => _buildSection(section, isDark)),
        ],
      ),
    );
  }

  Widget _buildSection(_CheckSection section, bool isDark) {
    final sectionChecked = section.items.where((i) => _isChecked(i.id)).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(section.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const Spacer(),
            Text('$sectionChecked/${section.items.length}',
                style: TextStyle(fontSize: 11, color: isDark ? Colors.white24 : Colors.grey[400])),
          ],
        ),
        const SizedBox(height: 8),
        ...section.items.map((item) {
          final checked = _isChecked(item.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: GestureDetector(
              onTap: () => _toggle(item.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: checked
                      ? AppColors.success.withValues(alpha: isDark ? 0.08 : 0.04)
                      : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: checked
                        ? AppColors.success.withValues(alpha: 0.3)
                        : (isDark ? Colors.white10 : Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: checked ? AppColors.success : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: checked ? AppColors.success : (isDark ? Colors.white24 : Colors.grey[300]!),
                          width: 2,
                        ),
                      ),
                      child: checked
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 13,
                          decoration: checked ? TextDecoration.lineThrough : null,
                          color: checked
                              ? (isDark ? Colors.white38 : Colors.grey[400])
                              : (isDark ? Colors.white70 : Colors.grey[800]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _CheckSection {
  final String title;
  final List<_CheckItem> items;
  const _CheckSection(this.title, this.items);
}

class _CheckItem {
  final String id;
  final String label;
  const _CheckItem(this.id, this.label);
}
