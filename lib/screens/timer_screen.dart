import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/timer_state.dart';
import '../models/timer_type.dart';
import '../models/workout.dart';
import '../providers/timer_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/circular_timer.dart';
import '../widgets/control_button.dart';
import '../widgets/neumorphic_container.dart';

class TimerScreen extends StatefulWidget {
  final Workout workout;
  final bool autoStart;

  const TimerScreen({
    super.key,
    required this.workout,
    this.autoStart = false,
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
    
    // Auto start if requested
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _timerProvider.start();
      });
    }
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
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

  // Get next phase info
  Map<String, dynamic>? _getNextPhase(TimerState state) {
    final workout = widget.workout;
    
    // Check if this is the last round in current cycle
    final isLastRoundInCycle = state.currentRound >= workout.rounds;
    // Check if this is the very last round overall
    final isLastRoundOverall = isLastRoundInCycle && 
        (workout.type != TimerType.tabata || state.currentCycle >= workout.cycles);
    
    switch (state.phase) {
      case TimerPhase.prepare:
        return {
          'name': 'WORK',
          'duration': workout.workSeconds,
          'color': AppTheme.colorWork,
        };
      case TimerPhase.work:
        if (isLastRoundOverall) {
          // Last round ever - next is cooldown or done
          if (workout.cooldownSeconds > 0) {
            return {
              'name': 'COOLDOWN',
              'duration': workout.cooldownSeconds,
              'color': AppTheme.colorRest,
            };
          }
          return null; // Done
        } else if (isLastRoundInCycle && workout.type == TimerType.tabata) {
          // Last round in cycle - next is cycle rest
          return {
            'name': 'CYCLE REST',
            'duration': workout.restBetweenCycles,
            'color': AppTheme.colorRest,
          };
        } else if (workout.restSeconds > 0) {
          // Normal rest
          return {
            'name': 'REST',
            'duration': workout.restSeconds,
            'color': AppTheme.colorRest,
          };
        } else {
          // No rest, next work
          return {
            'name': 'WORK',
            'duration': workout.workSeconds,
            'color': AppTheme.colorWork,
          };
        }
      case TimerPhase.rest:
        // After rest always comes work (next round)
        return {
          'name': 'WORK',
          'duration': workout.workSeconds,
          'color': AppTheme.colorWork,
        };
      case TimerPhase.restBetweenCycles:
        return {
          'name': 'WORK',
          'duration': workout.workSeconds,
          'color': AppTheme.colorWork,
        };
      case TimerPhase.cooldown:
        return null;
      case TimerPhase.idle:
        return {
          'name': 'PREPARE',
          'duration': workout.prepareSeconds,
          'color': AppTheme.colorPrepare,
        };
      case TimerPhase.finished:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        titleSpacing: 0,
        leading: const SizedBox(), // Empty left side
        leadingWidth: 16,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: NeumorphicButton(
              onPressed: () {
                _timerProvider.stop();
                Navigator.of(context).pop();
              },
              size: 40,
              child: const Icon(Icons.close, color: AppTheme.textPrimary, size: 20),
            ),
          ),
        ],
      ),
      body: Consumer<TimerProvider>(
        builder: (context, provider, child) {
          final state = provider.state;
          
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  
                  // Rounds and Cycles row
                  _buildRoundsRow(state),
                  
                  const Spacer(flex: 1),
                  
                  // Timer
                  CircularTimer(
                    state: state,
                    totalSeconds: _getCurrentPhaseDuration(state),
                    size: math.min(MediaQuery.of(context).size.width * 0.75, 320),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Next phase indicator
                  _buildNextIndicator(state),
                  
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

  Widget _buildRoundsRow(TimerState state) {
    final showCycles = widget.workout.type == TimerType.tabata;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Rounds
        NeumorphicContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          borderRadius: 16,
          child: Column(
            children: [
              const Text(
                'ROUNDS',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${state.currentRound}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colorRounds,
                      ),
                    ),
                    TextSpan(
                      text: '/${widget.workout.rounds}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Cycles (only for Tabata)
        if (showCycles)
          NeumorphicContainer(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            borderRadius: 16,
            child: Column(
              children: [
                const Text(
                  'CYCLES',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${state.currentCycle}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.colorRounds,
                        ),
                      ),
                      TextSpan(
                        text: '/${widget.workout.cycles}',
                        style: const TextStyle(
                          fontSize: 22,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }

  Widget _buildNextIndicator(TimerState state) {
    if (state.phase == TimerPhase.finished) {
      return const Text(
        'WORKOUT DONE',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppTheme.colorWork,
        ),
      );
    }
    
    final nextPhase = _getNextPhase(state);
    
    if (nextPhase == null) {
      return const SizedBox(height: 50);
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'NEXT: ',
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.textPrimary,
            letterSpacing: 1,
          ),
        ),
        Text(
          '${nextPhase['name']} ${_formatDuration(nextPhase['duration'])}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: nextPhase['color'],
          ),
        ),
      ],
    );
  }

  Widget _buildControls(TimerState state, TimerProvider provider) {
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
          icon: Icons.replay_rounded,
          onPressed: () {
            provider.stop();
          },
          size: 56,
        ),
        const SizedBox(width: 24),
        ControlButton(
          icon: state.isPaused || state.phase == TimerPhase.finished
              ? Icons.play_arrow_rounded 
              : Icons.pause_rounded,
          onPressed: () {
            if (state.phase == TimerPhase.finished) {
              provider.stop();
              provider.start();
            } else if (state.isPaused) {
              provider.resume();
            } else {
              provider.pause();
            }
          },
          isPrimary: true,
          size: 80,
          glowColor: AppTheme.colorWork,
        ),
        const SizedBox(width: 24),
        ControlButton(
          icon: Icons.skip_next_rounded,
          onPressed: state.phase != TimerPhase.finished ? provider.skipPhase : () {},
          size: 56,
        ),
      ],
    );
  }
}
