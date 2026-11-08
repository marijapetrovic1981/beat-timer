import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../models/timer_type.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';
import 'timer_screen.dart';
import 'stopwatch_screen.dart';
import 'timer_settings_screen.dart';

class TimerDetailScreen extends StatefulWidget {
  final TimerType timerType;
  final Workout workout;

  const TimerDetailScreen({
    super.key,
    required this.timerType,
    required this.workout,
  });

  @override
  State<TimerDetailScreen> createState() => _TimerDetailScreenState();
}

class _TimerDetailScreenState extends State<TimerDetailScreen> {
  late Workout _workout;

  @override
  void initState() {
    super.initState();
    _workout = widget.workout;
  }

  Future<void> _openSettings() async {
    final result = await Navigator.of(context).push<Workout>(
      MaterialPageRoute(
        builder: (context) => TimerSettingsScreen(
          timerType: widget.timerType,
          workout: _workout,
        ),
      ),
    );
    
    // Update if we got a result back
    if (result != null) {
      setState(() {
        _workout = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_workout.name),
        leading: NeumorphicButton(
          onPressed: () => Navigator.of(context).pop(),
          size: 40,
          child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20),
        ),
        leadingWidth: 56,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: NeumorphicButton(
              onPressed: _openSettings,
              size: 40,
              child: const Icon(
                Icons.tune,
                color: AppTheme.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Timer info summary
              _buildInfoCard(),
              
              const Spacer(),
              
              // Start button
              Center(
                child: NeumorphicButton(
                  onPressed: () => _startTimer(context),
                  size: 120,
                  glowColor: AppTheme.colorWork,
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: AppTheme.colorWork,
                    size: 60,
                  ),
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Total duration
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _workout.formattedTotalDuration,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colorWork,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Details based on timer type
          ..._buildDetails(),
        ],
      ),
    );
  }

  List<Widget> _buildDetails() {
    switch (widget.timerType) {
      case TimerType.tabata:
        return [
          _buildDetailRow('Prepare', '${_workout.prepareSeconds}s'),
          _buildDetailRow('Work', '${_workout.workSeconds}s', color: AppTheme.colorWork),
          _buildDetailRow('Rest', '${_workout.restSeconds}s', color: AppTheme.colorRest),
          _buildDetailRow('Rounds', '${_workout.rounds}'),
          _buildDetailRow('Cycles', '${_workout.cycles}'),
          if (_workout.cycles > 1)
            _buildDetailRow('Rest between cycles', '${_workout.restBetweenCycles}s'),
          if (_workout.cooldownSeconds > 0)
            _buildDetailRow('Cooldown', '${_workout.cooldownSeconds}s'),
        ];
        
      case TimerType.rounds:
        return [
          _buildDetailRow('Prepare', '${_workout.prepareSeconds}s'),
          _buildDetailRow('Work', '${_workout.workSeconds}s', color: AppTheme.colorWork),
          _buildDetailRow('Rest', '${_workout.restSeconds}s', color: AppTheme.colorRest),
          _buildDetailRow('Rounds', '${_workout.rounds}'),
          if (_workout.cooldownSeconds > 0)
            _buildDetailRow('Cooldown', '${_workout.cooldownSeconds}s'),
        ];
        
      case TimerType.stopwatch:
        return [
          _buildDetailRow('Prepare', '${_workout.prepareSeconds}s'),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Tap to record laps',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ];
    }
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (color != null)
                Container(
                  width: 4,
                  height: 16,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _startTimer(BuildContext context) {
    if (widget.timerType == TimerType.stopwatch) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StopwatchScreen(workout: _workout),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TimerScreen(workout: _workout),
        ),
      );
    }
  }
}
