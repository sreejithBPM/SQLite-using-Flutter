class Task {
  int? id;
  String title;
  String description;

  Task({ this.id, required this.title, required this.description});

  Task.copy(Task task)
      : id = task.id,
        title = task.title,
        description = task.description;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}