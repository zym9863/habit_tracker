[Switch to English (English Version)](README_EN.md)

# Habit Tracker

一个跨平台的习惯追踪应用，帮助用户建立和维持良好习惯。

## 功能特点

- **习惯管理**：创建、编辑和删除个人习惯
- **分类系统**：按健康、健身、生产力、学习、正念等类别组织习惯
- **习惯追踪**：记录完成情况并查看进度
- **统计分析**：查看当前连续完成次数和最长连续记录
- **提醒通知**：设置定时提醒，避免忘记执行习惯
- **多平台支持**：适用于Android、iOS、Windows、macOS和Linux
- **自定义界面**：为每个习惯选择不同颜色，个性化您的追踪体验

## 技术架构

- **前端框架**：Flutter (^3.7.2)
- **状态管理**：Provider
- **本地数据库**：SQLite (sqflite)
- **通知系统**：flutter_local_notifications
- **UI组件**：Material Design + 自定义组件

## 项目结构

```
lib/
├── main.dart              # 应用入口点
├── models/               # 数据模型
│   ├── habit.dart        # 习惯模型
│   └── habit_log.dart    # 习惯记录模型
├── providers/            # 状态管理
│   └── habit_provider.dart
├── screens/              # 应用界面
│   ├── add_edit_habit_screen.dart
│   ├── habit_detail_screen.dart
│   └── home_screen.dart
├── services/             # 服务层
│   ├── database_service.dart
│   └── notification_service.dart
├── utils/                # 工具类
│   ├── app_colors.dart
│   └── app_theme.dart
└── widgets/              # 可复用组件
    ├── color_picker.dart
    ├── habit_card.dart
    └── habit_progress_indicator.dart
```

## 安装说明

### 前提条件

- Flutter SDK (^3.7.2)
- Dart SDK
- Android Studio / Xcode (用于移动端开发)

### 安装步骤

1. 克隆仓库
```bash
git clone https://github.com/zym9863/habit_tracker.git
cd habit_tracker
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行应用
```bash
flutter run
```

## 使用指南

1. **创建新习惯**：点击主页面的"+"按钮，填写习惯详情
2. **记录完成情况**：在主页面点击习惯卡片上的完成按钮
3. **查看详情**：点击习惯卡片查看详细统计和历史记录
4. **编辑习惯**：在详情页面点击编辑按钮修改习惯设置
5. **设置提醒**：创建或编辑习惯时启用提醒功能并设置时间

## 贡献指南

欢迎提交问题报告和功能请求。如果您想贡献代码，请先开issue讨论您想要更改的内容。

## 许可证

本项目采用MIT许可证 - 详情请参阅LICENSE文件
