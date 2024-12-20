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
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService
  }): super(AuthState()) {
    checkAuthStatus(); // Se llama cuando la instancia se crea
  }
  
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
    final token = await keyValueStorageService.getValue<String>('token');
    if(token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);

    state =state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: ''
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');

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
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

