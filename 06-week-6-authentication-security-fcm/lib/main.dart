import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pages/announcement_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  refreshListenable: routerRefresh,
  redirect: (context, state) {
    final loggedIn =
        ProviderScope.containerOf(context).read(authStateProvider).value ?? false;
    final onLogin = state.matchedLocation == AppRoutes.login;
    if (!loggedIn && !onLogin) return AppRoutes.login;
    if (loggedIn && onLogin) return AppRoutes.home;
    return null;
  },
  routes: [
    GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginPage()),
    GoRoute(path: AppRoutes.home, builder: (context, state) => const HomePage()),
    GoRoute(
      path: AppRoutes.announcement,
      builder: (_, state) => AnnouncementPage(
        id: state.pathParameters['id'] ?? '',
      ),
    ),
  ],
);

void main() {
  runApp(const ProviderScope(child: CampusNotifyApp()));
}

class CampusNotifyApp extends StatelessWidget {
  const CampusNotifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Campus Notify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      routerConfig: appRouter,
    );
  }
}
