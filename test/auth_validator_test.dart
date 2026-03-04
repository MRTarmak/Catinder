import 'package:catinder/domain/validators/auth_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidator.validateEmail', () {
    test('returns error for null', () {
      expect(AuthValidator.validateEmail(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(AuthValidator.validateEmail(''), isNotNull);
    });

    test('returns error for whitespace only', () {
      expect(AuthValidator.validateEmail('   '), isNotNull);
    });

    test('returns error for missing @', () {
      expect(AuthValidator.validateEmail('testmail.com'), isNotNull);
    });

    test('returns error for missing domain', () {
      expect(AuthValidator.validateEmail('test@'), isNotNull);
    });

    test('returns null for valid email', () {
      expect(AuthValidator.validateEmail('user@example.com'), isNull);
    });
  });

  group('AuthValidator.validatePassword', () {
    test('returns error for null', () {
      expect(AuthValidator.validatePassword(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(AuthValidator.validatePassword(''), isNotNull);
    });

    test('returns error for short password', () {
      expect(AuthValidator.validatePassword('12345'), isNotNull);
    });

    test('returns null for valid password (6 chars)', () {
      expect(AuthValidator.validatePassword('123456'), isNull);
    });
  });

  group('AuthValidator.validatePasswordConfirm', () {
    test('returns error when passwords do not match', () {
      expect(
        AuthValidator.validatePasswordConfirm('abc', '123'),
        isNotNull,
      );
    });

    test('returns null when passwords match', () {
      expect(
        AuthValidator.validatePasswordConfirm('secret', 'secret'),
        isNull,
      );
    });
  });
}
