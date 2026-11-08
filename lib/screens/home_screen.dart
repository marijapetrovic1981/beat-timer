import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../models/timer_type.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: NeumorphicContainer(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        borderRadius: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.timer_outlined, Icons.timer, 'Timers'),
            _buildNavItem(1, Icons.settings_outlined, Icons.settings, 'Settings'),
            _buildNavItem(2, Icons.more_horiz_outlined, Icons.more_horiz, 'More'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: isSelected
            ? BoxDecoration(
                color: AppTheme.colorWork.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Row(
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppTheme.colorWork : AppTheme.textSecondary,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.colorWork,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimersTab extends StatelessWidget {
  const _TimersTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              title: Text('Beat Timer'),
              centerTitle: false,
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
    return NeumorphicContainer(
      padding: const EdgeInsets.all(20),
      child: InkWell(
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
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.colorWork.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  type.icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.displayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonateCard(BuildContext context) {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DonateScreen(),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.colorRest.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  '❤️',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support the App',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Free forever, no ads',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedTimerCard(
    BuildContext context,
    Workout workout,
    WorkoutProvider provider,
  ) {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(16),
      child: InkWell(
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
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.colorWork.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  workout.type.icon,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${workout.type.displayName} • ${workout.formattedTotalDuration}',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            NeumorphicButton(
              onPressed: () => _confirmDelete(context, workout, provider),
              size: 36,
              child: const Icon(
                Icons.delete_outline,
                color: AppTheme.error,
                size: 16,
              ),
            ),
          ],
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
