import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';

// Provider to track the current screen
final currentScreenProvider = StateProvider<String>((ref) => "dashboard");

// Navigation structure models
class NavigationModule {
  final String name;
  final IconData icon;
  final Color color;
  final List<NavigationScreen> screens;

  NavigationModule({
    required this.name,
    required this.icon,
    required this.color,
    required this.screens,
  });
}

class NavigationScreen {
  final String name;
  final String routeId;
  final IconData icon;
  final Widget Function(BuildContext) builder;
  final bool isSelected;

  NavigationScreen({
    required this.name,
    required this.routeId,
    required this.icon,
    required this.builder,
    this.isSelected = false,
  });
}

// Provider for navigation callback function
final navigationCallbackProvider =
    StateProvider<Function(BuildContext, String)>(
        (ref) => (BuildContext context, String routeId) {
              // Default implementation that just updates the currentScreen
              // This should be overridden by the main app to handle actual navigation
              ref.read(currentScreenProvider.notifier).state = routeId;
            });

class GlobalBurgerMenu extends ConsumerWidget {
  const GlobalBurgerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final navigateToScreen = ref.watch(navigationCallbackProvider);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.translate('app_name'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Navigation modules
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _buildNavigationModules(
                    context, ref, localizations, navigateToScreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNavigationModules(
      BuildContext context,
      WidgetRef ref,
      AppLocalizations localizations,
      Function(BuildContext, String) navigateToScreen) {
    final currentScreenId = ref.watch(currentScreenProvider);

    // Define all navigation modules with their screens
    final modules = [
      // Activity Module
      NavigationModule(
        name: localizations.translate('activity'),
        icon: Icons.directions_run,
        color: Colors.blue,
        screens: [
          NavigationScreen(
            name: localizations.translate('new_activity'),
            routeId: "new_activity",
            icon: Icons.play_circle_outline,
            builder: (context) =>
                const Placeholder(), // Replace with actual screen
            isSelected: currentScreenId == "new_activity",
          ),
          NavigationScreen(
            name: localizations.translate('all_activities'),
            routeId: "all_activities",
            icon: Icons.history,
            builder: (context) =>
                const Placeholder(), // Replace with actual screen
            isSelected: currentScreenId == "all_activities",
          ),
          NavigationScreen(
            name: localizations.translate('activity_settings'),
            routeId: "activity_settings",
            icon: Icons.settings,
            builder: (context) =>
                const Placeholder(), // Replace with actual screen
            isSelected: currentScreenId == "activity_settings",
          ),
          NavigationScreen(
            name: localizations.translate('sensors'),
            routeId: "sensors",
            icon: Icons.bluetooth,
            builder: (context) =>
                const Placeholder(), // Replace with actual screen
            isSelected: currentScreenId == "sensors",
          ),
        ],
      ),

      // Routes Module
      NavigationModule(
        name: localizations.translate('routes'),
        icon: Icons.map,
        color: Colors.teal,
        screens: [
          NavigationScreen(
            name: localizations.translate('routes'),
            routeId: "routes",
            icon: Icons.map,
            builder: (context) =>
                const Placeholder(), // Replace with actual screen
            isSelected: currentScreenId == "routes",
          ),
          NavigationScreen(
            name: localizations.translate('create_route'),
            routeId: "create_route",
            icon: Icons.add_location_alt,
            builder: (context) =>
                const Placeholder(), // Replace with actual screen
            isSelected: currentScreenId == "create_route",
          ),
        ],
      ),

      // Tribe Module
      NavigationModule(
        name: localizations.translate('tribe'),
        icon: Icons.people,
        color: Colors.orange,
        screens: [
          NavigationScreen(
            name: localizations.translate('tribe'),
            routeId: "tribe",
            icon: Icons.people,
            builder: (context) =>
                const Placeholder(), // Replace with actual screen
            isSelected: currentScreenId == "tribe",
          ),
        ],
      ),

      // Profile Module
      NavigationModule(
        name: localizations.translate('profile'),
        icon: Icons.person,
        color: Colors.red,
        screens: [
          NavigationScreen(
            name: localizations.translate('profile'),
            routeId: "profile",
            icon: Icons.person,
            builder: (context) =>
                const Placeholder(), // Replace with actual screen
            isSelected: currentScreenId == "profile",
          ),
        ],
      ),
    ];

    // Build the UI for all modules
    List<Widget> menuItems = [];

    for (var module in modules) {
      // Add module header with color-coded icon
      menuItems.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(module.icon, color: module.color, size: 20),
              const SizedBox(width: 8),
              Text(
                module.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: module.color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );

      // Add all screens for this module
      for (var screen in module.screens) {
        menuItems.add(
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 32),
            leading: Icon(
              screen.icon,
              color: screen.isSelected ? module.color : Colors.grey,
            ),
            title: Text(
              screen.name,
              style: TextStyle(
                fontWeight:
                    screen.isSelected ? FontWeight.bold : FontWeight.normal,
                color: screen.isSelected ? module.color : null,
              ),
            ),
            selected: screen.isSelected,
            selectedTileColor: module.color.withAlpha(25),
            onTap: () {
              // Close the drawer
              Navigator.of(context).pop();

              // Navigate to the selected screen
              navigateToScreen(context, screen.routeId);
            },
          ),
        );
      }

      menuItems.add(const Divider(indent: 16, endIndent: 16));
    }

    return menuItems;
  }
}

// Need to add this to make compilation work - would normally be imported
