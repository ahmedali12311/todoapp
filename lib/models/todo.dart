class Todo {
  String title;
  bool isDone;
  DateTime? reminder;

  Todo({
    required this.title,
    this.isDone = false,
    this.reminder,
  });
}
