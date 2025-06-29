import 'package:flutter/foundation.dart';
import 'app_state.dart';
import 'actions.dart';

class AppStore extends ChangeNotifier {
  AppState _state = AppState();

  AppState get state => _state;

  void dispatch(Action action) {
    if (action is AddTodoAction) {
      _state = _state.copyWith(todos: [..._state.todos, action.todo]);
    } else if (action is ToggleTodoAction) {
      final updatedTodos =
          _state.todos.map((todo) {
            if (todo.id == action.id) {
              return todo.copyWith(isCompleted: !todo.isCompleted);
            }
            return todo;
          }).toList();
      _state = _state.copyWith(todos: updatedTodos);
    } else if (action is DeleteTodoAction) {
      final updatedTodos =
          _state.todos.where((todo) => todo.id != action.id).toList();
      _state = _state.copyWith(todos: updatedTodos);
    } else if (action is AddTemplateAction) {
      _state = _state.copyWith(
        templates: [..._state.templates, action.template],
      );
    } else if (action is UpdateTemplateAction) {
      final updatedTemplates =
          _state.templates.map((template) {
            if (template['id'] == action.id) {
              return action.template;
            }
            return template;
          }).toList();
      _state = _state.copyWith(templates: updatedTemplates);
    } else if (action is DeleteTemplateAction) {
      final updatedTemplates =
          _state.templates
              .where((template) => template['id'] != action.id)
              .toList();
      _state = _state.copyWith(templates: updatedTemplates);
    } else if (action is AddToFavoritesAction) {
      // Check if already in favorites
      if (!_state.favorites.any((item) => item['id'] == action.item['id'])) {
        _state = _state.copyWith(favorites: [..._state.favorites, action.item]);
      }
    } else if (action is RemoveFromFavoritesAction) {
      final updatedFavorites =
          _state.favorites.where((item) => item['id'] != action.id).toList();
      _state = _state.copyWith(favorites: updatedFavorites);
    } else if (action is ToggleThemeAction) {
      _state = _state.copyWith(isDarkMode: !_state.isDarkMode);
    }

    notifyListeners();
  }

  // Helper methods for specific screens
  bool isFavorite(String id) {
    return _state.favorites.any((item) => item['id'] == id);
  }

  Map<String, dynamic>? getTemplateById(String id) {
    final matches = _state.templates.where((template) => template['id'] == id);
    return matches.isNotEmpty ? matches.first : null;
  }
}
