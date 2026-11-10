import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'neumorphic_container.dart';

class RoundIndicator extends StatelessWidget {
  final int currentRound;
  final int totalRounds;
  final int currentCycle;
  final int totalCycles;

  const RoundIndicator({
    super.key,
    required this.currentRound,
    required this.totalRounds,
    this.currentCycle = 1,
    this.totalCycles = 1,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      borderRadius: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCounter('ROUND', currentRound, totalRounds),
          if (totalCycles > 1) ...[
            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: AppTheme.shadowLight,
            ),
            _buildCounter('CYCLE', currentCycle, totalCycles),
          ],
        ],
      ),
    );
  }

  Widget _buildCounter(String label, int current, int total) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$current',
                style: const TextStyle(
                  color: AppTheme.colorWork,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '/$total',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
