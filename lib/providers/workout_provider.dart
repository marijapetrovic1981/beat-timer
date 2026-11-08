import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Workout> _savedTimers = [];

  List<Workout> get savedTimers => _savedTimers;

  Future<void> loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutsJson = prefs.getStringList('saved_timers') ?? [];
    
    _savedTimers = workoutsJson
        .map((json) => Workout.fromJson(jsonDecode(json)))
        .toList();
    
    // Sort by creation date, newest first
    _savedTimers.sort((a, b) {
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });
    
    notifyListeners();
  }

  Future<void> saveWorkout(Workout workout) async {
    final index = _savedTimers.indexWhere((w) => w.id == workout.id);
    
    if (index >= 0) {
      _savedTimers[index] = workout;
    } else {
      _savedTimers.insert(0, workout);
    }
    
    await _persistWorkouts();
    notifyListeners();
  }

  Future<void> deleteWorkout(String id) async {
    _savedTimers.removeWhere((w) => w.id == id);
    await _persistWorkouts();
    notifyListeners();
  }

  Future<void> _persistWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutsJson = _savedTimers
        .map((w) => jsonEncode(w.toJson()))
        .toList();
    await prefs.setStringList('saved_timers', workoutsJson);
  }
}
