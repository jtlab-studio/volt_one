// lib/modules/home/screens/main_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/global_app_bar.dart';
import '../../../shared/widgets/global_burger_menu.dart';
import '../../../shared/widgets/bottom_navigation_helper.dart';
import '../../activity/activity_hub_screen.dart';
import '../../profile/profile_screen.dart';
import '../../routes/routes_screen.dart';
import '../../tribe/tribe_screen.dart';
import '../../activity/screens/start_activity_screen.dart';
import '../../activity/screens/activity_history_screen.dart';
import '../../activity/screens/activity_settings_screen.dart';
import '../../activity/screens/sensors_screen.dart';
import '../../profile/screens/hr_zones_screen.dart';
import '../../profile/screens/power_zones_screen.dart';
import '../../profile/screens/pace_zones_screen.dart';
import '../../profile/screens/user_info_screen.dart';

// Main tab index provider
final mainTabIndexProvider = StateProvider<int>((ref) => 0);

// Provider to track if we're in the Activity Hub view
final inActivityHubProvider = StateProvider<bool>((ref) => false);

// Provider to track if we're in the Routes Hub view
final inRoutesHubProvider = StateProvider<bool>((ref) => false);

// Provider to track if we're in the Tribe Hub view
final inTribeHubProvider = StateProvider<bool>((ref) => false);

// State provider for the current activity section
final activitySectionProvider = StateProvider<String>((ref) => 'new_activity');

// State provider for the current profile section
final profileSectionProvider = StateProvider<String>((ref) => 'user_info');

// State provider for the current routes section
final routesSectionProvider = StateProvider<String>((ref) => 'my_routes');

// State provider for the current tribe section
final tribeSectionProvider = StateProvider<String>((ref) => 'feed');

