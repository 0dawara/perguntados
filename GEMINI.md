# Gemini CLI Guidelines for Perguntados

This file contains the project-specific rules, architecture, and conventions for the Perguntados Flutter project.

## Interaction Guidelines
- **User Persona:** Assume familiarity with programming but potential newness to Dart.
- **Explanations:** Provide explanations for Dart-specific features (null safety, futures, streams).
- **Clarification:** Ask for clarification if requests are ambiguous or target platform is unclear.
- **Dependencies:** Explain benefits when suggesting new packages from pub.dev.
- **Tools:** Use `dart_format` for formatting, `dart_fix` for common error fixes, and `analyze_files` for linting.

## Project Structure
- Standard Flutter project structure with `lib/main.dart` as entry point.

## Flutter Style Guide
- **SOLID Principles:** Apply throughout the codebase.
- **Concise & Declarative:** Prefer functional and declarative patterns.
- **Composition:** Favor composition over inheritance.
- **Immutability:** Use immutable data structures and widgets (`StatelessWidget`).
- **State Management:** Separate ephemeral and app state. Default to built-in solutions (Streams, Futures, ValueNotifier, ChangeNotifier).
- **Navigation:** Use `go_router` for declarative routing.

## Package Management
- Use the `pub` tool for managing dependencies.
- **Search:** Use `pub_dev_search` for finding stable packages.
- **Adding:** Use `pub add` (e.g., `pub add dev:<pkg>` for dev dependencies).

## Code Quality
- **Separation of Concerns:** UI logic separate from business logic.
- **Naming:** Meaningful, descriptive names; avoid abbreviations.
- **Styling:** Max 80 characters per line. `PascalCase` for classes, `camelCase` for members, `snake_case` for files.
- **Functions:** Short, single-purpose (strive for < 20 lines).
- **Testing:** Design for testability; inject fakes/stubs for system dependencies.
- **Logging:** Use `package:logging` or `dart:developer.log` instead of `print`.

## Architecture & Layers
- **MVC/MVVM:** Defined Model, View, and ViewModel/Controller roles.
- **Logical Layers:**
  - `Presentation`: Widgets and screens.
  - `Domain`: Business logic.
  - `Data`: Models and API clients.
  - `Core`: Shared utilities and extensions.
- **Feature-based Organization:** Group by feature for larger modules.

## Routing (GoRouter)
- Configure `MaterialApp.router` with `GoRouter`.
- Use `redirect` for authentication flows.
- Use `Navigator` only for short-lived views (dialogs).

## Data Handling & Serialization
- Use `json_serializable` and `json_annotation`.
- Use `fieldRename: FieldRename.snake` for JSON conversion.

## Code Generation
- Use `build_runner` for tasks like `json_serializable`.
- Command: `dart run build_runner build --delete-conflicting-outputs`.

## Testing Best Practices
- **Tools:** Use `run_tests` MCP tool.
- **Patterns:** Arrange-Act-Assert / Given-When-Then.
- **Mocks:** Prefer fakes/stubs over mocks; if needed, use `mockito` or `mocktail`.
- **Assertions:** Prefer `package:checks` over default matchers.

## Visual Design & Theming
- **Material 3:** Use `ColorScheme.fromSeed()` for harmonious palettes.
- **Theme Extensions:** Use `ThemeExtension` for custom design tokens.
- **Typography:** Use `google_fonts`.
- **Accessibility:** Ensure 4.5:1 contrast, dynamic text scaling, and semantic labels.
- **Responsiveness:** Use `LayoutBuilder` or `MediaQuery`.
