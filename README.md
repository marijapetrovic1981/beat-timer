# Beat Timer 🏋️‍♀️

Workout timer app for iOS and Android - Tabata, HIIT, EMOM and custom interval training.

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run on device/simulator
flutter run

# Or for specific platform
flutter run -d ios
flutter run -d android
```

## Project Structure

```
lib/
├── main.dart                 # Entry point - launches the app
│
├── models/                   # Data models
│   ├── timer_state.dart      # Timer state (phase, seconds, round...)
│   ├── timer_type.dart       # Timer type enum (tabata, rounds, etc.)
│   └── workout.dart          # Workout model with all settings
│
├── providers/                # State management (Provider pattern)
│   ├── timer_provider.dart   # Timer logic - start/pause/stop
│   └── workout_provider.dart # CRUD for custom workouts + persistence
│
├── screens/                  # Screens (pages)
│   ├── home_screen.dart      # Main screen with 2 tabs
│   ├── timer_screen.dart     # Active timer during workout
│   └── workout_editor_screen.dart  # Create/edit workouts
│
├── theme/
│   └── app_theme.dart        # Colors, typography, styles
│
├── widgets/                  # Reusable components
│   ├── circular_timer.dart   # Circular progress bar with time
│   ├── control_button.dart   # Play/Pause/Stop buttons
│   └── round_indicator.dart  # Current round and set display
│
└── utils/                    # Helper functions (empty for now)
```

## Key Files for Editing

### Design and Colors
**`lib/theme/app_theme.dart`** - all colors and styles are here:
```dart
static const Color primary = Color(0xFF00D9FF);    // Cyan - main accent
static const Color secondary = Color(0xFFFF6B35);  // Orange - WORK phase
static const Color tertiary = Color(0xFF4ADE80);   // Green - REST phase
static const Color background = Color(0xFF0D0D0D); // Background
static const Color surface = Color(0xFF1A1A1A);    // Cards
```

### Timer Appearance
**`lib/widgets/circular_timer.dart`** - circular timer, progress bar, phase colors

### Main Screen
**`lib/screens/home_screen.dart`** - 2 tabs:
- `_TimersTab` - quick start cards and timer types grid
- `_WorkoutsTab` - saved workouts list

### Active Timer
**`lib/screens/timer_screen.dart`** - screen during workout, controls, completion dialog

### Workout Editor
**`lib/screens/workout_editor_screen.dart`** - form for setting time, rounds, sets

## Flutter Basics

### Widgets
Everything in Flutter is a **Widget**. Two types:
- `StatelessWidget` - doesn't change (e.g., button, text)
- `StatefulWidget` - has state that changes (e.g., timer, form)

### Widget Structure
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello'),
    );
  }
}
```

### Common Widgets
- `Container` - box with padding, margin, decoration
- `Column` / `Row` - vertical / horizontal layout
- `Text` - text
- `Icon` - icon
- `ElevatedButton` / `TextButton` - buttons
- `Card` - card with shadow
- `ListView` - scrollable list
- `Padding` - adds padding
- `SizedBox` - empty space with fixed size

### State Management (Provider)
The app uses **Provider** for state:
```dart
// Reading state
final timer = context.watch<TimerProvider>();

// Calling methods
context.read<TimerProvider>().start();
```

### Styling
```dart
Container(
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 8),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    'Text',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
)
```

## Useful Commands

```bash
# Hot reload (save file while app is running)
# Automatically refreshes

# Full restart (if hot reload doesn't work)
# Press 'R' in terminal

# Code analysis
flutter analyze

# Format code
dart format lib/

# Build for release
flutter build ios
flutter build apk
```

## Dependencies (pubspec.yaml)

- `provider` - state management
- `shared_preferences` - local data storage
- `audioplayers` - sound effects (not implemented yet)
- `vibration` - vibration (not implemented yet)
- `wakelock_plus` - keeps screen on during workout

## TODO / Ideas

- [ ] Sound effects for countdown and phase change
- [ ] Vibration feedback
- [ ] Workout history
- [ ] Statistics (total time, workouts per week)
- [ ] Custom sounds
- [ ] Landscape mode for timer
- [ ] Home screen widget
