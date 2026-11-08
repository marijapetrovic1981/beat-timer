import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';

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
                'Sound',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              
              _SettingsTile(
                icon: Icons.volume_up_outlined,
                title: 'Sound Effects',
                subtitle: 'Play sounds during workout',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement
                  },
                  activeTrackColor: AppTheme.colorWork,
                ),
              ),
              
              const SizedBox(height: 12),
              
              _SettingsTile(
                icon: Icons.vibration_outlined,
                title: 'Vibration',
                subtitle: 'Vibrate on phase change',
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
                'Display',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              
              _SettingsTile(
                icon: Icons.stay_current_portrait_outlined,
                title: 'Keep Screen On',
                subtitle: 'Prevent screen from turning off',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement
                  },
                  activeTrackColor: AppTheme.colorWork,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Info
              Center(
                child: Text(
                  'More settings coming soon',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.colorWork.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.colorWork,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
