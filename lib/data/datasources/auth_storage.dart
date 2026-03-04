import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _usersPrefix = 'user_';
  static const _loggedInKey = 'logged_in_user';

  final FlutterSecureStorage _storage;

  AuthStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveUser(String email, String passwordHash) async {
    await _storage.write(key: '$_usersPrefix$email', value: passwordHash);
  }

  Future<String?> getPasswordHash(String email) async {
    return _storage.read(key: '$_usersPrefix$email');
  }

  Future<bool> userExists(String email) async {
    final hash = await _storage.read(key: '$_usersPrefix$email');
    return hash != null;
  }

  Future<void> setLoggedIn(String email) async {
    await _storage.write(key: _loggedInKey, value: email);
  }

  Future<String?> getLoggedInUser() async {
    return _storage.read(key: _loggedInKey);
  }

  Future<void> logout() async {
    await _storage.delete(key: _loggedInKey);
  }
}
