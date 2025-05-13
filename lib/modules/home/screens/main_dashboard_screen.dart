// lib/modules/home/screens/main_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/global_app_bar.dart';
import '../../../shared/widgets/global_burger_menu.dart';
import '../../activity/activity_hub_screen.dart';
import '../../profile/profile_screen.dart';
import '../../routes/routes_screen.dart';
import '../../tribe/tribe_screen.dart';
import '../../activity/screens/start_activity_screen.dart';
import '../../activity/screens/activity_history_screen.dart';
import '../../activity/screens/activity_settings_screen.dart';
import '../../activity/screens/sensors_screen.dart';

// Main tab index provider
final mainTabIndexProvider = StateProvider<int>((ref) => 0);

// Provider to track if we're in the Activity Hub view
final inActivityHubProvider = StateProvider<bool>((ref) => false);

// State provider for the current activity section
final activitySectionProvider = StateProvider<String>((ref) => 'new_activity');

// State provider for the current profile section
final profileSectionProvider = StateProvider<String>((ref) => 'user_info');

class MainDashboardScreen extends ConsumerWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: _MainDashboardContent(),
    );
  }
}

class _MainDashboardContent extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MainDashboardContent> createState() =>
      _MainDashboardContentState();
}

class _MainDashboardContentState extends ConsumerState<_MainDashboardContent> {
  // Create a scaffold key to control the drawer
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Color orangeColor =
      const Color.fromRGBO(255, 152, 0, 1.0); // Consistent orange color

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
        // Switch to Activity tab (index 1) in main view
        ref.read(mainTabIndexProvider.notifier).state = 1;
        // Enter Activity Hub
        ref.read(inActivityHubProvider.notifier).state = true;
        // Set the specific section in Activity Hub
        ref.read(activitySectionProvider.notifier).state = 'new_activity';
        break;

      case 'all_activities':
      case 'activity_settings':
      case 'sensors':
        // Switch to Activity tab in main view
        ref.read(mainTabIndexProvider.notifier).state = 1;
        // Enter Activity Hub
        ref.read(inActivityHubProvider.notifier).state = true;
        // Set the specific section in Activity Hub
        ref.read(activitySectionProvider.notifier).state = routeId;
        break;

      case 'routes':
      case 'create_route':
        // Leave Activity Hub if we were in it
        ref.read(inActivityHubProvider.notifier).state = false;
        // Switch to Routes tab (index 2) in main view
        ref.read(mainTabIndexProvider.notifier).state = 2;
        break;

      case 'tribe':
        // Leave Activity Hub if we were in it
        ref.read(inActivityHubProvider.notifier).state = false;
        // Switch to Tribe tab (index 3) in main view
        ref.read(mainTabIndexProvider.notifier).state = 3;
        break;

      case 'profile':
        // Leave Activity Hub if we were in it
        ref.read(inActivityHubProvider.notifier).state = false;
        // Switch to Profile tab (index 4) in main view
        ref.read(mainTabIndexProvider.notifier).state = 4;
        // Set profile section to user_info by default
        ref.read(profileSectionProvider.notifier).state = 'user_info';
        break;

      case 'user_info':
      case 'training_zones':
      case 'app_settings':
        // Leave Activity Hub if we were in it
        ref.read(inActivityHubProvider.notifier).state = false;
        // Switch to Profile tab (index 4) in main view
        ref.read(mainTabIndexProvider.notifier).state = 4;
        // Set the specific section in Profile
        ref.read(profileSectionProvider.notifier).state = routeId;
        break;

      case 'activity':
        // Switch to Activity Hub
        ref.read(mainTabIndexProvider.notifier).state = 1;
        // Enter Activity Hub
        ref.read(inActivityHubProvider.notifier).state = true;
        break;

      case 'analytics':
        // Switch to Activity Hub
        ref.read(mainTabIndexProvider.notifier).state = 1;
        // Enter Activity Hub
        ref.read(inActivityHubProvider.notifier).state = true;
        // Set the analytics section
        ref.read(activitySectionProvider.notifier).state = 'analytics';
        break;

      case 'dashboard':
      default:
        // Leave Activity Hub if we were in it
        ref.read(inActivityHubProvider.notifier).state = false;
        // Switch to Dashboard tab (index 0) in main view
        ref.read(mainTabIndexProvider.notifier).state = 0;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final currentTabIndex = ref.watch(mainTabIndexProvider);
    final inActivityHub = ref.watch(inActivityHubProvider);

    // Screens for main navigation
    final mainScreens = [
      _buildDashboard(context, localizations),
      inActivityHub ? _buildActivityHub() : const ActivityHubScreen(),
      const RoutesScreen(),
      const TribeScreen(),
      const ProfileScreen(),
    ];

