import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _soundEnabled = true;
  bool _voiceAssistEnabled = true;
  bool _whistleEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get voiceAssistEnabled => _voiceAssistEnabled;
  bool get whistleEnabled => _whistleEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void setVoiceAssistEnabled(bool enabled) {
    _voiceAssistEnabled = enabled;
  }

  void setWhistleEnabled(bool enabled) {
    _whistleEnabled = enabled;
  }

  Future<void> playCountdown() async {
    if (!_soundEnabled) return;
    await _player.play(AssetSource('sounds/beep3sec.mp3'));
  }

  Future<void> playWhistle() async {
    if (!_soundEnabled) return;
    if (!_whistleEnabled) return;
    await _player.play(AssetSource('sounds/whistle.mp3'));
  }

  Future<void> playGo() async {
    if (!_soundEnabled) return;
    if (_voiceAssistEnabled) {
      await _player.play(AssetSource('sounds/go.mp3'));
    } else if (_whistleEnabled) {
      await _player.play(AssetSource('sounds/whistle.mp3'));
    }
    // If both off, no sound (only beep countdown)
  }

  Future<void> playRest() async {
    if (!_soundEnabled) return;
    if (_voiceAssistEnabled) {
      await _player.play(AssetSource('sounds/rest.mp3'));
    } else if (_whistleEnabled) {
      await _player.play(AssetSource('sounds/whistle.mp3'));
    }
    // If both off, no sound (only beep countdown)
  }

  Future<void> playCooldown() async {
    if (!_soundEnabled) return;
    if (_voiceAssistEnabled) {
      await _player.play(AssetSource('sounds/cooldown.mp3'));
    } else if (_whistleEnabled) {
      await _player.play(AssetSource('sounds/whistle.mp3'));
    }
    // If both off, no sound (only beep countdown)
  }

  Future<void> playWorkoutDone() async {
    if (!_soundEnabled) return;
    if (_voiceAssistEnabled) {
      await _player.play(AssetSource('sounds/workout-done.mp3'));
    }
    // No sound if voice assist is off
  }

  void dispose() {
    _player.dispose();
  }
}
