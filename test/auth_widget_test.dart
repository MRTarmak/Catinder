import 'package:catinder/domain/repositories/auth_repository.dart';
import 'package:catinder/presentation/screens/login_screen.dart';
import 'package:catinder/presentation/screens/sign_up_screen.dart';
import 'package:catinder/presentation/state/auth_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake AuthRepository for widget tests.
class FakeAuthRepository implements AuthRepository {
  final Map<String, String> _users = {};
  String? _loggedIn;
  String? nextError;

  @override
  Future<bool> isLoggedIn() async => _loggedIn != null;

  @override
  Future<String?> getLoggedInEmail() async => _loggedIn;

  @override
  Future<String?> login(String email, String password) async {
    if (nextError != null) return nextError;
    _loggedIn = email;
    return null;
  }

  @override
  Future<String?> signUp(String email, String password) async {
    if (nextError != null) return nextError;
    _users[email] = password;
    _loggedIn = email;
    return null;
  }

  @override
  Future<void> logout() async => _loggedIn = null;
}

void main() {
  group('LoginScreen', () {
    testWidgets('shows validation errors for empty fields', (tester) async {
      final authState = AuthState(repository: FakeAuthRepository());
      var loggedIn = false;

      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(
          authState: authState,
          onLoginSuccess: () => loggedIn = true,
          onGoToSignUp: () {},
        ),
      ));

      // Tap sign in without filling fields
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Validation errors should appear
      expect(find.textContaining('email'), findsWidgets);
      expect(loggedIn, isFalse);
    });

    testWidgets('successful login calls onLoginSuccess', (tester) async {
      final authState = AuthState(repository: FakeAuthRepository());
      var loggedIn = false;

      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(
          authState: authState,
          onLoginSuccess: () => loggedIn = true,
          onGoToSignUp: () {},
        ),
      ));

      // Fill in valid credentials
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Tap sign in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(loggedIn, isTrue);
    });

    testWidgets('shows server error from repository', (tester) async {
      final repo = FakeAuthRepository()..nextError = 'User not found';
      final authState = AuthState(repository: repo);

      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(
          authState: authState,
          onLoginSuccess: () {},
          onGoToSignUp: () {},
        ),
      ));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('User not found'), findsOneWidget);
    });
  });

  group('SignUpScreen', () {
    testWidgets('shows validation error for mismatched passwords',
        (tester) async {
      final authState = AuthState(repository: FakeAuthRepository());

      await tester.pumpWidget(MaterialApp(
        home: SignUpScreen(
          authState: authState,
          onSignUpSuccess: () {},
          onGoToLogin: () {},
        ),
      ));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );

      // Find password fields by their label
      final passwordFields = find.byType(TextFormField);
      // Field 0 = email, 1 = password, 2 = confirm
      await tester.enterText(passwordFields.at(1), 'password123');
      await tester.enterText(passwordFields.at(2), 'different');

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.textContaining('не совпадают'), findsOneWidget);
    });

    testWidgets('successful signup calls onSignUpSuccess', (tester) async {
      final authState = AuthState(repository: FakeAuthRepository());
      var signedUp = false;

      await tester.pumpWidget(MaterialApp(
        home: SignUpScreen(
          authState: authState,
          onSignUpSuccess: () => signedUp = true,
          onGoToLogin: () {},
        ),
      ));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );

      final passwordFields = find.byType(TextFormField);
      await tester.enterText(passwordFields.at(1), 'password123');
      await tester.enterText(passwordFields.at(2), 'password123');

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(signedUp, isTrue);
    });
  });
}
