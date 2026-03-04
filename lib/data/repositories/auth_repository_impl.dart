import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthStorage _storage;

  AuthRepositoryImpl({required AuthStorage storage}) : _storage = storage;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<bool> isLoggedIn() async {
    final email = await _storage.getLoggedInUser();
    return email != null;
  }

  @override
  Future<String?> getLoggedInEmail() => _storage.getLoggedInUser();

  @override
  Future<String?> login(String email, String password) async {
    final storedHash = await _storage.getPasswordHash(email);
    if (storedHash == null) {
      return 'User not found';
    }
    if (storedHash != _hashPassword(password)) {
      return 'Invalid password';
    }
    await _storage.setLoggedIn(email);
    return null;
  }

  @override
  Future<String?> signUp(String email, String password) async {
    if (await _storage.userExists(email)) {
      return 'User already exists';
    }
    await _storage.saveUser(email, _hashPassword(password));
    await _storage.setLoggedIn(email);
    return null;
  }

  @override
  Future<void> logout() => _storage.logout();
}
