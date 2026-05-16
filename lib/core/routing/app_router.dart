import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/auth_screen.dart';
import '../../presentation/screens/main_navigation_screen.dart';
import '../../presentation/screens/gameplay_screen.dart';
import '../../data/models/category_model.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/gameplay',
        builder: (context, state) {
          final category = state.extra as CategoryModel;
          return GameplayScreen(category: category);
        },
      ),
    ],
  );
}