    return PopScope(
      canPop: currentTabIndex == 0,
      onPopInvoked: (didPop) {
        if (didPop) return;

        // If we're on the dashboard already, let the system handle it (exit app)
        if (currentTabIndex == 0) return;

        // If we're in activity hub, exit it first
        if (inActivityHub) {
          ref.read(inActivityHubProvider.notifier).state = false;
        }

        // Navigate to dashboard
        ref.read(mainTabIndexProvider.notifier).state = 0;
        ref.read(currentScreenProvider.notifier).state = 'dashboard';
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: GlobalAppBar(
          title: _getTitle(currentTabIndex, inActivityHub, localizations),
          scaffoldKey: scaffoldKey,
        ),
        endDrawer: const GlobalBurgerMenu(),
        body: mainScreens[currentTabIndex],
        bottomNavigationBar: inActivityHub && currentTabIndex == 1
            ? _buildActivityBottomNavBar(context, localizations)
            : _buildMainBottomNavBar(context, currentTabIndex, localizations),
      ),
    );
  }

  // Helper method to get the title based on current view
  String _getTitle(
      int tabIndex, bool inActivityHub, AppLocalizations localizations) {
    // If we're in the Activity Hub
    if (inActivityHub && tabIndex == 1) {
      final activitySection = ref.watch(activitySectionProvider);
      switch (activitySection) {
        case 'new_activity':
          return localizations.translate('new_activity');
        case 'all_activities':
          return localizations.translate('all_activities');
        case 'activity_settings':
          return localizations.translate('activity_settings');
        case 'sensors':
          return localizations.translate('sensors');
        default:
          return localizations.translate('activity');
      }
    }

    // Standard titles for main tabs
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

  // When in Activity Hub, we show the specific content based on the selected section
  Widget _buildActivityHub() {
    final activitySection = ref.watch(activitySectionProvider);

    switch (activitySection) {
      case 'new_activity':
        return const StartActivityScreen();
      case 'all_activities':
        return const ActivityHistoryScreen();
      case 'analytics':
        return _buildAnalyticsPlaceholder(); // Placeholder until analytics is implemented
      case 'activity_settings':
        return const ActivitySettingsScreen();
      case 'sensors':
        return const SensorsScreen();
      default:
        // Default to Start Activity screen
        return const StartActivityScreen();
    }
  }

  // Placeholder for analytics screen until it's implemented
  Widget _buildAnalyticsPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.analytics, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Analytics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'This feature is coming soon!',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Main bottom navigation bar
  Widget _buildMainBottomNavBar(
      BuildContext context, int currentIndex, AppLocalizations localizations) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        // Exit Activity Hub mode if we tap away from activity
        if (index != 1 && ref.read(inActivityHubProvider)) {
          ref.read(inActivityHubProvider.notifier).state = false;
        }

        // Update the tab index
        ref.read(mainTabIndexProvider.notifier).state = index;

        // Enter Activity Hub if we tap the activity tab
        if (index == 1) {
          ref.read(inActivityHubProvider.notifier).state = true;
          // Reset to start activity view
          ref.read(activitySectionProvider.notifier).state = 'new_activity';
        }

        // Update the current screen ID for the burger menu highlighting
        final screenIds = [
          'dashboard',
          'activity',
          'routes',
          'tribe',
          'profile'
        ];
        ref.read(currentScreenProvider.notifier).state = screenIds[index];
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: orangeColor,
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
    );
  }

  // Activity-specific bottom navigation bar
  Widget _buildActivityBottomNavBar(
      BuildContext context, AppLocalizations localizations) {
    final currentSection = ref.watch(activitySectionProvider);

    return BottomNavigationBar(
      currentIndex: _getActivityNavIndex(currentSection),
      onTap: (index) {
        // Map the tapped index to the corresponding section
        final sections = [
          'all_activities',
          'sensors',
          'new_activity',
          'analytics',
          'activity_settings'
        ];
        final selectedSection = sections[index];

        // Update the activity section
        ref.read(activitySectionProvider.notifier).state = selectedSection;

        // Update the current screen ID for the burger menu highlighting
        ref.read(currentScreenProvider.notifier).state = selectedSection;
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: orangeColor,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: 'Activities',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bluetooth),
          label: 'Sensors',
        ),
        // Center item (New)
        BottomNavigationBarItem(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getActivityNavIndex(currentSection) == 2
                  ? orangeColor.withAlpha(50)
                  : orangeColor.withAlpha(30),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.add,
              color: _getActivityNavIndex(currentSection) == 2
                  ? orangeColor
                  : Colors.grey,
              size: 28, // Slightly larger icon
            ),
          ),
          label: 'New',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.analytics),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: 'Config',
        ),
      ],
    );
  }

  // Helper to determine which index is active in the activity navigation bar
  int _getActivityNavIndex(String section) {
    switch (section) {
      case 'all_activities':
        return 0;
      case 'sensors':
        return 1;
      case 'new_activity':
        return 2; // Center position
      case 'analytics':
        return 3;
      case 'activity_settings':
        return 4;
      default:
        return 2; // Default to new activity (center)
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
