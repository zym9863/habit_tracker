class HabitLog {
  final int? id;
  final int habitId;
  final DateTime completedDate;
  final String notes;

  HabitLog({
    this.id,
    required this.habitId,
    required this.completedDate,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'completedDate': completedDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory HabitLog.fromMap(Map<String, dynamic> map) {
    return HabitLog(
      id: map['id'],
      habitId: map['habitId'],
      completedDate: DateTime.parse(map['completedDate']),
      notes: map['notes'],
    );
  }
}
