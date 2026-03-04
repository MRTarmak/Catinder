import 'package:flutter/foundation.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthState extends ChangeNotifier {
  final AuthRepository _repository;

  bool _isLoading = false;
  String? _error;

  AuthState({required AuthRepository repository}) : _repository = repository;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final error = await _repository.login(email, password);
    _isLoading = false;
    _error = error;
    notifyListeners();
    return error == null;
  }

  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final error = await _repository.signUp(email, password);
    _isLoading = false;
    _error = error;
    notifyListeners();
    return error == null;
  }

  Future<void> logout() async {
    await _repository.logout();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
