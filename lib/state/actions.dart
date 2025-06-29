import 'app_state.dart';

abstract class Action {}

// Todo Actions
class AddTodoAction extends Action {
  final TodoItem todo;
  AddTodoAction(this.todo);
}

class ToggleTodoAction extends Action {
  final String id;
  ToggleTodoAction(this.id);
}

class DeleteTodoAction extends Action {
  final String id;
  DeleteTodoAction(this.id);
}

// Template Actions
class AddTemplateAction extends Action {
  final Map<String, dynamic> template;
  AddTemplateAction(this.template);
}

class UpdateTemplateAction extends Action {
  final String id;
  final Map<String, dynamic> template;
  UpdateTemplateAction(this.id, this.template);
}

class DeleteTemplateAction extends Action {
  final String id;
  DeleteTemplateAction(this.id);
}

// Favorite Actions
class AddToFavoritesAction extends Action {
  final Map<String, dynamic> item;
  AddToFavoritesAction(this.item);
}

class RemoveFromFavoritesAction extends Action {
  final String id;
  RemoveFromFavoritesAction(this.id);
}

// Theme Actions
class ToggleThemeAction extends Action {}
