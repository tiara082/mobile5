# 03-week-3-navigation-state-management

## Reflection

### When is `setState` sufficient, and when should state be moved to Riverpod?

`setState` is sufficient for local, short-lived state that is used by only one widget, such as form input, a selected tab, or a local animation. State should be moved to Riverpod when it must be shared across multiple widgets or screens, survives widget rebuilds, depends on asynchronous operations, or needs derived values and centralized business logic. In this app, the todo list belongs in Riverpod because the list is used by the list screen, statistics screen, and add/delete actions.

### What is the difference between `context.go` and `context.push`, and when should each be used?

`context.go` changes the current location and replaces the navigation state. It is appropriate for top-level destinations, such as switching between the todo list and statistics screens, when the previous page does not need to remain in the back stack. `context.push` adds a new route to the navigation stack. It is appropriate for temporary or secondary screens, such as opening the add-todo form, when the user should be able to return to the previous screen with the back button.

### How does `AsyncValue` prevent bugs compared with three separate booleans?

`AsyncValue` represents an asynchronous operation as one explicit state: loading, data, or error. This prevents contradictory combinations such as `isLoading == true` and `hasError == true` at the same time. With three separate booleans, invalid or incomplete combinations are possible and every widget must remember to interpret them correctly. `AsyncValue.when` also makes the UI handle all supported states explicitly, which reduces inconsistent loading, success, and error displays.

### Which parts of the AI-generated result did you improve, and why?

I improved the AI-generated result in several areas:

- **Todo model:** Added immutability through `copyWith`, value equality, and `hashCode`, making state updates predictable and easier to test.
- **State management:** Replaced basic state handling with a Riverpod `AsyncNotifier`, including loading, error, refresh, and CRUD operations.
- **Filtering and statistics:** Added derived providers so filtering and summary values are computed from the single todo-list source of truth instead of duplicated in the UI.
- **Navigation:** Added multiple routes and used both `go` and `push` to demonstrate their different navigation behaviors.
- **Error handling:** Added simulated errors and retry behavior so the error state is observable and recoverable.
- **Testing:** Expanded the tests to cover the model, CRUD operations, filtering, statistics, and asynchronous state transitions.

These improvements make the application more maintainable, demonstrate the intended Week 3 concepts, and make its behavior easier to verify than the original basic AI output.
