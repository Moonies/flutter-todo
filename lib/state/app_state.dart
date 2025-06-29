class AppState {
  // Todo data
  final List<TodoItem> todos;

  // Generator data
  final List<Map<String, dynamic>> templates;

  // Favorites data
  final List<Map<String, dynamic>> favorites;

  // App settings
  final bool isDarkMode;

  AppState({
    this.todos = const [],
    this.templates = const [],
    this.favorites = const [],
    this.isDarkMode = false,
  });

  AppState copyWith({
    List<TodoItem>? todos,
    List<Map<String, dynamic>>? templates,
    List<Map<String, dynamic>>? favorites,
    bool? isDarkMode,
  }) {
    return AppState(
      todos: todos ?? this.todos,
      templates: templates ?? this.templates,
      favorites: favorites ?? this.favorites,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

// Your TodoItem model (already exists in your project)
class TodoItem {
  final String id;
  final String title;
  final bool isCompleted;

  TodoItem({required this.id, required this.title, required this.isCompleted});

  TodoItem copyWith({String? id, String? title, bool? isCompleted}) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
