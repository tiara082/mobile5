import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/todo_provider.dart';

/// Screen displaying the list of todos with filter chips.
///
/// Uses [ConsumerWidget] to reactively rebuild when todo state changes.
/// Demonstrates [AsyncValue] pattern matching for loading/error/data states.
class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);
    final filter = ref.watch(todoFilterProvider);
    final filteredTodos = ref.watch(filteredTodosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 ToDo App'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // Navigate to statistics page using context.push
          // (push adds to navigation stack, allowing back navigation)
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Statistik',
            onPressed: () => context.push('/stats'),
          ),
          // Simulate error button for demo
          IconButton(
            icon: const Icon(Icons.error_outline),
            tooltip: 'Simulasi Error',
            onPressed: () {
              ref.read(todoListProvider.notifier).simulateError();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Semua',
                  selected: filter == TodoFilter.all,
                  onSelected: () => ref.read(todoFilterProvider.notifier).state =
                      TodoFilter.all,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Selesai',
                  selected: filter == TodoFilter.completed,
                  onSelected: () => ref.read(todoFilterProvider.notifier).state =
                      TodoFilter.completed,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Belum',
                  selected: filter == TodoFilter.pending,
                  onSelected: () => ref.read(todoFilterProvider.notifier).state =
                      TodoFilter.pending,
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Todo list with AsyncValue pattern matching
          Expanded(
            child: todosAsync.when(
              // LOADING STATE
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Memuat data...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // ERROR STATE
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Terjadi Kesalahan',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {
                          ref.read(todoListProvider.notifier).refresh();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),

              // SUCCESS/DATA STATE
              data: (_) {
                if (filteredTodos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          filter == TodoFilter.all
                              ? 'Belum ada tugas.\nTambahkan tugas baru!'
                              : 'Tidak ada tugas dengan filter ini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(todoListProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return _TodoTile(todo: todo);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

/// Individual todo list tile widget.
class _TodoTile extends ConsumerWidget {
  final dynamic todo;

  const _TodoTile({required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hapus Tugas?'),
            content: Text('Yakin ingin menghapus "${todo.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(todoListProvider.notifier).deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${todo.title}" dihapus'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) {
              ref.read(todoListProvider.notifier).toggleTodo(todo.id);
            },
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration:
                  todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted ? Colors.grey : null,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: todo.description.isNotEmpty
              ? Text(
                  todo.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: todo.isCompleted ? Colors.grey[400] : Colors.grey[600],
                  ),
                )
              : null,
          trailing: Icon(
            todo.isCompleted
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: todo.isCompleted ? Colors.green : Colors.grey,
          ),
        ),
      ),
    );
  }
}

/// Filter chip widget.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}
