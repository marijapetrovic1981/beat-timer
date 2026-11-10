import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../models/timer_type.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';
import '../widgets/menu_tile.dart';
import 'timer_detail_screen.dart';
import 'donate_screen.dart';
import 'settings_screen.dart';
import 'more_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<WorkoutProvider>().loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            _TimersTab(),
            SettingsScreen(),
            MoreScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        borderRadius: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.timer_outlined, Icons.timer, 'Timers'),
            _buildNavItem(1, Icons.settings_outlined, Icons.settings, 'Settings'),
            _buildNavItem(2, Icons.pending_outlined, Icons.pending, 'More'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? AppTheme.colorWork : AppTheme.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.colorWork : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimersTab extends StatelessWidget {
  const _TimersTab();

  IconData _getIconForType(TimerType type) {
    switch (type) {
      case TimerType.tabata:
        return Icons.update;
      case TimerType.rounds:
        return Icons.schedule;
      case TimerType.stopwatch:
        return Icons.alarm;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              title: Text(
                'Beat Timer',
                style: TextStyle(fontSize: 24),
              ),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Timer type cards
                  _buildTimerCard(
                    context,
                    type: TimerType.tabata,
                    workout: Workout.tabata(),
                  ),
                  const SizedBox(height: 16),
                  _buildTimerCard(
                    context,
                    type: TimerType.rounds,
                    workout: Workout.rounds(),
                  ),
                  const SizedBox(height: 16),
                  _buildTimerCard(
                    context,
                    type: TimerType.stopwatch,
                    workout: Workout.stopwatch(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Donate card
                  _buildDonateCard(context),
                  
                  // Saved timers section
                  if (provider.savedTimers.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text(
                      'Saved Timers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${provider.savedCount}/10 slots used',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...provider.savedTimers.map((workout) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildSavedTimerCard(context, workout, provider),
                    )),
                  ],
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimerCard(
    BuildContext context, {
    required TimerType type,
    required Workout workout,
  }) {
    IconData icon;
    switch (type) {
      case TimerType.tabata:
        icon = Icons.update;
        break;
      case TimerType.rounds:
        icon = Icons.schedule;
        break;
      case TimerType.stopwatch:
        icon = Icons.alarm;
        break;
    }

    return MenuTile(
      icon: icon,
      title: type.displayName,
      subtitle: type.description,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TimerDetailScreen(
              timerType: type,
              workout: workout,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDonateCard(BuildContext context) {
    return MenuTile(
      icon: Icons.favorite,
      iconColor: AppTheme.colorHeart,
      title: 'Support the App',
      subtitle: 'Free forever, no ads',
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DonateScreen(),
          ),
        );
      },
    );
  }

  Widget _buildSavedTimerCard(
    BuildContext context,
    Workout workout,
    WorkoutProvider provider,
  ) {
    return MenuTile(
      icon: _getIconForType(workout.type),
      title: workout.name,
      subtitle: '${workout.type.displayName} • ${workout.formattedTotalDuration}',
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TimerDetailScreen(
              timerType: workout.type,
              workout: workout,
            ),
          ),
        );
      },
      trailing: NeumorphicButton(
        onPressed: () => _confirmDelete(context, workout, provider),
        size: 36,
        child: const Icon(
          Icons.delete_outline,
          color: AppTheme.error,
          size: 16,
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    Workout workout,
    WorkoutProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Timer?'),
        content: Text('Are you sure you want to delete "${workout.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteWorkout(workout.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
