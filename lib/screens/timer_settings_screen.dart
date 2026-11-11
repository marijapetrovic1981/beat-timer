import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../models/timer_type.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';
import '../widgets/time_picker_modal.dart';
import '../widgets/number_picker_modal.dart';

class TimerSettingsScreen extends StatefulWidget {
  final TimerType timerType;
  final Workout workout;

  const TimerSettingsScreen({
    super.key,
    required this.timerType,
    required this.workout,
  });

  @override
  State<TimerSettingsScreen> createState() => _TimerSettingsScreenState();
}

class _TimerSettingsScreenState extends State<TimerSettingsScreen> {
  late TextEditingController _nameController;
  late Workout _workout;

  @override
  void initState() {
    super.initState();
    _workout = widget.workout;
    // For new (default) timers, start with empty field - placeholder will show
    final isDefault = _workout.id.startsWith('default_');
    _nameController = TextEditingController(text: isDefault ? '' : _workout.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateWorkout(Workout Function(Workout) update) {
    setState(() {
      _workout = update(_workout);
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (m > 0 && s > 0) {
      return '${m}m ${s}s';
    } else if (m > 0) {
      return '${m}m';
    }
    return '${s}s';
  }

  Future<void> _openTimePicker(String title, int currentValue, ValueChanged<int> onChanged) async {
    final result = await TimePickerModal.show(
      context: context,
      title: title,
      initialSeconds: currentValue,
    );
    if (result != null) {
      onChanged(result);
    }
  }

  Future<void> _openNumberPicker(String title, int currentValue, ValueChanged<int> onChanged) async {
    final result = await NumberPickerModal.show(
      context: context,
      title: title,
      initialValue: currentValue,
      minValue: 1,
      maxValue: 100,
    );
    if (result != null) {
      onChanged(result);
    }
  }

  void _goBack() {
    // Return the updated workout to the previous screen
    Navigator.of(context).pop(_workout.copyWith(name: _nameController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();
    final isExisting = !_workout.id.startsWith('default_');
    final canSave = isExisting || workoutProvider.canSaveMore;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.timerType.displayName} Settings'),
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: NeumorphicButton(
            onPressed: _goBack,
            size: 40,
            child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20),
          ),
        ),
        leadingWidth: 56,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: NeumorphicButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              size: 40,
              child: const Icon(Icons.home_outlined, color: AppTheme.textPrimary, size: 20),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Name input
          if (canSave)
            NeumorphicContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              isPressed: true,
              child: TextField(
                controller: _nameController,
                maxLength: 30,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  counterText: '', // Hide character counter
                  labelText: 'Timer Name',
                  labelStyle: const TextStyle(color: AppTheme.textSecondary),
                  hintText: widget.timerType.displayName,
                  hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                  border: InputBorder.none,
                  suffixIcon: _nameController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppTheme.textSecondary, size: 20),
                          onPressed: () {
                            _nameController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                  _updateWorkout((w) => w.copyWith(name: value));
                },
              ),
            )
          else
            NeumorphicContainer(
              padding: const EdgeInsets.all(16),
              isPressed: true,
              child: const Center(
                child: Text(
                  'Maximum timers saved',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Settings based on timer type
          ..._buildSettingsForType(),
          
          const SizedBox(height: 24),
          
          // Summary
          _buildSummary(),
          
          const SizedBox(height: 24),
          
          // Save button
          NeumorphicButton(
            onPressed: canSave ? _save : null,
            size: 56,
            isCircle: false,
            glowColor: canSave ? AppTheme.colorWork : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.save,
                  color: canSave ? AppTheme.colorWork : AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Save Timer',
                  style: TextStyle(
                    color: canSave ? AppTheme.colorWork : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSettingsForType() {
    switch (widget.timerType) {
      case TimerType.tabata:
        return [
          _buildTimeTile(
            label: 'Prepare',
            value: _workout.prepareSeconds,
            color: AppTheme.colorPrepare,
            onTap: () => _openTimePicker('Prepare', _workout.prepareSeconds, 
                (v) => _updateWorkout((w) => w.copyWith(prepareSeconds: v))),
          ),
          _buildTimeTile(
            label: 'Work',
            value: _workout.workSeconds,
            color: AppTheme.colorWork,
            onTap: () => _openTimePicker('Work', _workout.workSeconds, 
                (v) => _updateWorkout((w) => w.copyWith(workSeconds: v))),
          ),
          _buildTimeTile(
            label: 'Rest',
            value: _workout.restSeconds,
            color: AppTheme.colorRest,
            onTap: () => _openTimePicker('Rest', _workout.restSeconds, 
                (v) => _updateWorkout((w) => w.copyWith(restSeconds: v))),
          ),
          _buildNumberTile(
            label: 'Rounds',
            value: _workout.rounds,
            color: AppTheme.colorRounds,
            onTap: () => _openNumberPicker('Rounds', _workout.rounds, 
                (v) => _updateWorkout((w) => w.copyWith(rounds: v))),
          ),
          _buildNumberTile(
            label: 'Cycles',
            value: _workout.cycles,
            color: AppTheme.colorRounds,
            onTap: () => _openNumberPicker('Cycles', _workout.cycles, 
                (v) => _updateWorkout((w) => w.copyWith(cycles: v))),
          ),
          if (_workout.cycles > 1)
            _buildTimeTile(
              label: 'Rest Between Cycles',
              value: _workout.restBetweenCycles,
              color: AppTheme.colorRest,
              onTap: () => _openTimePicker('Rest Between Cycles', _workout.restBetweenCycles, 
                  (v) => _updateWorkout((w) => w.copyWith(restBetweenCycles: v))),
            ),
          _buildTimeTile(
            label: 'Cooldown',
            value: _workout.cooldownSeconds,
            color: AppTheme.colorRest,
            onTap: () => _openTimePicker('Cooldown', _workout.cooldownSeconds, 
                (v) => _updateWorkout((w) => w.copyWith(cooldownSeconds: v))),
          ),
        ];
        
      case TimerType.rounds:
        return [
          _buildTimeTile(
            label: 'Prepare',
            value: _workout.prepareSeconds,
            color: AppTheme.colorPrepare,
            onTap: () => _openTimePicker('Prepare', _workout.prepareSeconds, 
                (v) => _updateWorkout((w) => w.copyWith(prepareSeconds: v))),
          ),
          _buildTimeTile(
            label: 'Work',
            value: _workout.workSeconds,
            color: AppTheme.colorWork,
            onTap: () => _openTimePicker('Work', _workout.workSeconds, 
                (v) => _updateWorkout((w) => w.copyWith(workSeconds: v))),
          ),
          _buildTimeTile(
            label: 'Rest',
            value: _workout.restSeconds,
            color: AppTheme.colorRest,
            onTap: () => _openTimePicker('Rest', _workout.restSeconds, 
                (v) => _updateWorkout((w) => w.copyWith(restSeconds: v))),
          ),
          _buildNumberTile(
            label: 'Rounds',
            value: _workout.rounds,
            color: AppTheme.colorRounds,
            onTap: () => _openNumberPicker('Rounds', _workout.rounds, 
                (v) => _updateWorkout((w) => w.copyWith(rounds: v))),
          ),
          _buildTimeTile(
            label: 'Cooldown',
            value: _workout.cooldownSeconds,
            color: AppTheme.colorRest,
            onTap: () => _openTimePicker('Cooldown', _workout.cooldownSeconds, 
                (v) => _updateWorkout((w) => w.copyWith(cooldownSeconds: v))),
          ),
        ];
    }
  }

  Widget _buildTimeTile({
    required String label,
    required int value,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        borderRadius: 16,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              if (color != null)
                Container(
                  width: 4,
                  height: 24,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                _formatTime(value),
                style: const TextStyle(
                  color: AppTheme.colorWork,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberTile({
    required String label,
    required int value,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        borderRadius: 16,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              if (color != null)
                Container(
                  width: 4,
                  height: 24,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '$value',
                style: const TextStyle(
                  color: AppTheme.colorWork,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(16),
      isPressed: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Total: ',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            _workout.formattedTotalDuration,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.colorWork,
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    String name = _nameController.text.trim();
    if (name.isEmpty) {
      name = widget.timerType.displayName;
    }
    
    // Check if this is an existing saved timer (not a default one)
    final isExisting = !_workout.id.startsWith('default_');
    
    final workout = _workout.copyWith(
      id: isExisting ? _workout.id : DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      createdAt: isExisting ? _workout.createdAt : DateTime.now(),
    );
    
    context.read<WorkoutProvider>().saveWorkout(workout);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isExisting ? 'Timer updated!' : 'Timer saved!'),
        backgroundColor: AppTheme.colorWork,
      ),
    );
    
    // Return the saved workout
    Navigator.of(context).pop(workout);
  }
}
