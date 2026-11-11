import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const String _email = 'beattimer.info@gmail.com';

  void _copyEmail(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: _email));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email copied to clipboard'),
        backgroundColor: AppTheme.colorWork,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            
            const Text(
              'Have a question, suggestion, or found a bug?\nWe\'d love to hear from you!',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            NeumorphicContainer(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mail_outline,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      _email,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => _copyEmail(context),
                    tooltip: 'Copy email',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
