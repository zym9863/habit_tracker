class Habit {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String frequency; // daily, weekly, monthly
  final int targetCount; // target number of completions
  final int currentStreak;
  final int longestStreak;
  final DateTime createdAt;
  final String color; // color code as string
  final bool reminderEnabled;
  final String reminderTime; // stored as HH:MM format

  Habit({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.targetCount,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.createdAt,
    required this.color,
    this.reminderEnabled = false,
    this.reminderTime = '08:00',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'frequency': frequency,
      'targetCount': targetCount,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'reminderEnabled': reminderEnabled ? 1 : 0,
      'reminderTime': reminderTime,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      frequency: map['frequency'],
      targetCount: map['targetCount'],
      currentStreak: map['currentStreak'],
      longestStreak: map['longestStreak'],
      createdAt: DateTime.parse(map['createdAt']),
      color: map['color'],
      reminderEnabled: map['reminderEnabled'] == 1,
      reminderTime: map['reminderTime'],
    );
  }

  Habit copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? frequency,
    int? targetCount,
    int? currentStreak,
    int? longestStreak,
    DateTime? createdAt,
    String? color,
    bool? reminderEnabled,
    String? reminderTime,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      targetCount: targetCount ?? this.targetCount,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
