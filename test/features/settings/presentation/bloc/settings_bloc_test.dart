import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsBloc', () {
    setUp(() {
      // Set up mock SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is SettingsState with defaults', () {
      final bloc = SettingsBloc();
      expect(bloc.state.isDarkMode, isFalse);
      expect(bloc.state.language, 'en');
      bloc.close();
    });

    blocTest<SettingsBloc, SettingsState>(
      'emits state with toggled dark mode when ToggleDarkModeEvent is added',
      setUp: () => SharedPreferences.setMockInitialValues({}),
      build: () => SettingsBloc(),
      act: (bloc) => bloc.add(ToggleDarkModeEvent()),
      expect: () => [
        isA<SettingsState>().having((s) => s.isDarkMode, 'isDarkMode', true),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'toggles dark mode twice returns to original',
      setUp: () => SharedPreferences.setMockInitialValues({}),
      build: () => SettingsBloc(),
      act: (bloc) async {
        bloc.add(ToggleDarkModeEvent());
        await Future.delayed(const Duration(milliseconds: 300));
        bloc.add(ToggleDarkModeEvent());
      },
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<SettingsState>().having((s) => s.isDarkMode, 'isDarkMode', true),
        isA<SettingsState>().having((s) => s.isDarkMode, 'isDarkMode', false),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits state with new language when ChangeLanguageEvent is added',
      setUp: () => SharedPreferences.setMockInitialValues({}),
      build: () => SettingsBloc(),
      act: (bloc) => bloc.add(ChangeLanguageEvent(language: 'th')),
      expect: () => [
        isA<SettingsState>().having((s) => s.language, 'language', 'th'),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'loads saved settings from SharedPreferences',
      setUp: () => SharedPreferences.setMockInitialValues({
        'isDarkMode': false,
        'language': 'th',
      }),
      build: () => SettingsBloc(),
      act: (bloc) => bloc.add(LoadSettingsEvent()),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isDarkMode, 'isDarkMode', false)
            .having((s) => s.language, 'language', 'th'),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'persists dark mode to SharedPreferences',
      setUp: () => SharedPreferences.setMockInitialValues({}),
      build: () => SettingsBloc(),
      act: (bloc) => bloc.add(ToggleDarkModeEvent()),
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('isDarkMode'), true);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'persists language to SharedPreferences',
      setUp: () => SharedPreferences.setMockInitialValues({}),
      build: () => SettingsBloc(),
      act: (bloc) => bloc.add(ChangeLanguageEvent(language: 'th')),
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('language'), 'th');
      },
    );
  });

  group('SettingsState', () {
    test('copyWith creates new instance with updated fields', () {
      const state = SettingsState(isDarkMode: true, language: 'en');
      final updated = state.copyWith(isDarkMode: false);

      expect(updated.isDarkMode, false);
      expect(updated.language, 'en'); // preserved
    });

    test('copyWith preserves all fields when none specified', () {
      const state = SettingsState(isDarkMode: false, language: 'th');
      final copied = state.copyWith();

      expect(copied.isDarkMode, false);
      expect(copied.language, 'th');
    });

    test('props returns correct list for equality', () {
      const state1 = SettingsState(isDarkMode: true, language: 'en');
      const state2 = SettingsState(isDarkMode: true, language: 'en');
      const state3 = SettingsState(isDarkMode: false, language: 'en');

      expect(state1.props, equals(state2.props));
      expect(state1.props, isNot(equals(state3.props)));
    });
  });
}
