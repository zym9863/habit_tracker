import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_progress_indicator.dart';
import 'habit_detail_screen.dart';
import 'add_edit_habit_screen.dart';
import '../models/habit_log.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Health',
    'Fitness',
    'Productivity',
    'Learning',
    'Mindfulness',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load habits when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitProvider>(context, listen: false).loadHabits();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final theme = Theme.of(context);

    // Filter habits by category if needed
    final habits =
        _selectedCategory == 'All'
            ? habitProvider.habits
            : habitProvider.habits
                .where((h) => h.category == _selectedCategory)
                .toList();

    // Calculate overall progress
    final totalHabits = habits.length;
    final completedToday =
        habitProvider.habits.where((habit) {
          if (habit.id == null) return false;
          final logs = habitProvider.habitLogs[habit.id!] ?? [];
          final today = DateTime.now();
          return logs.any(
            (log) =>
                log.completedDate.year == today.year &&
                log.completedDate.month == today.month &&
                log.completedDate.day == today.day,
          );
        }).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Today'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body:
          habitProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Progress summary
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Progress',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            HabitProgressIndicator(
                              completed: completedToday,
                              target: totalHabits,
                              color: AppColors.success,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatCard(
                                  context,
                                  'Total Habits',
                                  totalHabits.toString(),
                                  Icons.list_alt,
                                  AppColors.primary,
                                ),
                                _buildStatCard(
                                  context,
                                  'Completed',
                                  completedToday.toString(),
                                  Icons.check_circle_outline,
                                  AppColors.success,
                                ),
                                _buildStatCard(
                                  context,
                                  'Remaining',
                                  (totalHabits - completedToday).toString(),
                                  Icons.pending_actions,
                                  AppColors.warning,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Category filter
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              }
                            },
                            backgroundColor: theme.cardColor,
                            selectedColor: theme.colorScheme.primary
                                .withOpacity(0.2),
                            labelStyle: TextStyle(
                              color:
                                  isSelected
                                      ? theme.colorScheme.primary
                                      : theme.textTheme.bodyMedium?.color,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Habits list
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // All habits
                        _buildHabitsList(habits, habitProvider),

                        // Today's habits
                        _buildHabitsList(
                          habits
                              .where((habit) => _shouldShowForToday(habit))
                              .toList(),
                          habitProvider,
                        ),

                        // Completed habits
                        _buildHabitsList(
                          habits
                              .where(
                                (habit) =>
                                    _isCompletedToday(habit, habitProvider),
                              )
                              .toList(),
                          habitProvider,
                          showCompleted: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditHabitScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
      ),
    );
  }

  Widget _buildHabitsList(
    List<Habit> habits,
    HabitProvider habitProvider, {
    bool showCompleted = false,
  }) {
    return habits.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                showCompleted ? Icons.check_circle_outline : Icons.add_task,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                showCompleted ? 'No completed habits yet' : 'No habits found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                showCompleted
                    ? 'Complete a habit to see it here'
                    : 'Add a new habit to get started',
                style: TextStyle(color: Colors.grey.withOpacity(0.6)),
              ),
            ],
          ),
        )
        : ListView.builder(
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            final isCompleted = _isCompletedToday(habit, habitProvider);

            return HabitCard(
              habit: habit,
              isCompleted: isCompleted,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitDetailScreen(habit: habit),
                  ),
                );
              },
              onComplete: () async {
                if (isCompleted) {
                  // Find and delete the log for today
                  if (habit.id != null) {
                    final logs = habitProvider.habitLogs[habit.id!] ?? [];
                    final today = DateTime.now();
                    final todayLog = logs.firstWhere(
                      (log) =>
                          log.completedDate.year == today.year &&
                          log.completedDate.month == today.month &&
                          log.completedDate.day == today.day,
                      orElse:
                          () => HabitLog(
                            id: null,
                            habitId: habit.id!,
                            completedDate: today,
                          ),
                    );

                    if (todayLog.id != null) {
                      await habitProvider.deleteHabitLog(
                        todayLog.id!,
                        habit.id!,
                      );
                    }
                  }
                } else {
                  // Log completion for today
                  if (habit.id != null) {
                    await habitProvider.logHabitCompletion(habit.id!);
                  }
                }
              },
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditHabitScreen(habit: habit),
                  ),
                );
              },
              onDelete: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Delete Habit'),
                        content: Text(
                          'Are you sure you want to delete "${habit.title}"? This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              if (habit.id != null) {
                                habitProvider.deleteHabit(habit.id!);
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                );
              },
            );
          },
        );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _shouldShowForToday(Habit habit) {
    final now = DateTime.now();
    final weekday = now.weekday;

    switch (habit.frequency.toLowerCase()) {
      case 'daily':
        return true;
      case 'weekly':
        // For weekly habits, show on Monday
        return weekday == 1;
      case 'monthly':
        // For monthly habits, show on the 1st day of the month
        return now.day == 1;
      default:
        return true;
    }
  }

  bool _isCompletedToday(Habit habit, HabitProvider provider) {
    if (habit.id == null) return false;

    final logs = provider.habitLogs[habit.id!] ?? [];
    final today = DateTime.now();

    return logs.any(
      (log) =>
          log.completedDate.year == today.year &&
          log.completedDate.month == today.month &&
          log.completedDate.day == today.day,
    );
  }
}
