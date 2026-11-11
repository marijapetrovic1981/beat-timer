import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => _goHome(context),
            tooltip: 'Go to Home',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            
            // Logo placeholder in neumorphic box
            Center(
              child: NeumorphicContainer(
                padding: const EdgeInsets.all(24),
                child: const Text(
                  '⏱️',
                  style: TextStyle(fontSize: 64),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Beat Timer',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'A simple, ad-free workout timer for Tabata and interval training.\n\nBuilt with ❤️ for fitness enthusiasts.',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
