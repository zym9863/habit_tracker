import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/habit_provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 sqflite_common_ffi 以支持桌面端数据库
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitProvider()..init(),
      child: MaterialApp(
        title: 'Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
