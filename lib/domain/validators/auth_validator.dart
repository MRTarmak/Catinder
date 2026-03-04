class AuthValidator {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static const minPasswordLength = 6;

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите email';
    if (!_emailRegex.hasMatch(value.trim())) return 'Некорректный email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Введите пароль';
    if (value.length < minPasswordLength) return 'Минимум $minPasswordLength символов';
    return null;
  }

  static String? validatePasswordConfirm(String? value, String password) {
    if (value != password) return 'Пароли не совпадают';
    return null;
  }
}
