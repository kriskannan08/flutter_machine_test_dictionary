import 'package:go_router/go_router.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/pages/history_page.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/pages/home_page.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/pages/word_details_page.dart';
import 'package:machine_test_dictionary/shared/presentation/pages/splash_screen.dart';

enum AppRoute { splash, home, wordDetails, history }

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/';
      case AppRoute.home:
        return '/home';
      case AppRoute.wordDetails:
        return '/details';
      case AppRoute.history:
        return '/history';
    }
  }
}

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: AppRoute.splash.path,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoute.home.path,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoute.wordDetails.path,
      builder: (context, state) => const WordDetailsPage(),
    ),
    GoRoute(
      path: AppRoute.history.path,
      builder: (context, state) => const HistoryPage(),
    ),
  ],
);
