import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/features/auth/presentation/providers/providers.dart';

final goRouterNotifierProvider =  Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRuterNotifier(authNotifier);
});

class GoRuterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  /// Siempre revisa el estado y lo actualiza
  GoRuterNotifier(this._authNotifier) {
    /// Esta pendiente al estadp del auth y lo actualiza
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }

}


