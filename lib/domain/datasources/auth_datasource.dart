import '../entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String phoneNumber, String password);
  Future<User> simulatedLogin(String email, String password);
  Future<User> register(String email, String phoneNumber, String password, String fullName);
  Future<User> checkAuthStatus(String token);
}