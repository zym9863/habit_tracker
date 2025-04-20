import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../providers/habit_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/habit_progress_indicator.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit;
  const HabitDetailScreen({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    final logs = habit.id != null ? (provider.habitLogs[habit.id!] ?? []) : <HabitLog>[];
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(habit.description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            HabitProgressIndicator(
              completed: logs.length,
              target: habit.targetCount,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Completion Log', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: logs.isEmpty
                  ? const Center(child: Text('No completion records yet.'))
                  : ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, idx) {
                        final log = logs[idx];
                        return ListTile(
                          leading: const Icon(Icons.check_circle, color: Colors.green),
                          title: Text('${log.completedDate.year}-${log.completedDate.month.toString().padLeft(2, '0')}-${log.completedDate.day.toString().padLeft(2, '0')}'),
                          subtitle: log.notes.isNotEmpty ? Text(log.notes) : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
