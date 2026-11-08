import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/timer_state.dart';
import '../models/timer_type.dart';
import '../models/workout.dart';
import '../providers/timer_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/circular_timer.dart';
import '../widgets/round_indicator.dart';
import '../widgets/control_button.dart';
import '../widgets/neumorphic_container.dart';

class TimerScreen extends StatefulWidget {
  final Workout workout;

  const TimerScreen({
    super.key,
    required this.workout,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late TimerProvider _timerProvider;

  @override
  void initState() {
    super.initState();
    _timerProvider = context.read<TimerProvider>();
    _timerProvider.loadWorkout(widget.workout);
    
    // Set up callbacks
    _timerProvider.onPhaseChange = _onPhaseChange;
    _timerProvider.onCountdown = _onCountdown;
    _timerProvider.onComplete = _onComplete;
  }

  void _onPhaseChange() {
    HapticFeedback.mediumImpact();
  }

  void _onCountdown() {
    HapticFeedback.lightImpact();
  }

  void _onComplete() {
    HapticFeedback.heavyImpact();
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          '🎉 Workout Complete!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.workout.name,
              style: const TextStyle(
                color: AppTheme.colorWork,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Total Time', _formatDuration(_timerProvider.state.totalSecondsElapsed)),
            _buildStatRow('Rounds', '${widget.workout.rounds}'),
            if (widget.workout.type == TimerType.tabata && widget.workout.cycles > 1)
              _buildStatRow('Cycles', '${widget.workout.cycles}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _timerProvider.stop();
              _timerProvider.start();
            },
            child: const Text('Repeat'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s}s';
  }

  int _getCurrentPhaseDuration(TimerState state) {
    final workout = widget.workout;
    switch (state.phase) {
      case TimerPhase.prepare:
        return workout.prepareSeconds;
      case TimerPhase.work:
        return workout.workSeconds;
      case TimerPhase.rest:
        return workout.restSeconds;
      case TimerPhase.restBetweenCycles:
        return workout.restBetweenCycles;
      case TimerPhase.cooldown:
        return workout.cooldownSeconds;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        leading: NeumorphicButton(
          onPressed: () {
            _timerProvider.stop();
            Navigator.of(context).pop();
          },
          size: 40,
          child: const Icon(Icons.close, color: AppTheme.textPrimary, size: 20),
        ),
        leadingWidth: 56,
      ),
      body: Consumer<TimerProvider>(
        builder: (context, provider, child) {
          final state = provider.state;
          
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  
                  // Round indicator
                  RoundIndicator(
                    currentRound: state.currentRound,
                    totalRounds: widget.workout.rounds,
                    currentCycle: state.currentCycle,
                    totalCycles: widget.workout.type == TimerType.tabata 
                        ? widget.workout.cycles 
                        : 1,
                  ),
                  
                  const Spacer(flex: 1),
                  
                  // Timer
                  CircularTimer(
                    state: state,
                    totalSeconds: _getCurrentPhaseDuration(state),
                    size: MediaQuery.of(context).size.width * 0.75,
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Controls
                  _buildControls(state, provider),
                  
                  const SizedBox(height: 48),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControls(TimerState state, TimerProvider provider) {
    if (state.phase == TimerPhase.finished) {
      return const SizedBox.shrink();
    }

    if (state.phase == TimerPhase.idle) {
      return ControlButton(
        icon: Icons.play_arrow_rounded,
        onPressed: provider.start,
        isPrimary: true,
        size: 80,
        glowColor: AppTheme.colorWork,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlButton(
          icon: Icons.stop_rounded,
          onPressed: () {
            provider.stop();
            Navigator.of(context).pop();
          },
          size: 56,
        ),
        const SizedBox(width: 24),
        ControlButton(
          icon: state.isPaused 
              ? Icons.play_arrow_rounded 
              : Icons.pause_rounded,
          onPressed: state.isPaused ? provider.resume : provider.pause,
          isPrimary: true,
          size: 80,
          glowColor: state.phase == TimerPhase.work 
              ? AppTheme.colorWork 
              : AppTheme.colorRest,
        ),
        const SizedBox(width: 24),
        ControlButton(
          icon: Icons.skip_next_rounded,
          onPressed: provider.skipPhase,
          size: 56,
        ),
      ],
    );
  }
}
