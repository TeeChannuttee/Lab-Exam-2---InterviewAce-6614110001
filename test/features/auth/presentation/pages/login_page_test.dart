import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget Test: Login Form Validation
// Tests that the form validates email and password correctly
// Uses GlobalKey<FormState> as required by exam spec

void main() {
  // Disable Google Fonts HTTP fetching in tests
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget buildLoginForm({
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    VoidCallback? onSubmit,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const Key('email_field'),
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your email';
                    if (!v.contains('@')) return 'Please enter a valid email';
                    return null;
                  },
                ),
                TextFormField(
                  key: const Key('password_field'),
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your password';
                    if (v.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  key: const Key('login_button'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      onSubmit?.call();
                    }
                  },
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  group('Login Form Widget Tests', () {
    testWidgets('shows email validation error when empty', (tester) async {
      final formKey = GlobalKey<FormState>();
      final emailCtrl = TextEditingController();
      final passCtrl = TextEditingController();

      await tester.pumpWidget(buildLoginForm(
        formKey: formKey,
        emailController: emailCtrl,
        passwordController: passCtrl,
      ));

      // Submit empty form
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('shows invalid email error', (tester) async {
      final formKey = GlobalKey<FormState>();
      final emailCtrl = TextEditingController();
      final passCtrl = TextEditingController();

      await tester.pumpWidget(buildLoginForm(
        formKey: formKey,
        emailController: emailCtrl,
        passwordController: passCtrl,
      ));

      await tester.enterText(find.byKey(const Key('email_field')), 'notanemail');
      await tester.enterText(find.byKey(const Key('password_field')), '123456');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('shows short password error', (tester) async {
      final formKey = GlobalKey<FormState>();
      final emailCtrl = TextEditingController();
      final passCtrl = TextEditingController();

      await tester.pumpWidget(buildLoginForm(
        formKey: formKey,
        emailController: emailCtrl,
        passwordController: passCtrl,
      ));

      await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), '123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('valid form passes validation and calls onSubmit', (tester) async {
      final formKey = GlobalKey<FormState>();
      final emailCtrl = TextEditingController();
      final passCtrl = TextEditingController();
      bool submitted = false;

      await tester.pumpWidget(buildLoginForm(
        formKey: formKey,
        emailController: emailCtrl,
        passwordController: passCtrl,
        onSubmit: () => submitted = true,
      ));

      await tester.enterText(find.byKey(const Key('email_field')), 'test@company.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsNothing);
      expect(find.text('Please enter your password'), findsNothing);
      expect(submitted, isTrue);
    });

    testWidgets('form renders all expected elements', (tester) async {
      final formKey = GlobalKey<FormState>();
      final emailCtrl = TextEditingController();
      final passCtrl = TextEditingController();

      await tester.pumpWidget(buildLoginForm(
        formKey: formKey,
        emailController: emailCtrl,
        passwordController: passCtrl,
      ));

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });
  });
}
