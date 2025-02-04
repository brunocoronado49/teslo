import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo/config/router/app_router_notifier.dart';
import 'package:teslo/features/auth/auth.dart';
import 'package:teslo/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo/features/products/products.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Products Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
    ],

    redirect: (context, state) {
      final isGoingto = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if(isGoingto == '/splash' && authStatus == AuthStatus.checking) return null;

      if(authStatus == AuthStatus.notAuthenticated) {
        if(isGoingto == '/login' || isGoingto == '/register') return null;

        return '/login';
      }

      if(authStatus == AuthStatus.authenticated) {
        if(isGoingto == '/login' 
          || isGoingto == '/register'
          || isGoingto == '/splash') return '/';
      }

      return null;
    }
  );
});

