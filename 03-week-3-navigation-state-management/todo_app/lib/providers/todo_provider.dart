import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';

const _uuid = Uuid();

/// Simulates a network/database delay for async operations.
Future<void> _simulateDelay() async {
  await Future.delayed(const Duration(milliseconds: 800));
}

/// Simulates fetching initial todos from a remote source.
/// Randomly throws an error ~20% of the time to demonstrate error handling.
Future<List<Todo>> _fetchInitialTodos() async {
  await Future.delayed(const Duration(seconds: 2));

  // Simulate occasional network errors
  // Uncomment the lines below to test error state:
  // if (DateTime.now().millisecond % 5 == 0) {
  //   throw Exception('Gagal memuat data dari server. Coba lagi.');
  // }

  return [
    Todo(
      id: _uuid.v4(),
      title: 'Belajar Flutter Navigation',
      description: 'Pelajari GoRouter untuk navigasi deklaratif di Flutter.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Todo(
      id: _uuid.v4(),
      title: 'Implementasi Riverpod',
      description: 'Gunakan Notifier dan AsyncNotifier untuk state management.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isCompleted: true,
    ),
    Todo(
      id: _uuid.v4(),
      title: 'Tulis Unit Test',
      description: 'Buat minimal 1 unit test yang lulus untuk provider.',
      createdAt: DateTime.now(),
    ),
  ];
}

/// AsyncNotifier that manages the list of todos with async operations.
///
/// Uses [AsyncValue] to represent loading, error, and data states.
/// All mutations (add, toggle, delete) simulate async operations.
class TodoListNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // Simulate fetching data from a remote source
    return _fetchInitialTodos();
  }

  /// Adds a new todo with the given [title] and [description].
  /// Simulates an async operation (e.g., saving to server).
  Future<void> addTodo(String title, {String description = ''}) async {
    // Keep current state while performing the operation
    final previousState = state.valueOrNull ?? [];
    
    // Set loading state
    state = const AsyncValue.loading();

    try {
      await _simulateDelay();

      final newTodo = Todo(
        id: _uuid.v4(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );

      state = AsyncValue.data([...previousState, newTodo]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Toggles the completion status of the todo with the given [id].
  Future<void> toggleTodo(String id) async {
    final previousState = state.valueOrNull ?? [];
    state = const AsyncValue.loading();

    try {
      await _simulateDelay();

      final updatedTodos = previousState.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList();

      state = AsyncValue.data(updatedTodos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Deletes the todo with the given [id].
  Future<void> deleteTodo(String id) async {
    final previousState = state.valueOrNull ?? [];
    state = const AsyncValue.loading();

    try {
      await _simulateDelay();

      final updatedTodos =
          previousState.where((todo) => todo.id != id).toList();

      state = AsyncValue.data(updatedTodos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Simulates a forced error to demonstrate error state handling.
  Future<void> simulateError() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncValue.error(
      Exception('Simulasi error: Koneksi ke server gagal!'),
      StackTrace.current,
    );
  }

  /// Refreshes the todo list by re-fetching from the simulated source.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final todos = await _fetchInitialTodos();
      state = AsyncValue.data(todos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// The main provider for the todo list.
final todoListProvider =
    AsyncNotifierProvider<TodoListNotifier, List<Todo>>(TodoListNotifier.new);

/// Derived provider: counts of completed and pending todos.
final todoStatsProvider = Provider<({int total, int completed, int pending})>((ref) {
  final todosAsync = ref.watch(todoListProvider);
  final todos = todosAsync.valueOrNull ?? [];
  final completed = todos.where((t) => t.isCompleted).length;
  return (
    total: todos.length,
    completed: completed,
    pending: todos.length - completed,
  );
});

/// Derived provider: filters todos by completion status.
enum TodoFilter { all, completed, pending }

final todoFilterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todosAsync = ref.watch(todoListProvider);
  final filter = ref.watch(todoFilterProvider);
  final todos = todosAsync.valueOrNull ?? [];

  switch (filter) {
    case TodoFilter.all:
      return todos;
    case TodoFilter.completed:
      return todos.where((t) => t.isCompleted).toList();
    case TodoFilter.pending:
      return todos.where((t) => !t.isCompleted).toList();
  }
});
