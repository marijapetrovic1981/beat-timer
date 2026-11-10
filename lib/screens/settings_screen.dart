import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          title: Text('Settings'),
          centerTitle: false,
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
                onTap: () {},
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement
                  },
                  activeTrackColor: AppTheme.colorWork,
                ),
              ),
              
              const SizedBox(height: 12),
              
              MenuTile(
                icon: Icons.vibration_outlined,
                title: 'Vibration',
                subtitle: 'Vibrate on phase change',
                onTap: () {},
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement
                  },
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
                onTap: () {},
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement
                  },
                  activeTrackColor: AppTheme.colorWork,
                ),
              ),
              

            ]),
          ),
        ),
      ],
    );
  }
}
