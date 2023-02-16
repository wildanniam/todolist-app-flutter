class Todo {
  final String id;
  final String title;
  final String note;
  final DateTime? dueDate;
  final bool completed;
  final double latitude;
  final double longitude;

  Todo(
      {required this.id,
      required this.title,
      this.note = '',
      this.dueDate,
      this.completed = false,
      this.latitude = 0.0,
      this.longitude = 0.0});

  Todo copyWith(
      {String? id,
      String? title,
      String? note,
      DateTime? dueDate,
      bool? completed,
      double? latitude,
      double? longitude}) {
    if (dueDate != null) {
      if (dueDate.compareTo(DateTime(0)) == 0) {
        dueDate = null;
      }
    } else {
      dueDate = this.dueDate;
    }

    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueDate: dueDate,
      completed: completed ?? this.completed,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
