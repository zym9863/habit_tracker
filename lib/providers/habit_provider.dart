import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class HabitProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();
  
  List<Habit> _habits = [];
  Map<int, List<HabitLog>> _habitLogs = {};
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  Map<int, List<HabitLog>> get habitLogs => _habitLogs;
  bool get isLoading => _isLoading;

  // Initialize the provider
  Future<void> init() async {
    await _notificationService.init();
    await loadHabits();
  }

  // Load all habits from the database
  Future<void> loadHabits() async {
    _setLoading(true);
    try {
      _habits = await _databaseService.getHabits();
      
      // Load logs for each habit
      for (var habit in _habits) {
        if (habit.id != null) {
          _habitLogs[habit.id!] = await _databaseService.getHabitLogs(habit.id!);
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading habits: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add a new habit
  Future<void> addHabit(Habit habit) async {
    _setLoading(true);
    try {
      final id = await _databaseService.insertHabit(habit);
      final newHabit = habit.copyWith(id: id);
      _habits.add(newHabit);
      _habitLogs[id] = [];
      
      // Schedule notification if enabled
      if (newHabit.reminderEnabled) {
        await _notificationService.scheduleHabitReminder(newHabit);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding habit: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing habit
  Future<void> updateHabit(Habit habit) async {
    _setLoading(true);
    try {
      await _databaseService.updateHabit(habit);
      
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = habit;
      }
      
      // Update notification
      if (habit.reminderEnabled) {
        await _notificationService.scheduleHabitReminder(habit);
      } else if (habit.id != null) {
        await _notificationService.cancelHabitReminder(habit.id!);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating habit: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Delete a habit
  Future<void> deleteHabit(int id) async {
    _setLoading(true);
    try {
      await _databaseService.deleteHabit(id);
      _habits.removeWhere((habit) => habit.id == id);
      _habitLogs.remove(id);
      
      // Cancel notification
      await _notificationService.cancelHabitReminder(id);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting habit: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Log a habit completion
  Future<void> logHabitCompletion(int habitId, {String notes = ''}) async {
    _setLoading(true);
    try {
      final log = HabitLog(
        habitId: habitId,
        completedDate: DateTime.now(),
        notes: notes,
      );
      
      final logId = await _databaseService.insertHabitLog(log);
      final newLog = HabitLog(
        id: logId,
        habitId: habitId,
        completedDate: log.completedDate,
        notes: log.notes,
      );
      
      if (_habitLogs.containsKey(habitId)) {
        _habitLogs[habitId]!.add(newLog);
      } else {
        _habitLogs[habitId] = [newLog];
      }
      
      // Update streaks
      await _databaseService.updateStreaks(habitId);
      await loadHabits(); // Reload to get updated streak info
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging habit completion: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Delete a habit log
  Future<void> deleteHabitLog(int logId, int habitId) async {
    _setLoading(true);
    try {
      await _databaseService.deleteHabitLog(logId);
      
      if (_habitLogs.containsKey(habitId)) {
        _habitLogs[habitId]!.removeWhere((log) => log.id == logId);
      }
      
      // Update streaks after deleting a log
      await _databaseService.updateStreaks(habitId);
      await loadHabits(); // Reload to get updated streak info
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting habit log: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get logs for a specific date
  Future<List<HabitLog>> getLogsForDate(DateTime date) async {
    try {
      return await _databaseService.getHabitLogsByDate(date);
    } catch (e) {
      debugPrint('Error getting logs for date: $e');
      return [];
    }
  }

  // Get habits completed on a specific date
  Future<List<Habit>> getHabitsCompletedOnDate(DateTime date) async {
    try {
      final logs = await _databaseService.getHabitLogsByDate(date);
      final habitIds = logs.map((log) => log.habitId).toSet();
      return _habits.where((habit) => habitIds.contains(habit.id)).toList();
    } catch (e) {
      debugPrint('Error getting habits completed on date: $e');
      return [];
    }
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
