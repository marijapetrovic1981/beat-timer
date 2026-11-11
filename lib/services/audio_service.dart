import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _soundEnabled = true;

  bool get soundEnabled => _soundEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  Future<void> playCountdown() async {
    if (!_soundEnabled) return;
    await _player.play(AssetSource('sounds/beep3sec.mp3'));
  }

  Future<void> playWhistle() async {
    if (!_soundEnabled) return;
    await _player.play(AssetSource('sounds/whistle.mp3'));
  }

  Future<void> playGo() async {
    if (!_soundEnabled) return;
    await _player.play(AssetSource('sounds/go.mp3'));
  }

  Future<void> playRest() async {
    if (!_soundEnabled) return;
    await _player.play(AssetSource('sounds/rest.mp3'));
  }

  Future<void> playCooldown() async {
    if (!_soundEnabled) return;
    await _player.play(AssetSource('sounds/cooldown.mp3'));
  }

  Future<void> playWorkoutDone() async {
    if (!_soundEnabled) return;
    await _player.play(AssetSource('sounds/workout-done.mp3'));
  }

  void dispose() {
    _player.dispose();
  }
}
