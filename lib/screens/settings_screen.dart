import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: const Text('Settings'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.home_outlined),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  tooltip: 'Go to Home',
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Sound settings
                  const Text(
                    'SOUND',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  MenuTile(
                    icon: Icons.volume_up_outlined,
                    title: 'Sound Effects',
                    subtitle: 'Play sounds during workout',
                    onTap: () => settings.setSoundEnabled(!settings.soundEnabled),
                    trailing: Switch(
                      value: settings.soundEnabled,
                      onChanged: (value) => settings.setSoundEnabled(value),
                      activeTrackColor: AppTheme.colorWork,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  MenuTile(
                    icon: Icons.record_voice_over_outlined,
                    title: 'Voice Assist',
                    subtitle: 'Announce phase changes',
                    onTap: () => settings.setVoiceAssistEnabled(!settings.voiceAssistEnabled),
                    trailing: Switch(
                      value: settings.voiceAssistEnabled,
                      onChanged: (value) => settings.setVoiceAssistEnabled(value),
                      activeTrackColor: AppTheme.colorWork,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  MenuTile(
                    icon: Icons.sports_outlined,
                    title: 'Whistle',
                    subtitle: 'Whistle sound on phase change',
                    onTap: () => settings.setWhistleEnabled(!settings.whistleEnabled),
                    trailing: Switch(
                      value: settings.whistleEnabled,
                      onChanged: (value) => settings.setWhistleEnabled(value),
                      activeTrackColor: AppTheme.colorWork,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Display settings
                  const Text(
                    'DISPLAY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  MenuTile(
                    icon: Icons.stay_current_portrait_outlined,
                    title: 'Keep Screen On',
                    subtitle: 'Prevent screen from turning off',
                    onTap: () => settings.setKeepScreenOn(!settings.keepScreenOn),
                    trailing: Switch(
                      value: settings.keepScreenOn,
                      onChanged: (value) => settings.setKeepScreenOn(value),
                      activeTrackColor: AppTheme.colorWork,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
