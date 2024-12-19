import 'package:teslo/features/auth/domain/domain.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name);
  Future<User> checkAuthStatus(String token);
}

