import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/features/auth/domain/domain.dart';
import 'package:teslo/features/auth/infrastructure/infrastructure.dart';

enum AuthStatus {checking, authenticated, notAuthenticated}

// Crea los estados
class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage
  );
}

// Contiene la logica para manejar los estadios
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}): super(AuthState());
  
  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);

      _setLoggedUser(user);
    } on WrongCredentials {
      logout('Credenciales incorrectas');
    } on CustomError catch (e) {
      logout( e.message );
    } catch (e){
      logout( 'Error no controlado' );
    }
  }

  Future<void> registerUser(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.register(email, password, name);

      _setLoggedUser(user);
    } on WrongCredentials {
      logout('Credenciales incorrectas');
    } on CustomError catch (e) {
      logout( e.message );
    } catch (e){
      logout( 'Error no controlado' );
    }
  }

  void checkAuthStatus() async {

  }

  void _setLoggedUser(User user) {
    // TODO: necesito guardar el token en el dispositivo fisicamente
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout([String? errorMessage]) async {
    // TODO: Limpiar token
    state = state.copyWith(
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage
    );
  }
}

// Se usa para llamar al notifier y a los estados para que pedan ser usados
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

