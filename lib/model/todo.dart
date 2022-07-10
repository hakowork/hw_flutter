class Todos {
  final int totalResult;
  final List<Todo> todos;

  const Todos({
    required this.totalResult,
    required this.todos
  });

  Todos.fromJson(Map<String, dynamic> json)
    : todos = List.from(json['todos']).map((todo) => Todo.fromJson(todo)).toList(),
      totalResult = 0;
}

class Todo {
  final int id;
  final String name;

  const Todo({
    required this.id,
    required this.name
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      name: json['name']
    );
  }
}