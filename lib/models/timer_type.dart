enum TimerType {
  tabata,
  rounds,
}

extension TimerTypeExtension on TimerType {
  String get displayName {
    switch (this) {
      case TimerType.tabata:
        return 'Tabata';
      case TimerType.rounds:
        return 'Rounds';
    }
  }

  String get description {
    switch (this) {
      case TimerType.tabata:
        return 'Interval training with cycles';
      case TimerType.rounds:
        return 'Custom work/rest intervals';
    }
  }
}
