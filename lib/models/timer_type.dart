enum TimerType {
  tabata,
  rounds,
  stopwatch,
}

extension TimerTypeExtension on TimerType {
  String get displayName {
    switch (this) {
      case TimerType.tabata:
        return 'Tabata';
      case TimerType.rounds:
        return 'Rounds';
      case TimerType.stopwatch:
        return 'Stopwatch';
    }
  }

  String get description {
    switch (this) {
      case TimerType.tabata:
        return 'Interval training with cycles';
      case TimerType.rounds:
        return 'Custom work/rest intervals';
      case TimerType.stopwatch:
        return 'Track time with laps';
    }
  }
}
