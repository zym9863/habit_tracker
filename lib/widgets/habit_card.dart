import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isCompleted;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.onTap,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitColor = AppColors.fromHex(habit.color);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Slidable(
        key: ValueKey(habit.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit(),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: habitColor.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Category indicator
                  Container(
                    width: 8,
                    height: 80,
                    decoration: BoxDecoration(
                      color: habitColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Habit details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                habit.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: habitColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                habit.category,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: habitColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          habit.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Frequency
                            Row(
                              children: [
                                Icon(
                                  Icons.repeat,
                                  size: 16,
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  habit.frequency.toUpperCase(),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            // Streak
                            Row(
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${habit.currentStreak} day streak',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Complete button
                  IconButton(
                    onPressed: onComplete,
                    icon: Icon(
                      isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: isCompleted ? Colors.green : theme.disabledColor,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
