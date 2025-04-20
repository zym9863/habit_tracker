import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/color_picker.dart';
import '../utils/app_colors.dart';

class AddEditHabitScreen extends StatefulWidget {
  final Habit? habit;
  const AddEditHabitScreen({Key? key, this.habit}) : super(key: key);

  @override
  State<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends State<AddEditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  String _category = 'Health';
  String _frequency = 'daily';
  int _targetCount = 1;
  String _color = AppColors.toHex(AppColors.categoryColors[0]);
  bool _reminderEnabled = false;
  String _reminderTime = '08:00';

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      final h = widget.habit!;
      _title = h.title;
      _description = h.description;
      _category = h.category;
      _frequency = h.frequency;
      _targetCount = h.targetCount;
      _color = h.color;
      _reminderEnabled = h.reminderEnabled;
      _reminderTime = h.reminderTime;
    } else {
      _title = '';
      _description = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Add Habit' : 'Edit Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Habit Title'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a title' : null,
                onSaved: (v) => _title = v!.trim(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                minLines: 1,
                maxLines: 3,
                onSaved: (v) => _description = v!.trim(),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'Health', child: Text('Health')),
                  DropdownMenuItem(value: 'Fitness', child: Text('Fitness')),
                  DropdownMenuItem(value: 'Productivity', child: Text('Productivity')),
                  DropdownMenuItem(value: 'Learning', child: Text('Learning')),
                  DropdownMenuItem(value: 'Mindfulness', child: Text('Mindfulness')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _frequency,
                decoration: const InputDecoration(labelText: 'Frequency'),
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                ],
                onChanged: (v) => setState(() => _frequency = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _targetCount.toString(),
                decoration: const InputDecoration(labelText: 'Target Count (per period)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 1) return 'Enter a positive number';
                  return null;
                },
                onSaved: (v) => _targetCount = int.parse(v!),
              ),
              const SizedBox(height: 12),
              Text('Color', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              ColorPicker(
                selectedColor: _color,
                onColorSelected: (color) => setState(() => _color = color),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _reminderEnabled,
                onChanged: (v) => setState(() => _reminderEnabled = v),
                title: const Text('Enable Reminder'),
              ),
              if (_reminderEnabled) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Reminder Time:'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: int.parse(_reminderTime.split(':')[0]),
                              minute: int.parse(_reminderTime.split(':')[1]),
                            ),
                          );
                          if (time != null) {
                            setState(() => _reminderTime =
                                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(_reminderTime, style: theme.textTheme.bodyLarge),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(widget.habit == null ? 'Add Habit' : 'Save Changes'),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState!.save();
                    final habit = Habit(
                      id: widget.habit?.id,
                      title: _title,
                      description: _description,
                      category: _category,
                      frequency: _frequency,
                      targetCount: _targetCount,
                      createdAt: widget.habit?.createdAt ?? DateTime.now(),
                      color: _color,
                      reminderEnabled: _reminderEnabled,
                      reminderTime: _reminderTime,
                      currentStreak: widget.habit?.currentStreak ?? 0,
                      longestStreak: widget.habit?.longestStreak ?? 0,
                    );
                    if (widget.habit == null) {
                      await provider.addHabit(habit);
                    } else {
                      await provider.updateHabit(habit);
                    }
                    if (mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
