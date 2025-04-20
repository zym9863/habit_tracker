[Switch to Chinese (中文版)](README.md)

# Habit Tracker

A cross-platform habit tracking app to help users build and maintain good habits.

## Features

- **Habit Management**: Create, edit, and delete personal habits
- **Category System**: Organize habits by categories such as Health, Fitness, Productivity, Learning, Mindfulness, etc.
- **Habit Tracking**: Record completion and view progress
- **Statistics & Analysis**: View current streak and longest streak records
- **Reminder Notifications**: Set scheduled reminders to avoid forgetting habits
- **Multi-platform Support**: Available for Android, iOS, Windows, macOS, and Linux
- **Customizable Interface**: Choose different colors for each habit to personalize your tracking experience

## Technical Architecture

- **Frontend Framework**: Flutter (^3.7.2)
- **State Management**: Provider
- **Local Database**: SQLite (sqflite)
- **Notification System**: flutter_local_notifications
- **UI Components**: Material Design + Custom Components

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/               # Data models
│   ├── habit.dart        # Habit model
│   └── habit_log.dart    # Habit log model
├── providers/            # State management
│   └── habit_provider.dart
├── screens/              # App screens
│   ├── add_edit_habit_screen.dart
│   ├── habit_detail_screen.dart
│   └── home_screen.dart
├── services/             # Service layer
│   ├── database_service.dart
│   └── notification_service.dart
├── utils/                # Utilities
│   ├── app_colors.dart
│   └── app_theme.dart
└── widgets/              # Reusable components
    ├── color_picker.dart
    ├── habit_card.dart
    └── habit_progress_indicator.dart
```

## Installation Guide

### Prerequisites

- Flutter SDK (^3.7.2)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation Steps

1. Clone the repository
```bash
git clone https://github.com/zym9863/habit_tracker.git
cd habit_tracker
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## User Guide

1. **Create a New Habit**: Tap the "+" button on the main page and fill in the habit details
2. **Record Completion**: Tap the complete button on the habit card on the main page
3. **View Details**: Tap the habit card to view detailed statistics and history
4. **Edit Habit**: Tap the edit button on the detail page to modify habit settings
5. **Set Reminders**: Enable reminders and set the time when creating or editing a habit

## Contribution Guide

Issues and feature requests are welcome. If you wish to contribute code, please open an issue to discuss your intended changes first.

## License

This project is licensed under the MIT License - see the LICENSE file for details.