import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/habit.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> init() async {
    tz_data.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // Handle notification tapped logic here
      },
    );
  }

  Future<void> scheduleHabitReminder(Habit habit) async {
    if (!habit.reminderEnabled) return;
    
    // Parse reminder time
    final timeParts = habit.reminderTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    // Create notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_reminders',
      'Habit Reminders',
      channelDescription: 'Reminders for your habits',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    
    // Schedule notification
    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    
    // If the time has already passed today, schedule for tomorrow
    final effectiveDate = scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      habit.id ?? 0,
      'Time for ${habit.title}',
      'Don\'t forget to complete your habit today!',
      tz.TZDateTime.from(effectiveDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: habit.id.toString(),
    );
  }

  Future<void> cancelHabitReminder(int habitId) async {
    // 只在Android/iOS上调用，桌面端/Web直接跳过
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await flutterLocalNotificationsPlugin.cancel(habitId);
    }
  }
}
