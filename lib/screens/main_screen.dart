import 'package:flutter/material.dart';
import 'package:flutter_assiment/screens/game_screen.dart';
import 'package:flutter_assiment/screens/setting_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: const MealScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: 'Home',
            activeForegroundColor: Theme.of(
              context,
            ).colorScheme.onSecondaryContainer,
            inactiveForegroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        PersistentTabConfig(
          screen: Container(color: Colors.lime),
          item: ItemConfig(
            icon: const Icon(Icons.message),
            title: 'Messages',
            activeForegroundColor: Theme.of(
              context,
            ).colorScheme.onSecondaryContainer,
            inactiveForegroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        PersistentTabConfig(
          screen: const SettingScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: 'Settings',
            activeForegroundColor: Theme.of(
              context,
            ).colorScheme.onSecondaryContainer,
            inactiveForegroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style9BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
    );
  }
}
