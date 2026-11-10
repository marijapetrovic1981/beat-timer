import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/timer_state.dart';
import '../models/workout.dart';
import '../models/timer_type.dart';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  TimerState _state = const TimerState();
  Workout? _currentWorkout;
  
  // Callbacks for sound/vibration
  VoidCallback? onPhaseChange;
  VoidCallback? onCountdown;
  VoidCallback? onComplete;

  TimerState get state => _state;
  Workout? get currentWorkout => _currentWorkout;

  void loadWorkout(Workout workout) {
    _currentWorkout = workout;
    _state = TimerState(
      phase: TimerPhase.idle,
      secondsRemaining: workout.prepareSeconds,
      currentRound: 1,
      currentCycle: 1,
    );
    notifyListeners();
  }

  void start() {
    if (_currentWorkout == null) return;
    
    // Keep screen on during workout
    WakelockPlus.enable();
    
    if (_state.phase == TimerPhase.idle) {
      _state = _state.copyWith(
        phase: TimerPhase.prepare,
        isRunning: true,
        isPaused: false,
        secondsRemaining: _currentWorkout!.prepareSeconds,
      );
    } else {
      _state = _state.copyWith(
        isRunning: true,
        isPaused: false,
      );
    }
    
    _startTimer();
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _state = _state.copyWith(
      isRunning: false,
      isPaused: true,
    );
    notifyListeners();
  }

  void resume() {
    _state = _state.copyWith(
      isRunning: true,
      isPaused: false,
    );
    _startTimer();
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    WakelockPlus.disable();
    _state = TimerState(
      phase: TimerPhase.idle,
      secondsRemaining: _currentWorkout?.prepareSeconds ?? 0,
    );
    notifyListeners();
  }

  void skipPhase() {
    if (!_state.isRunning) return;
    _advanceToNextPhase();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _tick() {
    if (_state.secondsRemaining > 0) {
      _state = _state.copyWith(
        secondsRemaining: _state.secondsRemaining - 1,
        totalSecondsElapsed: _state.totalSecondsElapsed + 1,
      );
      
      // Countdown beep for last 3 seconds
      if (_state.secondsRemaining <= 3 && _state.secondsRemaining > 0) {
        onCountdown?.call();
      }
      
      notifyListeners();
    } else {
      _advanceToNextPhase();
    }
  }

  void _advanceToNextPhase() {
    if (_currentWorkout == null) return;
    final workout = _currentWorkout!;

    switch (_state.phase) {
      case TimerPhase.prepare:
        // Start first work interval
        _state = _state.copyWith(
          phase: TimerPhase.work,
          secondsRemaining: workout.workSeconds,
        );
        onPhaseChange?.call();
        break;

      case TimerPhase.work:
        // Check if this is the last round in current cycle
        final isLastRoundInCycle = _state.currentRound >= workout.rounds;
        // Check if this is the very last round overall
        final isLastRoundOverall = isLastRoundInCycle && 
            (workout.type != TimerType.tabata || _state.currentCycle >= workout.cycles);
        
        if (isLastRoundOverall) {
          // Last round ever - skip rest, go to cooldown or finish
          if (workout.cooldownSeconds > 0) {
            _state = _state.copyWith(
              phase: TimerPhase.cooldown,
              secondsRemaining: workout.cooldownSeconds,
            );
            onPhaseChange?.call();
          } else {
            _finishWorkout();
          }
        } else if (isLastRoundInCycle && workout.type == TimerType.tabata) {
          // Last round in cycle but more cycles to go - skip rest, go to cycle rest
          _state = _state.copyWith(
            phase: TimerPhase.restBetweenCycles,
            secondsRemaining: workout.restBetweenCycles,
          );
          onPhaseChange?.call();
        } else if (workout.restSeconds > 0) {
          // Normal rest between rounds
          _state = _state.copyWith(
            phase: TimerPhase.rest,
            secondsRemaining: workout.restSeconds,
          );
          onPhaseChange?.call();
        } else {
          // No rest configured, go directly to next round
          _state = _state.copyWith(
            phase: TimerPhase.work,
            secondsRemaining: workout.workSeconds,
            currentRound: _state.currentRound + 1,
          );
          onPhaseChange?.call();
        }
        break;

      case TimerPhase.rest:
        _handleRoundComplete();
        break;

      case TimerPhase.restBetweenCycles:
        // Start next cycle
        _state = _state.copyWith(
          phase: TimerPhase.work,
          secondsRemaining: workout.workSeconds,
          currentRound: 1,
          currentCycle: _state.currentCycle + 1,
        );
        onPhaseChange?.call();
        break;

      case TimerPhase.cooldown:
        _finishWorkout();
        break;

      case TimerPhase.idle:
      case TimerPhase.finished:
        break;
    }

    notifyListeners();
  }

  void _handleRoundComplete() {
    final workout = _currentWorkout!;

    if (_state.currentRound < workout.rounds) {
      // Next round
      _state = _state.copyWith(
        phase: TimerPhase.work,
        secondsRemaining: workout.workSeconds,
        currentRound: _state.currentRound + 1,
      );
      onPhaseChange?.call();
    } else if (workout.type == TimerType.tabata && 
               _state.currentCycle < workout.cycles) {
      // Rest between cycles (Tabata only)
      _state = _state.copyWith(
        phase: TimerPhase.restBetweenCycles,
        secondsRemaining: workout.restBetweenCycles,
      );
      onPhaseChange?.call();
    } else if (workout.cooldownSeconds > 0) {
      // Cooldown
      _state = _state.copyWith(
        phase: TimerPhase.cooldown,
        secondsRemaining: workout.cooldownSeconds,
      );
      onPhaseChange?.call();
    } else {
      _finishWorkout();
    }
  }

  void _finishWorkout() {
    _timer?.cancel();
    WakelockPlus.disable();
    _state = _state.copyWith(
      phase: TimerPhase.finished,
      isRunning: false,
      secondsRemaining: 0,
    );
    onComplete?.call();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }
}
