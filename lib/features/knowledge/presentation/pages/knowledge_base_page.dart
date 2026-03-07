import 'dart:convert';
import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/interview/data/datasources/local/database/app_database.dart';
import 'package:interview_ace/features/interview/data/datasources/remote/openai_remote_datasource.dart';
import 'package:interview_ace/features/interview/data/datasources/local/hive_cache_service.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Interview Knowledge Base — AI-powered personalized library (Professional UI)
@RoutePage()
class KnowledgeBasePage extends StatefulWidget {
  const KnowledgeBasePage({super.key});

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _headerAnim;
  late AnimationController _cardAnim;

  List<InterviewSession> _sessions = [];
  double? _avgScore;
  String? _topWeakness;
  String? _topStrength;
  String? _mostPracticedPosition;
  int _totalSessions = 0;

  String? _aiTip;
  bool _loadingTip = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _headerAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..forward();
    _cardAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();
    _loadRealData();
  }

  Future<void> _loadRealData() async {
    final db = sl<AppDatabase>();
    final sessions = await db.getAllSessionRows();
    final avg = await db.getAverageScore();

    String? weakness, strength, topPosition;
    if (sessions.isNotEmpty) {
      final posMap = <String, int>{};
      final weakMap = <String, int>{};
      final strongMap = <String, int>{};

      for (final s in sessions) {
        posMap[s.position] = (posMap[s.position] ?? 0) + 1;
        if (s.weaknesses != null) for (final k in _extractTopics(s.weaknesses!)) weakMap[k] = (weakMap[k] ?? 0) + 1;
        if (s.strengths != null) for (final k in _extractTopics(s.strengths!)) strongMap[k] = (strongMap[k] ?? 0) + 1;
      }

      topPosition = posMap.entries.isNotEmpty ? (posMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key : null;
      weakness = weakMap.entries.isNotEmpty ? (weakMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key : null;
      strength = strongMap.entries.isNotEmpty ? (strongMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key : null;
    }

    final cache = sl<HiveCacheService>();
    final language = context.read<SettingsBloc>().state.language;
    final cachedTip = cache.getCachedAIResponse('knowledge_ai_tip|$language');

    if (mounted) setState(() {
      _sessions = sessions;
      _avgScore = avg;
      _topWeakness = weakness;
      _topStrength = strength;
      _mostPracticedPosition = topPosition;
      _totalSessions = sessions.length;
      _aiTip = cachedTip;
    });
  }

  List<String> _extractTopics(String text) {
    final topics = <String>[];
    final l = text.toLowerCase();
    if (l.contains('star') || l.contains('structure')) topics.add('STAR Method');
    if (l.contains('specific') || l.contains('vague') || l.contains('detail')) topics.add('Specificity');
    if (l.contains('confident') || l.contains('nervous')) topics.add('Confidence');
    if (l.contains('technical') || l.contains('code')) topics.add('Technical');
    if (l.contains('communi') || l.contains('articul')) topics.add('Communication');
    if (l.contains('time') || l.contains('length')) topics.add('Time Management');
    if (l.contains('example') || l.contains('scenario')) topics.add('Examples');
    if (l.contains('leadership') || l.contains('team')) topics.add('Leadership');
    if (l.contains('problem') || l.contains('solv')) topics.add('Problem Solving');
    if (l.contains('result') || l.contains('outcome')) topics.add('Results-Oriented');
    return topics;
  }

  Future<void> _generateAiTip() async {
    if (_loadingTip) return;
    setState(() => _loadingTip = true);
    try {
      final openai = sl<OpenAIRemoteDataSource>();
      final cache = sl<HiveCacheService>();

      final ctx = StringBuffer();
      if (_totalSessions > 0) {
        ctx.write('User completed $_totalSessions practice interviews. ');
        if (_avgScore != null) ctx.write('Average score: ${_avgScore!.toInt()}%. ');
        if (_mostPracticedPosition != null) ctx.write('Most practiced role: $_mostPracticedPosition. ');
        if (_topWeakness != null) ctx.write('Main weakness: $_topWeakness. ');
        if (_topStrength != null) ctx.write('Main strength: $_topStrength. ');
      } else {
        ctx.write('User is a beginner with no practice interviews yet. ');
      }

      final language = context.read<SettingsBloc>().state.language;
      final langInstruction = language == 'th' ? 'Respond in Thai language.' : 'Respond in English.';

      final response = await openai.dioClient.dio.post('/chat/completions', data: {
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'system', 'content': 'You are an expert career coach. Always respond with valid JSON only. $langInstruction'},
          {'role': 'user', 'content': 'Based on this profile: ${ctx.toString()}\n\nGenerate 3 personalized, actionable interview tips. Each 2-3 sentences. $langInstruction Return as JSON array of strings.'},
        ],
        'temperature': 0.8, 'max_tokens': 800,
      });

      final content = response.data['choices'][0]['message']['content'] as String;
      final cleaned = content.replaceAll(RegExp(r'^```json\s*|```\s*$'), '').trim();
      final decoded = jsonDecode(cleaned);
      final List<dynamic> tipsList = decoded is List ? decoded : (decoded is Map && decoded.values.first is List ? decoded.values.first as List : [decoded.toString()]);
      final tips = tipsList.cast<String>();
      final tipText = tips.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n\n');
      cache.cacheAIResponse('knowledge_ai_tip|$language', tipText);
      if (mounted) setState(() => _aiTip = tipText);
    } catch (e) {
      debugPrint('AI Tip error: $e');
    } finally {
      if (mounted) setState(() => _loadingTip = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _headerAnim.dispose();
    _cardAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tr = context.tr;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.knowledgeBase),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(icon: const Icon(Icons.person_outline, size: 18), text: tr.kbForYou),
            Tab(icon: const Icon(Icons.star_outline, size: 18), text: tr.kbStar),
            Tab(icon: const Icon(Icons.lightbulb_outline, size: 18), text: tr.kbTips),
            Tab(icon: const Icon(Icons.business_center_outlined, size: 18), text: tr.kbIndustry),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildForYouTab(isDark),
          _buildStarTab(isDark),
          _buildTipsTab(isDark),
          _buildIndustryTab(isDark),
        ],
      ),
    );
  }

  // ─────── TAB 1: FOR YOU ───────

  Widget _buildForYouTab(bool isDark) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        _buildPersonalHeader(isDark),
        const SizedBox(height: 20),
        _buildAiTipCard(isDark),
        const SizedBox(height: 20),
        if (_topWeakness != null) ...[_buildRecommendationCard(isDark), const SizedBox(height: 16)],
        if (_totalSessions > 0) ...[_buildQuickStats(isDark), const SizedBox(height: 16)],
        if (_totalSessions == 0) ...[_buildGettingStarted(isDark), const SizedBox(height: 16)],
      ],
    );
  }

  Widget _buildPersonalHeader(bool isDark) {
    final tr = context.tr;
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
          .animate(CurvedAnimation(parent: _headerAnim, curve: Curves.easeOutCubic)),
      child: FadeTransition(
        opacity: _headerAnim,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.primary.withValues(alpha: 0.08), Colors.blue.withValues(alpha: 0.04)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.insights_rounded, color: AppColors.primary, size: 22)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tr.kbPersonalInsights, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: -0.3)),
                Text(_totalSessions > 0 ? tr.kbBasedOnSessions.replaceAll('{n}', '$_totalSessions') : tr.kbCompleteToUnlock,
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
              ])),
            ]),
            if (_avgScore != null) ...[
              const SizedBox(height: 16),
              Row(children: [
                _statChip(tr.kbAvgScore, '${_avgScore!.toInt()}%', _avgScore! >= 70 ? AppColors.success : AppColors.warning, isDark),
                const SizedBox(width: 10),
                _statChip(tr.kbSessions, '$_totalSessions', AppColors.primary, isDark),
                if (_mostPracticedPosition != null) ...[
                  const SizedBox(width: 10),
                  _statChip(tr.kbFocus, _mostPracticedPosition!, Colors.deepPurple, isDark),
                ],
              ]),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _statChip(String label, String value, Color c, bool isDark) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: c), overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, color: c.withValues(alpha: 0.7)), overflow: TextOverflow.ellipsis),
      ]),
    ));
  }

  Widget _buildAiTipCard(bool isDark) {
    final tr = context.tr;
    return FadeTransition(
      opacity: CurvedAnimation(parent: _cardAnim, curve: Curves.easeIn),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.auto_awesome, color: Colors.deepPurple, size: 20)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tr.kbAiCoach, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: -0.3)),
              Text(tr.kbAiCoachSub, style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
            ])),
          ]),
          const SizedBox(height: 16),
          if (_aiTip != null) ...[
            Container(width: double.infinity, padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: isDark ? Colors.deepPurple.withValues(alpha: 0.06) : Colors.grey[50],
                borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[200]!)),
              child: Text(_aiTip!, style: TextStyle(fontSize: 13, height: 1.6, color: isDark ? Colors.white70 : Colors.grey[700]))),
            const SizedBox(height: 14),
          ],
          SizedBox(width: double.infinity, child: OutlinedButton.icon(
            onPressed: _loadingTip ? null : _generateAiTip,
            icon: _loadingTip ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome, size: 16),
            label: Text(_aiTip != null ? tr.kbRegenerate : tr.kbGenerateAi),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.deepPurple, side: BorderSide(color: Colors.deepPurple.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 12)),
          )),
        ]),
      ),
    );
  }

  Widget _buildRecommendationCard(bool isDark) {
    final tr = context.tr;
    final recs = _getPersonalizedRecommendations();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.recommend_outlined, color: AppColors.warning, size: 18),
          const SizedBox(width: 8),
          Text(tr.kbRecommended, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: -0.3)),
        ]),
        const SizedBox(height: 4),
        Text(tr.kbFocusArea.replaceAll('{area}', _topWeakness ?? ''), style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
        const SizedBox(height: 12),
        ...recs.map((r) => _recItem(r['title']!, r['desc']!, IconData(int.parse(r['icon']!), fontFamily: 'MaterialIcons'), isDark)),
      ]),
    );
  }

  List<Map<String, String>> _getPersonalizedRecommendations() {
    final recs = <Map<String, String>>[];
    final w = _topWeakness?.toLowerCase() ?? '';
    if (w.contains('star') || w.contains('structur') || w.contains('specific')) {
      recs.add({'title': 'Master STAR Method', 'desc': 'Structure answers: Situation → Task → Action → Result', 'icon': '${Icons.star_outline.codePoint}'});
      recs.add({'title': 'Use Quantifiable Results', 'desc': 'Include numbers: "increased 30%", "saved \$50K"', 'icon': '${Icons.bar_chart.codePoint}'});
    }
    if (w.contains('confiden') || w.contains('nervous')) {
      recs.add({'title': 'Build Confidence', 'desc': 'Power pose 2 min before — proven to boost confidence', 'icon': '${Icons.fitness_center.codePoint}'});
    }
    if (w.contains('technic') || w.contains('code')) {
      recs.add({'title': 'Think Out Loud', 'desc': 'Interviewers value your thought process over the final answer', 'icon': '${Icons.psychology.codePoint}'});
    }
    if (w.contains('communi') || w.contains('articul')) {
      recs.add({'title': 'Use the Pause', 'desc': '3-5 seconds before answering shows thoughtfulness', 'icon': '${Icons.pause_circle_outline.codePoint}'});
    }
    if (recs.isEmpty) {
      recs.add({'title': 'Practice STAR Method', 'desc': 'The #1 technique for behavioral interviews', 'icon': '${Icons.star_outline.codePoint}'});
      recs.add({'title': 'Prepare Stories', 'desc': 'Have 5 stories ready that showcase different skills', 'icon': '${Icons.auto_stories.codePoint}'});
      recs.add({'title': 'Research Company', 'desc': 'Know their mission, values, and recent news', 'icon': '${Icons.search.codePoint}'});
    }
    return recs.take(3).toList();
  }

  Widget _recItem(String title, String desc, IconData icon, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: isDark ? 0.05 : 0.03), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: AppColors.warning)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey[600], height: 1.3)),
        ])),
      ]),
    );
  }

  Widget _buildQuickStats(bool isDark) {
    final tr = context.tr;
    final recent = _sessions.take(5).toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.trending_up, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(tr.kbRecentPerf, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: -0.3)),
        ]),
        const SizedBox(height: 12),
        ...recent.map((s) {
          final score = s.totalScore ?? 0;
          final c = score >= 70 ? AppColors.success : score >= 50 ? AppColors.warning : AppColors.error;
          return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
            SizedBox(width: 90, child: Text(s.position, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
            const SizedBox(width: 8),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: score / 100, minHeight: 5, backgroundColor: isDark ? Colors.white12 : Colors.grey[200], valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 8),
            SizedBox(width: 34, child: Text('${score.toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c))),
          ]));
        }),
        if (_topStrength != null) ...[
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.check_circle_outline, size: 14, color: AppColors.success),
              const SizedBox(width: 6),
              Text(tr.kbStrengthLabel.replaceAll('{s}', _topStrength!), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success)),
            ])),
        ],
      ]),
    );
  }

  Widget _buildGettingStarted(bool isDark) {
    final tr = context.tr;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!)),
      child: Column(children: [
        Icon(Icons.rocket_launch_outlined, size: 44, color: AppColors.primary.withValues(alpha: 0.5)),
        const SizedBox(height: 12),
        Text(tr.kbStartJourney, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17, letterSpacing: -0.3)),
        const SizedBox(height: 6),
        Text(tr.kbStartJourneySub, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: isDark ? Colors.white38 : Colors.grey[500])),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => context.router.pushNamed('/setup-interview'),
          icon: const Icon(Icons.play_arrow_rounded, size: 20),
          label: Text(tr.startInterview),
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
        ),
      ]),
    );
  }

  // ─────── TAB 2: STAR ───────

  Widget _buildStarTab(bool isDark) {
    final tr = context.tr;
    final items = [
      _StarItem('S', tr.kbSituation, tr.kbSituationDesc, tr.kbSituationEx, const Color(0xFF3B82F6)),
      _StarItem('T', tr.kbTask, tr.kbTaskDesc, tr.kbTaskEx, const Color(0xFFF59E0B)),
      _StarItem('A', tr.kbAction, tr.kbActionDesc, tr.kbActionEx, const Color(0xFF10B981)),
      _StarItem('R', tr.kbResult, tr.kbResultDesc, tr.kbResultEx, const Color(0xFFEF4444)),
    ];
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Text(tr.kbStarTitle, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Text(tr.kbStarSubtitle, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500], fontSize: 13)),
        const SizedBox(height: 20),
        ...items.asMap().entries.map((e) {
          final i = e.key;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 400 + i * 150),
            builder: (_, v, child) => Transform.translate(offset: Offset(0, 16 * (1 - v)), child: Opacity(opacity: v, child: child)),
            child: _buildStarCard(e.value, isDark),
          );
        }),
        const SizedBox(height: 16),
        _buildBestPractices(isDark),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStarCard(_StarItem item, bool isDark) {
    final tr = context.tr;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(14), border: Border.all(color: item.color.withValues(alpha: 0.15))),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        leading: Container(width: 38, height: 38,
          decoration: BoxDecoration(color: item.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(item.letter, style: TextStyle(color: item.color, fontWeight: FontWeight.w900, fontSize: 18)))),
        title: Text(item.title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: item.color)),
        subtitle: Text(item.description, style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
        children: [
          Container(width: double.infinity, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: item.color.withValues(alpha: isDark ? 0.06 : 0.03), borderRadius: BorderRadius.circular(10)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tr.kbExample, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: item.color)),
              const SizedBox(height: 4),
              Text('"${item.example}"', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: isDark ? Colors.white54 : Colors.grey[700], height: 1.5)),
            ])),
        ],
      ),
    );
  }

  Widget _buildBestPractices(bool isDark) {
    final tr = context.tr;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(tr.kbBestPractices, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: -0.3)),
        const SizedBox(height: 12),
        _practice(Icons.check_circle_outline, tr.kbDoSpecific, AppColors.success, isDark),
        _practice(Icons.check_circle_outline, tr.kbDoYourActions, AppColors.success, isDark),
        _practice(Icons.check_circle_outline, tr.kbDoKeepTime, AppColors.success, isDark),
        const SizedBox(height: 8),
        _practice(Icons.cancel_outlined, tr.kbDontVague, AppColors.error, isDark),
        _practice(Icons.cancel_outlined, tr.kbDontBadmouth, AppColors.error, isDark),
        _practice(Icons.cancel_outlined, tr.kbDontNoQuestion, AppColors.error, isDark),
      ]),
    );
  }

  Widget _practice(IconData icon, String text, Color c, bool isDark) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
      Icon(icon, size: 16, color: c),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[700]))),
    ]));
  }

  // ─────── TAB 3: TIPS ───────

  Widget _buildTipsTab(bool isDark) {
    final tr = context.tr;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        _tipSection(tr.kbPowerPhrases, Icons.format_quote_rounded, const Color(0xFF8B5CF6), isDark, [
          _TipItem(tr.kbShowImpact, tr.kbShowImpactDesc, tr.kbShowImpactEx),
          _TipItem(tr.kbShowGrowth, tr.kbShowGrowthDesc, tr.kbShowGrowthEx),
          _TipItem(tr.kbShowFit, tr.kbShowFitDesc, tr.kbShowFitEx),
          _TipItem(tr.kbShowInit, tr.kbShowInitDesc, tr.kbShowInitEx),
        ]),
        const SizedBox(height: 14),
        _tipSection(tr.kbCommonMistakes, Icons.warning_amber_outlined, AppColors.error, isDark, [
          _TipItem(tr.kbTooVague, tr.kbTooVagueSub, tr.kbTooVagueEx),
          _TipItem(tr.kbNegativity, tr.kbNegativitySub, tr.kbNegativityEx),
          _TipItem(tr.kbUnprepared, tr.kbUnpreparedSub, tr.kbUnpreparedEx),
          _TipItem(tr.kbOverRehearsed, tr.kbOverRehearsedSub, tr.kbOverRehearsedEx),
        ]),
        const SizedBox(height: 14),
        _tipSection(tr.kbAdvancedTactics, Icons.psychology_outlined, const Color(0xFFEC4899), isDark, [
          _TipItem(tr.kb2MinRule, tr.kb2MinRuleSub, tr.kb2MinRuleEx),
          _TipItem(tr.kbMirror, tr.kbMirrorSub, tr.kbMirrorEx),
          _TipItem(tr.kbPause, tr.kbPauseSub, tr.kbPauseEx),
          _TipItem(tr.kbFollowUp, tr.kbFollowUpSub, tr.kbFollowUpEx),
          _TipItem(tr.kbPortfolio, tr.kbPortfolioSub, tr.kbPortfolioEx),
        ]),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _tipSection(String title, IconData icon, Color color, bool isDark, List<_TipItem> items) {
    final tr = context.tr;
    return Container(
      decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.12))),
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        leading: Icon(icon, color: color, size: 20),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: -0.3)),
        subtitle: Text(tr.kbTopics.replaceAll('{n}', '${items.length}'), style: TextStyle(fontSize: 11, color: color)),
        children: items.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withValues(alpha: isDark ? 0.05 : 0.02), borderRadius: BorderRadius.circular(10)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: color)),
            Text(item.subtitle, style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
            const SizedBox(height: 4),
            Text(item.example, style: TextStyle(fontSize: 12, height: 1.4, color: isDark ? Colors.white54 : Colors.grey[700])),
          ]),
        )).toList(),
      ),
    );
  }

  // ─────── TAB 4: INDUSTRY ───────

  Widget _buildIndustryTab(bool isDark) {
    final tr = context.tr;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        _industryCard(Icons.code, tr.kbTech, AppColors.primary, isDark, [
          tr.kbTech1, tr.kbTech2, tr.kbTech3, tr.kbTech4, tr.kbTech5, tr.kbTech6,
        ]),
        _industryCard(Icons.account_balance, tr.kbFinance, Colors.green, isDark, [
          tr.kbFinance1, tr.kbFinance2, tr.kbFinance3, tr.kbFinance4, tr.kbFinance5, tr.kbFinance6,
        ]),
        _industryCard(Icons.campaign, tr.kbMarketing, Colors.orange, isDark, [
          tr.kbMarketing1, tr.kbMarketing2, tr.kbMarketing3, tr.kbMarketing4, tr.kbMarketing5, tr.kbMarketing6,
        ]),
        _industryCard(Icons.local_hospital, tr.kbHealthcare, Colors.red, isDark, [
          tr.kbHealthcare1, tr.kbHealthcare2, tr.kbHealthcare3, tr.kbHealthcare4, tr.kbHealthcare5, tr.kbHealthcare6,
        ]),
        _industryCard(Icons.analytics, tr.kbConsulting, Colors.purple, isDark, [
          tr.kbConsulting1, tr.kbConsulting2, tr.kbConsulting3, tr.kbConsulting4, tr.kbConsulting5, tr.kbConsulting6,
        ]),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _industryCard(IconData icon, String title, Color color, bool isDark, List<String> tips) {
    final tr = context.tr;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.12))),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        leading: Container(width: 38, height: 38,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        subtitle: Text(tr.kbFocusAreas.replaceAll('{n}', '${tips.length}'), style: TextStyle(fontSize: 11, color: color)),
        children: tips.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 20, height: 20,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.08), shape: BoxShape.circle),
              child: Center(child: Text('${e.key + 1}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: color)))),
            const SizedBox(width: 8),
            Expanded(child: Text(e.value, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[700], height: 1.4))),
          ]),
        )).toList(),
      ),
    );
  }
}

class _StarItem {
  final String letter, title, description, example;
  final Color color;
  const _StarItem(this.letter, this.title, this.description, this.example, this.color);
}

class _TipItem {
  final String title, subtitle, example;
  const _TipItem(this.title, this.subtitle, this.example);
}
