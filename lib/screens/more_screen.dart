import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_tile.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
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
              // TODO: Uncomment when donations are implemented
              // MenuTile(
              //   icon: Icons.favorite_outline,
              //   title: 'Support the App',
              //   subtitle: 'Leave a donation',
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const DonateScreen(),
              //       ),
              //     );
              //   },
              // ),
              // 
              // const SizedBox(height: 12),
              
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ContactScreen(),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
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
