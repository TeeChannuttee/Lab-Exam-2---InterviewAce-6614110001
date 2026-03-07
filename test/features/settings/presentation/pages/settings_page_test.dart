import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:interview_ace/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:interview_ace/features/settings/presentation/pages/settings_page.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

void main() {
  late MockSettingsBloc mockSettingsBloc;

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<SettingsBloc>.value(
        value: mockSettingsBloc,
        child: const SettingsPage(),
      ),
    );
  }

  group('SettingsPage Widget Tests', () {
    testWidgets('renders Settings title', (tester) async {
      when(() => mockSettingsBloc.state)
          .thenReturn(const SettingsState());

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders Dark Mode toggle', (tester) async {
      when(() => mockSettingsBloc.state)
          .thenReturn(const SettingsState(isDarkMode: true));

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('renders language options', (tester) async {
      when(() => mockSettingsBloc.state)
          .thenReturn(const SettingsState(language: 'en'));

      await tester.pumpWidget(createTestWidget());

      expect(find.text('English'), findsOneWidget);
      expect(find.text('ไทย'), findsOneWidget);
    });

    testWidgets('renders Appearance section', (tester) async {
      when(() => mockSettingsBloc.state)
          .thenReturn(const SettingsState());

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Appearance'), findsOneWidget);
    });

    testWidgets('renders Language section', (tester) async {
      when(() => mockSettingsBloc.state)
          .thenReturn(const SettingsState());

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('renders Data section with clear options', (tester) async {
      when(() => mockSettingsBloc.state)
          .thenReturn(const SettingsState());

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Clear Cache'), findsOneWidget);
      expect(find.text('Clear All Data'), findsOneWidget);
    });

    testWidgets('renders About section with app info', (tester) async {
      when(() => mockSettingsBloc.state)
          .thenReturn(const SettingsState());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to find About section (it's at the bottom)
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(find.text('InterviewAce'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);
    });

    testWidgets('dark mode switch reflects state', (tester) async {
      when(() => mockSettingsBloc.state)
          .thenReturn(const SettingsState(isDarkMode: true));

      await tester.pumpWidget(createTestWidget());

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });
  });
}
