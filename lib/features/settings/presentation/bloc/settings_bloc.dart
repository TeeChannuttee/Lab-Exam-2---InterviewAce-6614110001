import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────── EVENTS ───────────

abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class ToggleDarkModeEvent extends SettingsEvent {}

class ChangeLanguageEvent extends SettingsEvent {
  final String language;
  ChangeLanguageEvent({required this.language});

  @override
  List<Object?> get props => [language];
}

// ─────────── STATES ───────────

class SettingsState extends Equatable {
  final bool isDarkMode;
  final String language;

  const SettingsState({
    this.isDarkMode = false,
    this.language = 'en',
  });

  SettingsState copyWith({bool? isDarkMode, String? language}) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, language];
}

// ─────────── BLOC ───────────

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onLoadSettings(
      LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(SettingsState(
      isDarkMode: prefs.getBool('isDarkMode') ?? false,
      language: prefs.getString('language') ?? 'en',
    ));
  }

  Future<void> _onToggleDarkMode(
      ToggleDarkModeEvent event, Emitter<SettingsState> emit) async {
    final newValue = !state.isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newValue);
    emit(state.copyWith(isDarkMode: newValue));
  }

  Future<void> _onChangeLanguage(
      ChangeLanguageEvent event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', event.language);
    emit(state.copyWith(language: event.language));
  }
}
