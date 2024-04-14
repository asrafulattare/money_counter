import 'package:go_router/go_router.dart';
import 'package:money_counter/Screens/authPage.dart';
import 'package:money_counter/Screens/historyPage.dart';
import 'package:money_counter/Screens/homePage.dart';

// GoRouter configuration

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryPage(
        isHome: false,
        appBarSize: 40,
      ),
    ),
  ],
);
