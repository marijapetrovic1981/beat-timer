import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';
import 'donate_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          title: Text('More'),
          centerTitle: false,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _MoreTile(
                icon: Icons.favorite_outline,
                title: 'Support the App',
                subtitle: 'Leave a donation',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DonateScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              _MoreTile(
                icon: Icons.star_outline,
                title: 'Rate the App',
                subtitle: 'Leave a review on the store',
                onTap: () {
                  // TODO: Implement - open app store
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coming soon!'),
                      backgroundColor: AppTheme.colorWork,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              _MoreTile(
                icon: Icons.share_outlined,
                title: 'Share',
                subtitle: 'Tell your friends about Beat Timer',
                onTap: () {
                  // TODO: Implement - share app
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coming soon!'),
                      backgroundColor: AppTheme.colorWork,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              _MoreTile(
                icon: Icons.mail_outline,
                title: 'Contact',
                subtitle: 'Send feedback or report a bug',
                onTap: () {
                  // TODO: Implement - open email
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coming soon!'),
                      backgroundColor: AppTheme.colorWork,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              _MoreTile(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Beat Timer',
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.colorWork.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('⏱️', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    children: [
                      const Text(
                        'A simple workout timer for Tabata, intervals, and more.',
                      ),
                    ],
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
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
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
