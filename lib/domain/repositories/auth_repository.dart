abstract class AuthRepository {
  Future<bool> isLoggedIn();
  Future<String?> getLoggedInEmail();
  Future<String?> login(String email, String password);
  Future<String?> signUp(String email, String password);
  Future<void> logout();
}
