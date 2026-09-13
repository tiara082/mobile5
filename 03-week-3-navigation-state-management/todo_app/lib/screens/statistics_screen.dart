import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/todo_provider.dart';

/// Statistics screen showing todo completion stats and charts.
///
/// Demonstrates:
/// - `context.go` vs `context.push` navigation pattern
/// - Derived providers (todoStatsProvider)
/// - ConsumerWidget with Riverpod
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(todoStatsProvider);
    final todosAsync = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Statistik'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // context.pop() pops the current route from the navigation stack.
            // This works because we used context.push('/stats') to navigate here.
            if (context.canPop()) {
              context.pop();
            } else {
              // Fallback: use context.go to replace the entire stack
              context.go('/');
            }
          },
        ),
      ),
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.read(todoListProvider.notifier).refresh(),
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
        data: (todos) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Total',
                      value: stats.total.toString(),
                      icon: Icons.list_alt,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Selesai',
                      value: stats.completed.toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Belum',
                      value: stats.pending.toString(),
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Progress bar
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress Penyelesaian',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: stats.total > 0
                              ? stats.completed / stats.total
                              : 0,
                          minHeight: 20,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(
                              stats.total > 0
                                  ? stats.completed / stats.total
                                  : 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stats.total > 0
                            ? '${(stats.completed / stats.total * 100).toStringAsFixed(1)}% selesai'
                            : 'Belum ada tugas',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Recent todos
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar Tugas',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      if (todos.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              'Belum ada tugas.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ...todos.map(
                          (todo) => ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              todo.isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color:
                                  todo.isCompleted ? Colors.green : Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: todo.isCompleted ? Colors.grey : null,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Navigation info card
              Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Navigasi Info',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• context.push("/stats") → menambah halaman ke stack\n'
                        '• context.go("/") → mengganti seluruh stack\n'
                        '• context.pop() → kembali ke halaman sebelumnya',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // FAB to navigate back to home using context.go (replaces stack)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // context.go replaces the entire navigation stack.
          // Unlike context.push, user can't go "back" to this page.
          context.go('/');
        },
        icon: const Icon(Icons.home),
        label: const Text('Ke Beranda (go)'),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.5) return Colors.blue;
    if (progress >= 0.3) return Colors.orange;
    return Colors.red;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
