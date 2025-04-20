import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF4A6572);
  static const Color primaryLight = Color(0xFF7994A6);
  static const Color primaryDark = Color(0xFF1E3A4C);
  
  // Accent colors
  static const Color accent = Color(0xFF84FFFF);
  static const Color accentLight = Color(0xFFBBFFFF);
  static const Color accentDark = Color(0xFF4BCBCC);
  
  // Background colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Colors.white;
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Category colors
  static const List<Color> categoryColors = [
    Color(0xFFF44336), // Red
    Color(0xFF9C27B0), // Purple
    Color(0xFF3F51B5), // Indigo
    Color(0xFF03A9F4), // Light Blue
    Color(0xFF009688), // Teal
    Color(0xFF8BC34A), // Light Green
    Color(0xFFFFEB3B), // Yellow
    Color(0xFFFF9800), // Orange
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
  ];
  
  // Get color from hex string
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  
  // Convert color to hex string
  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}
