import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/routes.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final String watchlistRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    required this.watchlistRoute,
  });

  void _openHome(BuildContext context, String route) {
    if (route == currentRoute) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: const AssetImage(
                logoAssetPath,
                package: corePackageName,
              ),
              backgroundColor: Colors.grey.shade900,
            ),
            accountName: const Text('Ditonton'),
            accountEmail: const Text('ditonton@dicoding.com'),
            decoration: BoxDecoration(color: Colors.grey.shade900),
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Movies'),
            onTap: () => _openHome(context, homeMovieRoute),
          ),
          ListTile(
            leading: const Icon(Icons.tv),
            title: const Text('TV Series'),
            onTap: () => _openHome(context, homeTvSeriesRoute),
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('Watchlist'),
            onTap: () => Navigator.pushNamed(context, watchlistRoute),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => Navigator.pushNamed(context, aboutRoute),
          ),
        ],
      ),
    );
  }
}
