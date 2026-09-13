import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/models/todo.dart';

void main() {
  group('Todo Model', () {
    test('should create a Todo with required fields', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.description, '');
      expect(todo.isCompleted, false);
      expect(todo.createdAt, DateTime(2024, 1, 1));
    });

    test('should create a copy with updated fields using copyWith', () {
      final todo = Todo(
        id: '1',
        title: 'Original',
        description: 'Desc',
        createdAt: DateTime(2024, 1, 1),
      );

      final updated = todo.copyWith(
        title: 'Updated',
        isCompleted: true,
      );

      expect(updated.id, '1'); // unchanged
      expect(updated.title, 'Updated');
      expect(updated.description, 'Desc'); // unchanged
      expect(updated.isCompleted, true);
    });

    test('should have value equality', () {
      final date = DateTime(2024, 1, 1);
      final todo1 = Todo(id: '1', title: 'A', createdAt: date);
      final todo2 = Todo(id: '1', title: 'A', createdAt: date);
      final todo3 = Todo(id: '2', title: 'A', createdAt: date);

      expect(todo1, equals(todo2));
      expect(todo1, isNot(equals(todo3)));
    });
  });

  group('TodoListNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initially be in loading state', () {
      final state = container.read(todoListProvider);
      expect(state, isA<AsyncLoading<List<Todo>>>());
    });

    test('should load initial todos after build completes', () async {
      // Wait for the async build to complete
      await container.read(todoListProvider.future);
      final state = container.read(todoListProvider);

      expect(state, isA<AsyncData<List<Todo>>>());
      expect(state.valueOrNull, isNotNull);
      expect(state.valueOrNull!.length, 3);
    });

    test('should add a new todo', () async {
      // Wait for initial load
      await container.read(todoListProvider.future);

      // Add a todo
      await container
          .read(todoListProvider.notifier)
          .addTodo('New Task', description: 'A new task');

      final state = container.read(todoListProvider);
      expect(state.valueOrNull!.length, 4);
      expect(state.valueOrNull!.last.title, 'New Task');
      expect(state.valueOrNull!.last.description, 'A new task');
      expect(state.valueOrNull!.last.isCompleted, false);
    });

    test('should toggle a todo completion status', () async {
      // Wait for initial load
      await container.read(todoListProvider.future);
      final todos = container.read(todoListProvider).valueOrNull!;
      final firstTodo = todos[0];

      expect(firstTodo.isCompleted, false);

      // Toggle the first todo
      await container
          .read(todoListProvider.notifier)
          .toggleTodo(firstTodo.id);

      final updatedTodos = container.read(todoListProvider).valueOrNull!;
      final toggledTodo =
          updatedTodos.firstWhere((t) => t.id == firstTodo.id);

      expect(toggledTodo.isCompleted, true);
    });

    test('should delete a todo', () async {
      // Wait for initial load
      await container.read(todoListProvider.future);
      final todos = container.read(todoListProvider).valueOrNull!;
      final firstTodoId = todos[0].id;

      expect(todos.length, 3);

      // Delete the first todo
      await container
          .read(todoListProvider.notifier)
          .deleteTodo(firstTodoId);

      final updatedTodos = container.read(todoListProvider).valueOrNull!;
      expect(updatedTodos.length, 2);
      expect(updatedTodos.any((t) => t.id == firstTodoId), false);
    });

    test('should handle simulateError', () async {
      // Wait for initial load
      await container.read(todoListProvider.future);

      // Trigger simulated error
      await container.read(todoListProvider.notifier).simulateError();

      final state = container.read(todoListProvider);
      expect(state, isA<AsyncError<List<Todo>>>());
    });
  });

  group('TodoStatsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should calculate stats after todos are loaded', () async {
      await container.read(todoListProvider.future);

      final stats = container.read(todoStatsProvider);

      // Initial data has 3 todos, 1 completed
      expect(stats.total, 3);
      expect(stats.completed, 1);
      expect(stats.pending, 2);
    });

    test('should update stats when a todo is toggled', () async {
      await container.read(todoListProvider.future);
      final todos = container.read(todoListProvider).valueOrNull!;
      final pendingTodo = todos.firstWhere((t) => !t.isCompleted);

      await container
          .read(todoListProvider.notifier)
          .toggleTodo(pendingTodo.id);

      final stats = container.read(todoStatsProvider);
      expect(stats.completed, 2);
      expect(stats.pending, 1);
    });
  });

  group('FilteredTodosProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should return all todos when filter is all', () async {
      await container.read(todoListProvider.future);

      container.read(todoFilterProvider.notifier).state = TodoFilter.all;
      final filtered = container.read(filteredTodosProvider);

      expect(filtered.length, 3);
    });

    test('should return only completed todos when filter is completed',
        () async {
      await container.read(todoListProvider.future);

      container.read(todoFilterProvider.notifier).state = TodoFilter.completed;
      final filtered = container.read(filteredTodosProvider);

      expect(filtered.length, 1);
      expect(filtered.every((t) => t.isCompleted), true);
    });

    test('should return only pending todos when filter is pending', () async {
      await container.read(todoListProvider.future);

      container.read(todoFilterProvider.notifier).state = TodoFilter.pending;
      final filtered = container.read(filteredTodosProvider);

      expect(filtered.length, 2);
      expect(filtered.every((t) => !t.isCompleted), true);
    });
  });
}