// Orange color to use throughout the app
final orangeColor = const Color(0xFFFF9800);

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
      // Activity Hub navigation
      case 'new_activity':
        // Switch to Activity tab (index 1) in main view
        ref.read(mainTabIndexProvider.notifier).state = 1;
        // Enter Activity Hub
        ref.read(inActivityHubProvider.notifier).state = true;
        // Set the specific section in Activity Hub
        ref.read(activitySectionProvider.notifier).state = 'new_activity';
        break;

      case 'all_activities':
      case 'analytics':
      case 'activity_settings':
      case 'sensors':
        // Switch to Activity tab in main view
        ref.read(mainTabIndexProvider.notifier).state = 1;
        // Enter Activity Hub
        ref.read(inActivityHubProvider.notifier).state = true;
        // Set the specific section in Activity Hub
        ref.read(activitySectionProvider.notifier).state = routeId;
        break;

      // Routes Hub navigation
      case 'my_routes':
      case 'discover':
      case 'create_route':
      case 'favorites':
      case 'history':
        // Switch to Routes tab (index 2) in main view
        ref.read(mainTabIndexProvider.notifier).state = 2;
        // Enter Routes Hub
        ref.read(inRoutesHubProvider.notifier).state = true;
        // Set the specific section in Routes Hub
        ref.read(routesSectionProvider.notifier).state = routeId;
        break;

      // Tribe Hub navigation
      case 'feed':
      case 'friends':
      case 'challenges':
      case 'groups':
      case 'leaderboard':
        // Switch to Tribe tab (index 3) in main view
        ref.read(mainTabIndexProvider.notifier).state = 3;
        // Enter Tribe Hub
        ref.read(inTribeHubProvider.notifier).state = true;
        // Set the specific section in Tribe Hub
        ref.read(tribeSectionProvider.notifier).state = routeId;
        break;

      // Profile Hub navigation
      case 'user_info':
      case 'hr_zones':
      case 'power_zones':
      case 'pace_zones':
      case 'app_settings':
        // Switch to Profile tab (index 4) in main view
        ref.read(mainTabIndexProvider.notifier).state = 4;
        // Set the specific section in Profile
        ref.read(profileSectionProvider.notifier).state = routeId;
        break;

      // Main tab navigation
      case 'activity':
        // Switch to Activity Hub
        ref.read(mainTabIndexProvider.notifier).state = 1;
        // Enter Activity Hub
        ref.read(inActivityHubProvider.notifier).state = true;
        break;

      case 'routes':
        // Switch to Routes Hub
        ref.read(mainTabIndexProvider.notifier).state = 2;
        // Enter Routes Hub
        ref.read(inRoutesHubProvider.notifier).state = true;
        break;

      case 'tribe':
        // Switch to Tribe Hub
        ref.read(mainTabIndexProvider.notifier).state = 3;
        // Enter Tribe Hub
        ref.read(inTribeHubProvider.notifier).state = true;
        break;

      case 'profile':
        // Switch to Profile tab (index 4) in main view
        ref.read(mainTabIndexProvider.notifier).state = 4;
        break;

      case 'dashboard':
      default:
        // Leave all Hubs if we were in them
        ref.read(inActivityHubProvider.notifier).state = false;
        ref.read(inRoutesHubProvider.notifier).state = false;
        ref.read(inTribeHubProvider.notifier).state = false;
        // Switch to Dashboard tab (index 0) in main view
        ref.read(mainTabIndexProvider.notifier).state = 0;
        break;
    }
  }

  // Custom back button handling - used with WillPopScope
  Future<bool> _handleBackButton() async {
    final currentTabIndex = ref.read(mainTabIndexProvider);
    final inActivityHub = ref.read(inActivityHubProvider);
    final inRoutesHub = ref.read(inRoutesHubProvider);
    final inTribeHub = ref.read(inTribeHubProvider);

    // If we're on the dashboard already, allow the app to exit
    if (currentTabIndex == 0) {
      return true;
    }

    // If we're in any hub, exit it first
    if (inActivityHub) {
      ref.read(inActivityHubProvider.notifier).state = false;
    } else if (inRoutesHub) {
      ref.read(inRoutesHubProvider.notifier).state = false;
    } else if (inTribeHub) {
      ref.read(inTribeHubProvider.notifier).state = false;
    }

    // Navigate to dashboard
    ref.read(mainTabIndexProvider.notifier).state = 0;
    ref.read(currentScreenProvider.notifier).state = 'dashboard';

    // Prevent the app from exiting
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final currentTabIndex = ref.watch(mainTabIndexProvider);
    final inActivityHub = ref.watch(inActivityHubProvider);
    final inRoutesHub = ref.watch(inRoutesHubProvider);
    final inTribeHub = ref.watch(inTribeHubProvider);
    final inProfileHub = currentTabIndex == 4; // Profile tab is at index 4

    // Screens for main navigation
    final mainScreens = [
      _buildDashboard(context, localizations),
      inActivityHub ? _buildActivityHub() : const ActivityHubScreen(),
      inRoutesHub ? _buildRoutesHub() : const RoutesScreen(),
      inTribeHub ? _buildTribeHub() : const TribeScreen(),
      inProfileHub ? _buildProfileHub() : const ProfileScreen(),
    ];

    // We need to use WillPopScope despite the deprecation warning since it's more reliable
    return WillPopScope(
      onWillPop: _handleBackButton,
      child: Scaffold(
        key: scaffoldKey,
        appBar: GlobalAppBar(
          title: _getTitle(currentTabIndex, inActivityHub, inRoutesHub,
              inTribeHub, localizations),
          scaffoldKey: scaffoldKey,
        ),
        endDrawer: const GlobalBurgerMenu(),
        body: SafeArea(
          // Don't add bottom padding - navigation has its own
          bottom: false,
          child: mainScreens[currentTabIndex],
        ),
        bottomNavigationBar: _buildBottomNavigation(
          context,
          currentTabIndex,
          inActivityHub,
          inRoutesHub,
          inTribeHub,
          inProfileHub,
          localizations,
        ),
        // This helps with keyboard behavior
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  // Helper to determine which bottom navigation to show
  Widget _buildBottomNavigation(
      BuildContext context,
      int currentTabIndex,
      bool inActivityHub,
      bool inRoutesHub,
      bool inTribeHub,
      bool inProfileHub,
      AppLocalizations localizations) {
    if (inActivityHub && currentTabIndex == 1) {
      return _buildActivityBottomNavBar(context, localizations);
    } else if (inRoutesHub && currentTabIndex == 2) {
      return _buildRoutesBottomNavBar(context, localizations);
    } else if (inTribeHub && currentTabIndex == 3) {
      return _buildTribeBottomNavBar(context, localizations);
    } else if (inProfileHub) {
      return _buildProfileBottomNavBar(context, localizations);
    } else {
      return _buildMainBottomNavBar(context, currentTabIndex, localizations);
    }
  }

  // Main bottom navigation bar
  Widget _buildMainBottomNavBar(
      BuildContext context, int currentIndex, AppLocalizations localizations) {
    return BottomNavigationHelper.createMainBottomNavBar(
      context,
      currentIndex,
      [
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
      (index) {
        // Exit any hub mode if we tap away from it
        if (index != 1 && ref.read(inActivityHubProvider)) {
          ref.read(inActivityHubProvider.notifier).state = false;
        }
        if (index != 2 && ref.read(inRoutesHubProvider)) {
          ref.read(inRoutesHubProvider.notifier).state = false;
        }
        if (index != 3 && ref.read(inTribeHubProvider)) {
          ref.read(inTribeHubProvider.notifier).state = false;
        }

        // Update the tab index
        ref.read(mainTabIndexProvider.notifier).state = index;

        // Enter Hub if we tap the corresponding tab
        if (index == 1) {
          ref.read(inActivityHubProvider.notifier).state = true;
          // Reset to start activity view
          ref.read(activitySectionProvider.notifier).state = 'new_activity';
        } else if (index == 2) {
          ref.read(inRoutesHubProvider.notifier).state = true;
          // Reset to my routes view
          ref.read(routesSectionProvider.notifier).state = 'my_routes';
        } else if (index == 3) {
          ref.read(inTribeHubProvider.notifier).state = true;
          // Reset to feed view
          ref.read(tribeSectionProvider.notifier).state = 'feed';
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
      selectedItemColor: orangeColor,
    );
  }

  // Activity-specific bottom navigation bar
  Widget _buildActivityBottomNavBar(
      BuildContext context, AppLocalizations localizations) {
    final currentSection = ref.watch(activitySectionProvider);

    // Create a center floating action button for the 'New' action
    final centerButton = Container(
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
    );

    return BottomNavigationHelper.createHubBottomNavBar(
      context,
      _getActivityNavIndex(currentSection),
      [
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: localizations.translate('all_activities'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bluetooth),
          label: localizations.translate('sensors'),
        ),
        // Center item (New) - will be replaced by the helper with empty container
        BottomNavigationBarItem(
          icon: Container(), // Empty container to avoid double icons
          label: localizations.translate('new_activity'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.analytics),
          label: localizations.translate('analytics'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: localizations.translate('activity_settings'),
        ),
      ],
      (index) {
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
      selectedItemColor: orangeColor,
      centerButton: centerButton,
    );
  }

  // Routes-specific bottom navigation bar
  Widget _buildRoutesBottomNavBar(
      BuildContext context, AppLocalizations localizations) {
    final currentSection = ref.watch(routesSectionProvider);

    // Create a center button for create route
    final centerButton = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getRoutesNavIndex(currentSection) == 2
            ? orangeColor.withAlpha(50)
            : orangeColor.withAlpha(30),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(
        Icons.add_location_alt,
        color:
            _getRoutesNavIndex(currentSection) == 2 ? orangeColor : Colors.grey,
        size: 28,
      ),
    );

    return BottomNavigationHelper.createHubBottomNavBar(
      context,
      _getRoutesNavIndex(currentSection),
      [
        BottomNavigationBarItem(
          icon: const Icon(Icons.route),
          label: localizations.translate('my_routes'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.explore),
          label: localizations.translate('discover'),
        ),
        // Center item (Create) - will be replaced with empty container
        BottomNavigationBarItem(
          icon: Container(), // Empty container to avoid double icons
          label: localizations.translate('create_route'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: localizations.translate('favorites'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: localizations.translate('history'),
        ),
      ],
      (index) {
        // Map the tapped index to the corresponding section
        final sections = [
          'my_routes',
          'discover',
          'create_route',
          'favorites',
          'history'
        ];
        final selectedSection = sections[index];

        // Update the routes section
        ref.read(routesSectionProvider.notifier).state = selectedSection;

        // Update the current screen ID for the burger menu highlighting
        ref.read(currentScreenProvider.notifier).state = selectedSection;
      },
      selectedItemColor: orangeColor,
      centerButton: centerButton,
    );
  }

  // Tribe-specific bottom navigation bar
  Widget _buildTribeBottomNavBar(
      BuildContext context, AppLocalizations localizations) {
    final currentSection = ref.watch(tribeSectionProvider);

    // Create a center button for challenges
    final centerButton = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getTribeNavIndex(currentSection) == 2
            ? orangeColor.withAlpha(50)
            : orangeColor.withAlpha(30),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(
        Icons.emoji_events,
        color:
            _getTribeNavIndex(currentSection) == 2 ? orangeColor : Colors.grey,
        size: 28,
      ),
    );

    return BottomNavigationHelper.createHubBottomNavBar(
      context,
      _getTribeNavIndex(currentSection),
      [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dynamic_feed),
          label: localizations.translate('feed'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_add),
          label: localizations.translate('friends'),
        ),
        // Center item (Challenges) - will be replaced with empty container
        BottomNavigationBarItem(
          icon: Container(), // Empty container to avoid double icons
          label: localizations.translate('challenges'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.group),
          label: localizations.translate('groups'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.leaderboard),
          label: localizations.translate('leaderboard'),
        ),
      ],
      (index) {
        // Map the tapped index to the corresponding section
        final sections = [
          'feed',
          'friends',
          'challenges',
          'groups',
          'leaderboard'
        ];
        final selectedSection = sections[index];

        // Update the tribe section
        ref.read(tribeSectionProvider.notifier).state = selectedSection;

        // Update the current screen ID for the burger menu highlighting
        ref.read(currentScreenProvider.notifier).state = selectedSection;
      },
      selectedItemColor: orangeColor,
      centerButton: centerButton,
    );
  }

  // Profile-specific bottom navigation bar
  Widget _buildProfileBottomNavBar(
      BuildContext context, AppLocalizations localizations) {
    final currentSection = ref.watch(profileSectionProvider);

    return BottomNavigationHelper.createMainBottomNavBar(
      context,
      _getProfileNavIndex(currentSection),
      [
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: localizations.translate('user_info'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: localizations.translate('hr_zones'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.flash_on),
          label: localizations.translate('power_zones'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.speed),
          label: localizations.translate('pace_zones'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: localizations.translate('app_settings'),
        ),
      ],
      (index) {
        // Map the tapped index to the corresponding section
        final sections = [
          'user_info',
          'hr_zones',
          'power_zones',
          'pace_zones',
          'app_settings'
        ];
        final selectedSection = sections[index];

        // Update the profile section
        ref.read(profileSectionProvider.notifier).state = selectedSection;

        // Update the current screen ID for the burger menu highlighting
        ref.read(currentScreenProvider.notifier).state = selectedSection;
      },
      selectedItemColor: orangeColor,
    );
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

  // When in Routes Hub, show the specific content based on the selected section
  Widget _buildRoutesHub() {
    final routesSection = ref.watch(routesSectionProvider);

    switch (routesSection) {
      case 'my_routes':
        return _buildRoutesPlaceholder(
            'My Routes', 'View and manage your saved routes');
      case 'discover':
        return _buildRoutesPlaceholder(
            'Discover Routes', 'Explore popular routes nearby');
      case 'create_route':
        return _buildRoutesPlaceholder(
            'Create Route', 'Design new running routes');
      case 'favorites':
        return _buildRoutesPlaceholder(
            'Favorite Routes', 'Your favorite running routes');
      case 'history':
        return _buildRoutesPlaceholder(
            'Route History', 'Routes you\'ve run in the past');
      default:
        return _buildRoutesPlaceholder(
            'My Routes', 'View and manage your saved routes');
    }
  }

  // Helper to build routes placeholders
  Widget _buildRoutesPlaceholder(String title, String description) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.map, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  // When in Tribe Hub, show the specific content based on the selected section
  Widget _buildTribeHub() {
    final tribeSection = ref.watch(tribeSectionProvider);

    switch (tribeSection) {
      case 'feed':
        return _buildTribePlaceholder(
            'Activity Feed', 'See what your friends are up to');
      case 'friends':
        return _buildTribePlaceholder('Friends', 'Manage your connections');
      case 'challenges':
        return _buildTribePlaceholder(
            'Challenges', 'Compete with friends and groups');
      case 'groups':
        return _buildTribePlaceholder(
            'Groups', 'Your running groups and clubs');
      case 'leaderboard':
        return _buildTribePlaceholder(
            'Leaderboards', 'See how you rank among your peers');
      default:
        return _buildTribePlaceholder(
            'Activity Feed', 'See what your friends are up to');
    }
  }

  // Helper to build tribe placeholders
  Widget _buildTribePlaceholder(String title, String description) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  // When in Profile Hub, show the content based on the selected section
  Widget _buildProfileHub() {
    final profileSection = ref.watch(profileSectionProvider);

    switch (profileSection) {
      case 'user_info':
        return const UserInfoScreen();
      case 'hr_zones':
        return const HRZonesScreen();
      case 'power_zones':
        return const PowerZonesScreen();
      case 'pace_zones':
        return const PaceZonesScreen();
      case 'app_settings':
        // Use a placeholder for app settings
        return _buildProfilePlaceholder(
            'App Settings', 'Configure application settings');
      default:
        return const UserInfoScreen();
    }
  }

  // Helper to build profile placeholders
  Widget _buildProfilePlaceholder(String title, String description) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  // Dashboard screen content
  Widget _buildDashboard(BuildContext context, AppLocalizations localizations) {
    return SafeArea(
      // Don't add extra padding at the bottom since the navigation bar handles it
      bottom: false,
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
                            color: const Color.fromRGBO(
                                255, 152, 0, 0.2), // Orange with transparency
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Color.fromRGBO(255, 152, 0, 1.0), // Orange
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

  // Helper method to get the title based on current view
  String _getTitle(int tabIndex, bool inActivityHub, bool inRoutesHub,
      bool inTribeHub, AppLocalizations localizations) {
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
        case 'analytics':
          return 'Analytics';
        default:
          return localizations.translate('activity');
      }
    }

    // If we're in the Routes Hub
    if (inRoutesHub && tabIndex == 2) {
      final routesSection = ref.watch(routesSectionProvider);
      switch (routesSection) {
        case 'my_routes':
          return 'My Routes';
        case 'discover':
          return 'Discover Routes';
        case 'create_route':
          return 'Create Route';
        case 'favorites':
          return 'Favorite Routes';
        case 'history':
          return 'Route History';
        default:
          return localizations.translate('routes');
      }
    }

    // If we're in the Tribe Hub
    if (inTribeHub && tabIndex == 3) {
      final tribeSection = ref.watch(tribeSectionProvider);
      switch (tribeSection) {
        case 'feed':
          return 'Activity Feed';
        case 'friends':
          return 'Friends';
        case 'challenges':
          return 'Challenges';
        case 'groups':
          return 'Groups';
        case 'leaderboard':
          return 'Leaderboards';
        default:
          return localizations.translate('tribe');
      }
    }

    // If we're in the Profile Hub
    if (tabIndex == 4) {
      final profileSection = ref.watch(profileSectionProvider);
      switch (profileSection) {
        case 'user_info':
          return 'User';
        case 'hr_zones':
          return 'Cardio';
        case 'power_zones':
          return 'Power';
        case 'pace_zones':
          return 'Pacing';
        case 'app_settings':
          return 'Settings';
        default:
          return localizations.translate('profile');
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

  // Helper method to determine which index is active in the activity navigation bar
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

  // Helper to determine which index is active in the routes navigation bar
  int _getRoutesNavIndex(String section) {
    switch (section) {
      case 'my_routes':
        return 0;
      case 'discover':
        return 1;
      case 'create_route':
        return 2; // Center position
      case 'favorites':
        return 3;
      case 'history':
        return 4;
      default:
        return 0; // Default to my routes
    }
  }

  // Helper to determine which index is active in the tribe navigation bar
  int _getTribeNavIndex(String section) {
    switch (section) {
      case 'feed':
        return 0;
      case 'friends':
        return 1;
      case 'challenges':
        return 2; // Center position
      case 'groups':
        return 3;
      case 'leaderboard':
        return 4;
      default:
        return 0; // Default to feed
    }
  }

  // Helper to determine which index is active in the profile navigation bar
  int _getProfileNavIndex(String section) {
    switch (section) {
      case 'user_info':
        return 0;
      case 'hr_zones':
        return 1;
      case 'power_zones':
        return 2;
      case 'pace_zones':
        return 3;
      case 'app_settings':
        return 4;
      default:
        return 0; // Default to user info
    }
  }
}
