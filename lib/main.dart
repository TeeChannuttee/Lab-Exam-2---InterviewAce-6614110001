import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interview_ace/core/di/injection.dart';
import 'package:interview_ace/core/l10n/app_localizations.dart';
import 'package:interview_ace/core/router/app_router.dart';
import 'package:interview_ace/core/theme/app_theme.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (.env)
  await dotenv.load(fileName: '.env');

  // Initialize dependency injection (get_it)
  await initDependencies();

  runApp(const InterviewAceApp());
}

class InterviewAceApp extends StatelessWidget {
  const InterviewAceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>()..add(LoadSettingsEvent()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          final appRouter = AppRouter();
          final locale = Locale(settingsState.language);

          return MaterialApp.router(
            title: 'InterviewAce',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: locale,
            supportedLocales: const [Locale('en'), Locale('th')],
            localizationsDelegates: [
              AppLocalizationsDelegate(settingsState.language),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: appRouter.config(),
          );
        },
      ),
    );
  }
}
