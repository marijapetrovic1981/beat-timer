enum TimerPhase {
  idle,
  prepare,
  work,
  rest,
  restBetweenCycles,
  cooldown,
  finished,
}

extension TimerPhaseExtension on TimerPhase {
  String get displayName {
    switch (this) {
      case TimerPhase.idle:
        return 'Ready';
      case TimerPhase.prepare:
        return 'Get Ready';
      case TimerPhase.work:
        return 'Work';
      case TimerPhase.rest:
        return 'Rest';
      case TimerPhase.restBetweenCycles:
        return 'Cycle Break';
      case TimerPhase.cooldown:
        return 'Cool Down';
      case TimerPhase.finished:
        return 'Complete!';
    }
  }

  bool get isActive {
    return this == TimerPhase.work ||
        this == TimerPhase.rest ||
        this == TimerPhase.prepare ||
        this == TimerPhase.restBetweenCycles ||
        this == TimerPhase.cooldown;
  }
}

class TimerState {
  final TimerPhase phase;
  final int currentRound;
  final int currentCycle;
  final int secondsRemaining;
  final int totalSecondsElapsed;
  final bool isRunning;
  final bool isPaused;

  const TimerState({
    this.phase = TimerPhase.idle,
    this.currentRound = 1,
    this.currentCycle = 1,
    this.secondsRemaining = 0,
    this.totalSecondsElapsed = 0,
    this.isRunning = false,
    this.isPaused = false,
  });

  TimerState copyWith({
    TimerPhase? phase,
    int? currentRound,
    int? currentCycle,
    int? secondsRemaining,
    int? totalSecondsElapsed,
    bool? isRunning,
    bool? isPaused,
  }) {
    return TimerState(
      phase: phase ?? this.phase,
      currentRound: currentRound ?? this.currentRound,
      currentCycle: currentCycle ?? this.currentCycle,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      totalSecondsElapsed: totalSecondsElapsed ?? this.totalSecondsElapsed,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  String get formattedTime {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
