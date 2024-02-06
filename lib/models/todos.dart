class Todo {
  String id;
  String title;
  String description;
  bool completed;

  Todo(
      {required this.title, required this.description, this.completed = false, required this.id});

factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'].toString(), // Convert the id to a String
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

}
