import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/global_app_bar.dart';
import '../../../shared/widgets/global_burger_menu.dart';
import '../../activity/activity_hub_screen.dart';
import '../../profile/profile_screen.dart';
import '../../routes/routes_screen.dart';
import '../../tribe/tribe_screen.dart';

// Main tab index provider
final mainTabIndexProvider = StateProvider<int>((ref) => 0);

// State provider for the current activity section
final activitySectionProvider = StateProvider<String>((ref) => 'new_activity');

// State provider for the current profile section
final profileSectionProvider = StateProvider<String>((ref) => 'user_info');

class MainDashboardScreen extends ConsumerStatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  ConsumerState<MainDashboardScreen> createState() =>
      _MainDashboardScreenState();
}

class _MainDashboardScreenState extends ConsumerState<MainDashboardScreen> {
  // Create a scaffold key to control the drawer
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Override the navigation callback provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navigationCallbackProvider.notifier).state = _handleNavigation;
    });
  }

  // Navigation handler for the burger menu
  void _handleNavigation(BuildContext context, String routeId) {
    // Close the drawer if open
    if (scaffoldKey.currentState?.isEndDrawerOpen == true) {
      Navigator.of(context).pop();
    }

    // Set current screen ID for highlighting in the menu
    ref.read(currentScreenProvider.notifier).state = routeId;

    // Handle navigation based on route ID
    switch (routeId) {
      case 'new_activity':
      case 'all_activities':
      case 'activity_settings':
      case 'sensors':
        // Switch to Activity tab (index 1)
        ref.read(mainTabIndexProvider.notifier).state = 1;

        // Set the specific section in Activity Hub
        ref.read(activitySectionProvider.notifier).state = routeId;
        break;

      case 'routes':
      case 'create_route':
        // Switch to Routes tab (index 2)
        ref.read(mainTabIndexProvider.notifier).state = 2;
        break;

      case 'tribe':
        // Switch to Tribe tab (index 3)
        ref.read(mainTabIndexProvider.notifier).state = 3;
        break;

      case 'profile':
        // Switch to Profile tab (index 4)
        ref.read(mainTabIndexProvider.notifier).state = 4;

        // Set profile section to user_info by default
        ref.read(profileSectionProvider.notifier).state = 'user_info';
        break;

      case 'user_info':
      case 'training_zones':
      case 'app_settings':
        // Switch to Profile tab (index 4)
        ref.read(mainTabIndexProvider.notifier).state = 4;

        // Set the specific section in Profile
        ref.read(profileSectionProvider.notifier).state = routeId;
        break;

      case 'dashboard':
      default:
        // Switch to Dashboard tab (index 0)
        ref.read(mainTabIndexProvider.notifier).state = 0;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final currentTabIndex = ref.watch(mainTabIndexProvider);

    // List of screens for tab navigation
    final screens = [
      _buildDashboard(context, localizations),
      const ActivityHubScreen(),
      const RoutesScreen(),
      const TribeScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      key: scaffoldKey,
      appBar: GlobalAppBar(
        title: _getTitle(currentTabIndex, localizations),
        scaffoldKey: scaffoldKey,
        // Note: GlobalAppBar already includes the ThemeToggleButton
      ),
      endDrawer: const GlobalBurgerMenu(),
      body: screens[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        onTap: (index) {
          // Update the tab index
          ref.read(mainTabIndexProvider.notifier).state = index;

          // Update the current screen ID for the burger menu highlighting
          final screenIds = [
            'dashboard',
            'new_activity',
            'routes',
            'tribe',
            'profile'
          ];
          ref.read(currentScreenProvider.notifier).state = screenIds[index];
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: localizations.translate('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_run),
            label: localizations.translate('activity'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: localizations.translate('routes'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: localizations.translate('tribe'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localizations.translate('profile'),
          ),
        ],
      ),
    );
  }

  // Helper method to get the title based on the current tab
  String _getTitle(int tabIndex, AppLocalizations localizations) {
    switch (tabIndex) {
      case 0:
        return localizations.translate('dashboard');
      case 1:
        return localizations.translate('activity');
      case 2:
        return localizations.translate('routes');
      case 3:
        return localizations.translate('tribe');
      case 4:
        return localizations.translate('profile');
      default:
        return localizations.translate('app_name');
    }
  }

  Widget _buildDashboard(BuildContext context, AppLocalizations localizations) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              const SizedBox(height: 8),
              Text(
                localizations.translate('welcome_back'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                localizations.translate('runner'),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),

              // Quick action card
              Card(
                child: InkWell(
                  onTap: () {
                    // Navigate to activity using our handler
                    _handleNavigation(context, 'new_activity');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(
                              Theme.of(context).primaryColor.r.toInt(),
                              Theme.of(context).primaryColor.g.toInt(),
                              Theme.of(context).primaryColor.b.toInt(),
                              0.2, // Using RGBA for opacity
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.translate('start_new_activity'),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                localizations.translate('track_your_progress'),
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color.fromRGBO(170, 170, 170,
                                          1.0) // Lighter gray for dark mode
                                      : const Color.fromRGBO(100, 100, 100,
                                          1.0), // Darker gray for light mode
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color.fromRGBO(170, 170, 170,
                                  1.0) // Lighter gray for dark mode
                              : const Color.fromRGBO(130, 130, 130,
                                  1.0), // Darker gray for light mode
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Recent activities section
              Text(
                localizations.translate('recent_activities'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              // Placeholder for recent activities
              Container(
                alignment: Alignment.center,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromRGBO(
                          50, 50, 50, 1.0) // Dark gray for dark mode
                      : const Color.fromRGBO(
                          238, 238, 238, 1.0), // Light gray for light mode
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  localizations.translate('no_activities_yet'),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromRGBO(
                            200, 200, 200, 1.0) // Light gray for dark mode
                        : const Color.fromRGBO(
                            100, 100, 100, 1.0), // Dark gray for light mode
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Stats section
              Text(
                localizations.translate('your_statistics'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              // Placeholder for stats
              Container(
                alignment: Alignment.center,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromRGBO(
                          50, 50, 50, 1.0) // Dark gray for dark mode
                      : const Color.fromRGBO(
                          238, 238, 238, 1.0), // Light gray for light mode
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  localizations.translate('stats_placeholder'),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromRGBO(
                            200, 200, 200, 1.0) // Light gray for dark mode
                        : const Color.fromRGBO(
                            100, 100, 100, 1.0), // Dark gray for light mode
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
