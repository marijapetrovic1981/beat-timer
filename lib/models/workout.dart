import 'timer_type.dart';

class Workout {
  final String id;
  final String name;
  final TimerType type;
  
  // Common fields
  final int prepareSeconds;
  final int cooldownSeconds;
  
  // Tabata & Rounds fields
  final int workSeconds;
  final int restSeconds;
  final int rounds;
  
  // Tabata only
  final int cycles;
  final int restBetweenCycles;
  
  final DateTime? createdAt;

  const Workout({
    required this.id,
    required this.name,
    required this.type,
    this.prepareSeconds = 10,
    this.cooldownSeconds = 0,
    this.workSeconds = 20,
    this.restSeconds = 10,
    this.rounds = 8,
    this.cycles = 2,
    this.restBetweenCycles = 60,
    this.createdAt,
  });

  // Default Tabata preset
  factory Workout.tabata() {
    return const Workout(
      id: 'default_tabata',
      name: 'Tabata',
      type: TimerType.tabata,
      prepareSeconds: 10,
      workSeconds: 20,
      restSeconds: 10,
      rounds: 8,
      cycles: 2,
      restBetweenCycles: 60,
      cooldownSeconds: 0,
    );
  }

  // Default Rounds preset
  factory Workout.rounds() {
    return const Workout(
      id: 'default_rounds',
      name: 'Rounds',
      type: TimerType.rounds,
      prepareSeconds: 10,
      workSeconds: 30,
      restSeconds: 10,
      rounds: 5,
      cooldownSeconds: 0,
    );
  }

  int get totalDurationSeconds {
    switch (type) {
      case TimerType.tabata:
        int total = prepareSeconds;
        for (int c = 0; c < cycles; c++) {
          // Work for all rounds + rest for all rounds EXCEPT the last one in cycle
          total += rounds * workSeconds + (rounds - 1) * restSeconds;
          if (c < cycles - 1) {
            total += restBetweenCycles;
          }
        }
        total += cooldownSeconds;
        return total;
        
      case TimerType.rounds:
        // Work for all rounds + rest for all rounds EXCEPT the last one
        return prepareSeconds + 
               (rounds * workSeconds) + 
               ((rounds - 1) * restSeconds) + 
               cooldownSeconds;
    }
  }

  String get formattedTotalDuration {
    final minutes = totalDurationSeconds ~/ 60;
    final seconds = totalDurationSeconds % 60;
    if (minutes > 0 && seconds > 0) {
      return '${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m';
    }
    return '${seconds}s';
  }

  Workout copyWith({
    String? id,
    String? name,
    TimerType? type,
    int? prepareSeconds,
    int? cooldownSeconds,
    int? workSeconds,
    int? restSeconds,
    int? rounds,
    int? cycles,
    int? restBetweenCycles,
    DateTime? createdAt,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      prepareSeconds: prepareSeconds ?? this.prepareSeconds,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      rounds: rounds ?? this.rounds,
      cycles: cycles ?? this.cycles,
      restBetweenCycles: restBetweenCycles ?? this.restBetweenCycles,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'prepareSeconds': prepareSeconds,
      'cooldownSeconds': cooldownSeconds,
      'workSeconds': workSeconds,
      'restSeconds': restSeconds,
      'rounds': rounds,
      'cycles': cycles,
      'restBetweenCycles': restBetweenCycles,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      type: TimerType.values[json['type'] as int],
      prepareSeconds: json['prepareSeconds'] as int? ?? 10,
      cooldownSeconds: json['cooldownSeconds'] as int? ?? 0,
      workSeconds: json['workSeconds'] as int? ?? 20,
      restSeconds: json['restSeconds'] as int? ?? 10,
      rounds: json['rounds'] as int? ?? 8,
      cycles: json['cycles'] as int? ?? 1,
      restBetweenCycles: json['restBetweenCycles'] as int? ?? 60,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}
