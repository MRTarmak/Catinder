import 'package:catinder/data/datasources/auth_storage.dart';
import 'package:catinder/data/repositories/auth_repository_impl.dart';

import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory platform implementation for testing.
class FakeSecureStoragePlatform extends FlutterSecureStoragePlatform {
  final Map<String, String> _store = {};

  @override
  Future<void> write({
    required String key,
    required String value,
    Map<String, String>? options,
  }) async {
    _store[key] = value;
  }

  @override
  Future<String?> read({
    required String key,
    Map<String, String>? options,
  }) async {
    return _store[key];
  }

  @override
  Future<void> delete({
    required String key,
    Map<String, String>? options,
  }) async {
    _store.remove(key);
  }

  @override
  Future<bool> containsKey({
    required String key,
    Map<String, String>? options,
  }) async {
    return _store.containsKey(key);
  }

  @override
  Future<Map<String, String>> readAll({Map<String, String>? options}) async {
    return Map.from(_store);
  }

  @override
  Future<void> deleteAll({Map<String, String>? options}) async {
    _store.clear();
  }
}

void main() {
  late AuthRepositoryImpl repo;

  setUp(() {
    FlutterSecureStoragePlatform.instance = FakeSecureStoragePlatform();
    final storage = AuthStorage();
    repo = AuthRepositoryImpl(storage: storage);
  });

  group('signUp', () {
    test('succeeds and logs in the user', () async {
      final error = await repo.signUp('cat@mail.com', 'password123');

      expect(error, isNull);
      expect(await repo.isLoggedIn(), isTrue);
      expect(await repo.getLoggedInEmail(), 'cat@mail.com');
    });

    test('returns error for duplicate email', () async {
      await repo.signUp('cat@mail.com', 'password123');
      final error = await repo.signUp('cat@mail.com', 'other');

      expect(error, isNotNull);
      expect(error, contains('already exists'));
    });
  });

  group('login', () {
    test('succeeds with correct credentials', () async {
      await repo.signUp('cat@mail.com', 'password123');
      await repo.logout();
      expect(await repo.isLoggedIn(), isFalse);

      final error = await repo.login('cat@mail.com', 'password123');

      expect(error, isNull);
      expect(await repo.isLoggedIn(), isTrue);
    });

    test('returns error for non-existent user', () async {
      final error = await repo.login('nobody@mail.com', 'pass');

      expect(error, isNotNull);
      expect(error, contains('not found'));
    });

    test('returns error for wrong password', () async {
      await repo.signUp('cat@mail.com', 'correct');

      final error = await repo.login('cat@mail.com', 'wrong');

      expect(error, isNotNull);
      expect(error, contains('password'));
    });
  });

  group('logout', () {
    test('clears logged-in state', () async {
      await repo.signUp('cat@mail.com', 'password123');
      expect(await repo.isLoggedIn(), isTrue);

      await repo.logout();

      expect(await repo.isLoggedIn(), isFalse);
      expect(await repo.getLoggedInEmail(), isNull);
    });
  });
}
