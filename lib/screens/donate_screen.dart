import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Beat Timer'),
        leading: NeumorphicButton(
          onPressed: () => Navigator.of(context).pop(),
          size: 40,
          child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20),
        ),
        leadingWidth: 56,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              // Heart icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.colorRest.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '❤️',
                    style: TextStyle(fontSize: 48),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              const Text(
                'Beat Timer is Free',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Description
              const Text(
                'No ads. No subscriptions. No hidden costs.\n\nJust a simple timer for your workouts.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Donate card
              NeumorphicContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'If you enjoy the app and want to support its development, you can leave a donation.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    NeumorphicButton(
                      onPressed: () {
                        // TODO: Implement donation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Donation feature coming soon!'),
                            backgroundColor: AppTheme.colorWork,
                          ),
                        );
                      },
                      size: 56,
                      isCircle: false,
                      glowColor: AppTheme.colorRest,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite, color: AppTheme.colorRest),
                          SizedBox(width: 8),
                          Text(
                            'Donate',
                            style: TextStyle(
                              color: AppTheme.colorRest,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Thank you note
              const Text(
                'Thank you for using Beat Timer! 🙏',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
