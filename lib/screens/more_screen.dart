import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_tile.dart';
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
              MenuTile(
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
              
              MenuTile(
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
              
              MenuTile(
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
              
              MenuTile(
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
              
              MenuTile(
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
