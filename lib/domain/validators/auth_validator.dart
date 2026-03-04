class AuthValidator {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static const minPasswordLength = 6;

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter email';
    if (!_emailRegex.hasMatch(value.trim())) return 'Invalid email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter password';
    if (value.length < minPasswordLength) {
      return 'Minimum $minPasswordLength characters';
    }
    return null;
  }

  static String? validatePasswordConfirm(String? value, String password) {
    if (value != password) return 'Passwords do not match';
    return null;
  }
}
