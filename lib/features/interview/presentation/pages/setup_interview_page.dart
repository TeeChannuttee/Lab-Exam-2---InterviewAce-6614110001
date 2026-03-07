import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/features/interview/presentation/pages/interview_session_page.dart';
import 'package:interview_ace/features/voice/presentation/pages/voice_interview_page.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';

@RoutePage()
class SetupInterviewPage extends StatefulWidget {
  const SetupInterviewPage({super.key});

  @override
  State<SetupInterviewPage> createState() => _SetupInterviewPageState();
}

class _SetupInterviewPageState extends State<SetupInterviewPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _positionController = TextEditingController();
  final _companyController = TextEditingController();

  String _selectedLevel = 'Junior';
  String _selectedType = 'Behavioral';
  String _selectedLanguage = 'en';
  int _questionCount = 5;

  late final AnimationController _animController;

  final _levels = ['Junior', 'Mid-level', 'Senior', 'Lead', 'Manager'];
  final _types = ['Behavioral', 'Technical', 'Situational', 'Mixed'];

  bool _langSynced = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Auto-sync language with app locale (only on first build)
    if (!_langSynced) {
      _langSynced = true;
      final appLang = context.read<SettingsBloc>().state.language;
      _selectedLanguage = appLang;

      // Accept pre-fill from Mock Scenarios
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        if (args['prefillType'] != null) {
          _selectedType = args['prefillType'] as String;
        }
        if (args['prefillCount'] != null) {
          _questionCount = args['prefillCount'] as int;
        }
      }
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _companyController.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _positionController.text.isNotEmpty && _companyController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.setupInterview),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            _buildAnimatedSection(
              delay: 0,
              child: _buildSectionLabel('Position & Company', Icons.work_outline),
            ),
            const SizedBox(height: 12),
            _buildAnimatedSection(
              delay: 0.1,
              child: _buildTextField(
                controller: _positionController,
                label: context.tr.position,
                hint: 'e.g. Flutter Developer',
                icon: Icons.badge_outlined,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 14),
            _buildAnimatedSection(
              delay: 0.15,
              child: _buildTextField(
                controller: _companyController,
                label: context.tr.company,
                hint: 'e.g. Google, Meta, LINE',
                icon: Icons.business_outlined,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 28),

            _buildAnimatedSection(
              delay: 0.2,
              child: _buildSectionLabel('Experience Level', Icons.trending_up_rounded),
            ),
            const SizedBox(height: 12),
            _buildAnimatedSection(
              delay: 0.25,
              child: _buildChipSelector(
                items: _levels,
                selected: _selectedLevel,
                onSelected: (v) => setState(() => _selectedLevel = v),
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 28),

            _buildAnimatedSection(
              delay: 0.3,
              child: _buildSectionLabel('Question Type', Icons.quiz_outlined),
            ),
            const SizedBox(height: 12),
            _buildAnimatedSection(
              delay: 0.35,
              child: _buildChipSelector(
                items: _types,
                selected: _selectedType,
                onSelected: (v) => setState(() => _selectedType = v),
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 28),

            _buildAnimatedSection(
              delay: 0.4,
              child: _buildSectionLabel(context.tr.language, Icons.translate_rounded),
            ),
            const SizedBox(height: 12),
            _buildAnimatedSection(
              delay: 0.45,
              child: Row(
                children: [
                  _buildLanguageChip('🇺🇸 English', 'en', isDark),
                  const SizedBox(width: 10),
                  _buildLanguageChip('🇹🇭 ไทย', 'th', isDark),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _buildAnimatedSection(
              delay: 0.5,
              child: _buildSectionLabel(
                'Questions: $_questionCount',
                Icons.format_list_numbered_rounded,
              ),
            ),
            const SizedBox(height: 8),
            _buildAnimatedSection(
              delay: 0.55,
              child: Slider(
                value: _questionCount.toDouble(),
                min: 3,
                max: 15,
                divisions: 12,
                activeColor: AppColors.primary,
                label: '$_questionCount',
                onChanged: (v) => setState(() => _questionCount = v.toInt()),
              ),
            ),
            const SizedBox(height: 36),

            _buildAnimatedSection(
              delay: 0.6,
              child: _buildStartButton(context, isDark),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({required double delay, required Widget child}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animController,
        curve: Interval(delay, (delay + 0.4).clamp(0, 1), curve: Curves.easeOutCubic),
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animController,
          curve: Interval(delay, (delay + 0.4).clamp(0, 1)),
        ),
        child: child,
      ),
    );
  }

  Widget _buildSectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: (_) => setState(() {}),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildChipSelector({
    required List<String> items,
    required String selected,
    required ValueChanged<String> onSelected,
    required bool isDark,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = item == selected;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ChoiceChip(
            label: Text(item),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[100],
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.grey[700]),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
            onSelected: (_) => onSelected(item),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLanguageChip(String label, String value, bool isDark) {
    final isSelected = _selectedLanguage == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedLanguage = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected
                ? null
                : isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.transparent : (isDark ? Colors.white12 : Colors.grey[300]!),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.grey[700]),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _buildArgs() => {
    'position': _positionController.text,
    'company': _companyController.text,
    'level': _selectedLevel,
    'type': _selectedType,
    'language': _selectedLanguage,
    'count': _questionCount,
  };

  Widget _buildStartButton(BuildContext context, bool isDark) {
    final tr = context.tr;
    return Row(
      children: [
        // Typed interview button
        Expanded(
          child: _launchButton(
            icon: Icons.keyboard_rounded,
            label: _selectedLanguage == 'th' ? 'แบบพิมพ์' : 'Type',
            color: AppColors.primary,
            enabled: _isFormValid,
            isDark: isDark,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    settings: RouteSettings(name: '/interview-session', arguments: _buildArgs()),
                    builder: (_) => const InterviewSessionPage(),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        // Voice interview button
        Expanded(
          child: _launchButton(
            icon: Icons.mic_rounded,
            label: _selectedLanguage == 'th' ? 'แบบเสียง' : 'Voice',
            color: const Color(0xFF2E6EB5),
            enabled: _isFormValid,
            isDark: isDark,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    settings: RouteSettings(name: '/voice-interview', arguments: _buildArgs()),
                    builder: (_) => const VoiceInterviewPage(),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _launchButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool enabled,
    required bool isDark,
    required VoidCallback onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: enabled
            ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 5))]
            : [],
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: isDark ? Colors.white12 : Colors.grey[300],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(enabled ? icon : Icons.lock_outline, size: 24),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
