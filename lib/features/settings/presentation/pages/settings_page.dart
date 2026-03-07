import 'package:flutter/material.dart';
import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:interview_ace/core/constants/app_colors.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/features/interview/data/datasources/local/database/app_database.dart'
    as db;
import 'package:interview_ace/features/interview/data/datasources/local/hive_cache_service.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.settings),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              _buildSectionTitle(context.tr.appearance, Icons.palette_outlined, context),
              const SizedBox(height: 12),
              _buildSettingCard(
                isDark: isDark,
                children: [
                  _buildSwitchTile(
                    icon: Icons.dark_mode_rounded,
                    title: context.tr.darkMode,
                    subtitle: state.isDarkMode ? context.tr.darkTheme : context.tr.lightTheme,
                    value: state.isDarkMode,
                    onChanged: (_) {
                      context.read<SettingsBloc>().add(ToggleDarkModeEvent());
                    },
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(context.tr.languageSetting, Icons.translate_rounded, context),
              const SizedBox(height: 12),
              _buildSettingCard(
                isDark: isDark,
                children: [
                  _buildLanguageTile(
                    emoji: '🇺🇸',
                    label: 'English',
                    value: 'en',
                    selected: state.language,
                    onTap: () {
                      context.read<SettingsBloc>().add(ChangeLanguageEvent(language: 'en'));
                    },
                    isDark: isDark,
                  ),
                  Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey[200]),
                  _buildLanguageTile(
                    emoji: '🇹🇭',
                    label: 'ไทย',
                    value: 'th',
                    selected: state.language,
                    onTap: () {
                      context.read<SettingsBloc>().add(ChangeLanguageEvent(language: 'th'));
                    },
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(context.tr.data, Icons.storage_outlined, context),
              const SizedBox(height: 12),
              _buildSettingCard(
                isDark: isDark,
                children: [
                  _buildActionTile(
                    icon: Icons.cached_rounded,
                    title: context.tr.clearCache,
                    subtitle: context.tr.clearCacheSub,
                    color: AppColors.warning,
                    onTap: () => _showClearCacheDialog(context),
                    isDark: isDark,
                  ),
                  Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey[200]),
                  _buildActionTile(
                    icon: Icons.delete_forever_rounded,
                    title: context.tr.clearAllData,
                    subtitle: context.tr.clearAllDataSub,
                    color: AppColors.error,
                    onTap: () => _showClearAllDialog(context),
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(context.tr.about, Icons.info_outline_rounded, context),
              const SizedBox(height: 12),
              _buildSettingCard(
                isDark: isDark,
                children: [
                  _buildInfoTile(
                    icon: Icons.psychology_outlined,
                    title: 'InterviewAce',
                    subtitle: context.tr.version,
                    isDark: isDark,
                  ),
                  Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey[200]),
                  _buildInfoTile(
                    icon: Icons.school_outlined,
                    title: 'Built with Flutter',
                    subtitle: context.tr.builtWithFlutter,
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String text, IconData icon, BuildContext context) {
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

  Widget _buildSettingCard({required bool isDark, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildLanguageTile({
    required String emoji,
    required String label,
    required String value,
    required String selected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final isSelected = value == selected;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      leading: Text(emoji, style: const TextStyle(fontSize: 24)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: isSelected
          ? Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            )
          : null,
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
      trailing: Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white24 : Colors.grey[300]),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr.clearCacheQuestion),
        content: Text(context.tr.clearCacheBody),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.tr.cancel)),
          FilledButton(
            onPressed: () async {
              await sl<HiveCacheService>().clearAll();
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.tr.cacheCleared),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
            child: Text(context.tr.clear),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr.profClearAllTitle),
        content: Text(context.tr.profClearAllBody),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.tr.cancel)),
          FilledButton(
            onPressed: () async {
              await sl<db.AppDatabase>().clearAllData();
              await sl<HiveCacheService>().clearAll();
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.tr.profAllCleared),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(context.tr.profDeleteAll),
          ),
        ],
      ),
    );
  }
}
