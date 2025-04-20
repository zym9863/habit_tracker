import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habit_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Create habits table
    await db.execute('''
      CREATE TABLE habits(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        frequency TEXT NOT NULL,
        targetCount INTEGER NOT NULL,
        currentStreak INTEGER NOT NULL,
        longestStreak INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        color TEXT NOT NULL,
        reminderEnabled INTEGER NOT NULL,
        reminderTime TEXT NOT NULL
      )
    ''');

    // Create habit logs table
    await db.execute('''
      CREATE TABLE habit_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habitId INTEGER NOT NULL,
        completedDate TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (habitId) REFERENCES habits (id) ON DELETE CASCADE
      )
    ''');
  }

  // Habit CRUD operations
  Future<int> insertHabit(Habit habit) async {
    final db = await database;
    return await db.insert('habits', habit.toMap());
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) {
      return Habit.fromMap(maps[i]);
    });
  }

  Future<Habit?> getHabit(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Habit.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    return await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Habit Log operations
  Future<int> insertHabitLog(HabitLog log) async {
    final db = await database;
    return await db.insert('habit_logs', log.toMap());
  }

  Future<List<HabitLog>> getHabitLogs(int habitId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habit_logs',
      where: 'habitId = ?',
      whereArgs: [habitId],
      orderBy: 'completedDate DESC',
    );

    return List.generate(maps.length, (i) {
      return HabitLog.fromMap(maps[i]);
    });
  }

  Future<List<HabitLog>> getHabitLogsByDate(DateTime date) async {
    final db = await database;
    final String dateString = date.toIso8601String().split('T')[0];
    
    final List<Map<String, dynamic>> maps = await db.query(
      'habit_logs',
      where: 'completedDate LIKE ?',
      whereArgs: ['$dateString%'],
    );

    return List.generate(maps.length, (i) {
      return HabitLog.fromMap(maps[i]);
    });
  }

  Future<int> deleteHabitLog(int id) async {
    final db = await database;
    return await db.delete(
      'habit_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Statistics and streak calculations
  Future<void> updateStreaks(int habitId) async {
    final db = await database;
    final habit = await getHabit(habitId);
    if (habit == null) return;

    final logs = await getHabitLogs(habitId);
    if (logs.isEmpty) return;

    // Sort logs by date
    logs.sort((a, b) => b.completedDate.compareTo(a.completedDate));

    // Calculate current streak
    int currentStreak = 0;
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));
    
    // Check if there's a log for today or yesterday to start the streak
    bool hasRecentLog = logs.any((log) => 
      log.completedDate.year == today.year && 
      log.completedDate.month == today.month && 
      log.completedDate.day == today.day) ||
      logs.any((log) => 
      log.completedDate.year == yesterday.year && 
      log.completedDate.month == yesterday.month && 
      log.completedDate.day == yesterday.day);
    
    if (hasRecentLog) {
      currentStreak = 1;
      DateTime lastDate = logs.first.completedDate;
      
      for (int i = 1; i < logs.length; i++) {
        DateTime currentDate = logs[i].completedDate;
        Duration difference = lastDate.difference(currentDate);
        
        // Check if logs are consecutive days
        if (difference.inDays == 1) {
          currentStreak++;
          lastDate = currentDate;
        } else {
          break;
        }
      }
    }

    // Update habit with new streak information
    int longestStreak = currentStreak > habit.longestStreak 
        ? currentStreak 
        : habit.longestStreak;
    
    await db.update(
      'habits',
      {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
      },
      where: 'id = ?',
      whereArgs: [habitId],
    );
  }
}
