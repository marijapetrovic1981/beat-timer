import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/audio_service.dart';

class SettingsProvider extends ChangeNotifier {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _keepScreenOn = true;
  bool _voiceAssistEnabled = true;
  bool _whistleEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get keepScreenOn => _keepScreenOn;
  bool get voiceAssistEnabled => _voiceAssistEnabled;
  bool get whistleEnabled => _whistleEnabled;

  final AudioService _audioService = AudioService();

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    _keepScreenOn = prefs.getBool('keep_screen_on') ?? true;
    _voiceAssistEnabled = prefs.getBool('voice_assist_enabled') ?? true;
    _whistleEnabled = prefs.getBool('whistle_enabled') ?? true;
    
    // Sync audio service
    _audioService.setSoundEnabled(_soundEnabled);
    _audioService.setVoiceAssistEnabled(_voiceAssistEnabled);
    _audioService.setWhistleEnabled(_whistleEnabled);
    
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    _audioService.setSoundEnabled(value);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', value);
    
    notifyListeners();
  }

  Future<void> setVibrationEnabled(bool value) async {
    _vibrationEnabled = value;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', value);
    
    notifyListeners();
  }

  Future<void> setKeepScreenOn(bool value) async {
    _keepScreenOn = value;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keep_screen_on', value);
    
    notifyListeners();
  }

  Future<void> setVoiceAssistEnabled(bool value) async {
    _voiceAssistEnabled = value;
    _audioService.setVoiceAssistEnabled(value);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voice_assist_enabled', value);
    
    notifyListeners();
  }

  Future<void> setWhistleEnabled(bool value) async {
    _whistleEnabled = value;
    _audioService.setWhistleEnabled(value);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('whistle_enabled', value);
    
    notifyListeners();
  }
}
