import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HabitProgressIndicator extends StatelessWidget {
  final int completed;
  final int target;
  final Color color;
  final double height;
  final bool showPercentage;

  const HabitProgressIndicator({
    Key? key,
    required this.completed,
    required this.target,
    this.color = AppColors.primary,
    this.height = 12.0,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completed/$target completed',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Container(
            height: height,
            width: double.infinity,
            color: theme.colorScheme.surfaceVariant,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(height / 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
