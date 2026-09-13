import 'package:go_router/go_router.dart';
import '../screens/todo_list_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/add_todo_screen.dart';

/// Application router configuration using GoRouter.
///
/// Routes:
/// - `/`          → TodoListScreen (daftar tugas)
/// - `/stats`     → StatisticsScreen (halaman statistik)
/// - `/add`       → AddTodoScreen (tambah tugas baru)
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const TodoListScreen(),
    ),
    GoRoute(
      path: '/stats',
      name: 'statistics',
      builder: (context, state) => const StatisticsScreen(),
    ),
    GoRoute(
      path: '/add',
      name: 'add',
      builder: (context, state) => const AddTodoScreen(),
    ),
  ],
);
