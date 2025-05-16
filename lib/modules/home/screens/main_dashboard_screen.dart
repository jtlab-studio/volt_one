// lib/modules/home/screens/main_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/bottom_navigation_helper.dart';
import '../../../shared/widgets/global_app_bar.dart'; // Import GlobalAppBar
import '../../activity/activity_hub_screen.dart';
import '../../routes/routes_screen.dart';
import '../../tribe/tribe_screen.dart';
import '../../../modules/settings/settings_module.dart'; // Import settings module
import '../../activity/screens/start_activity_screen.dart';
import '../../activity/screens/activity_history_screen.dart';

// Main tab index provider
final mainTabIndexProvider = StateProvider<int>((ref) => 0);

// Provider to track if we're in the Activity Hub view
final inActivityHubProvider = StateProvider<bool>((ref) => false);

// Provider to track if we're in the Routes Hub view
final inRoutesHubProvider = StateProvider<bool>((ref) => false);

// Provider to track if we're in the Tribe Hub view
final inTribeHubProvider = StateProvider<bool>((ref) => false);

// Provider to track the current activity section
final activitySectionProvider = StateProvider<String>((ref) => 'new_activity');

// Provider to track the current routes section
final routesSectionProvider = StateProvider<String>((ref) => 'my_routes');

// Provider to track the current tribe section
final tribeSectionProvider = StateProvider<String>((ref) => 'feed');

// Orange color to use throughout the app
final orangeColor = const Color(0xFFFF9800);

// Used for navigation callbacks
final currentScreenProvider = StateProvider<String>((ref) => "dashboard");

class MainDashboardScreen extends ConsumerStatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  ConsumerState<MainDashboardScreen> createState() =>
      _MainDashboardScreenState();
}

class _MainDashboardScreenState extends ConsumerState<MainDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final currentTabIndex = ref.watch(mainTabIndexProvider);
    final inActivityHub = ref.watch(inActivityHubProvider);
    final inRoutesHub = ref.watch(inRoutesHubProvider);
    final inTribeHub = ref.watch(inTribeHubProvider);

    // Screens for main navigation (only 4 tabs now - removed Settings)
    final mainScreens = [
      _buildDashboard(context, localizations),
      inActivityHub ? _buildActivityHub() : const ActivityHubScreen(),
      inRoutesHub ? _buildRoutesHub() : const RoutesScreen(),
      inTribeHub ? _buildTribeHub() : const TribeScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _handleBackButton();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: GlobalAppBar(
          title: _getTitle(currentTabIndex, inActivityHub, inRoutesHub,
              inTribeHub, localizations),
        ),
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
          localizations,
        ),
        // This helps with keyboard behavior
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  // Custom back button handling
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

  // Helper to determine which bottom navigation to show
  Widget _buildBottomNavigation(
    BuildContext context,
    int currentTabIndex,
    bool inActivityHub,
    bool inRoutesHub,
    bool inTribeHub,
    AppLocalizations localizations,
  ) {
    if (inActivityHub && currentTabIndex == 1) {
      return _buildActivityBottomNavBar(context, localizations);
    } else if (inRoutesHub && currentTabIndex == 2) {
      return _buildRoutesBottomNavBar(context, localizations);
    } else if (inTribeHub && currentTabIndex == 3) {
      return _buildTribeBottomNavBar(context, localizations);
    } else {
      return _buildMainBottomNavBar(context, currentTabIndex, localizations);
    }
  }

  // Main bottom navigation bar - updated to only have 4 tabs
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

        // Update the current screen ID
        final screenIds = [
          'dashboard',
          'activity',
          'routes',
          'tribe',
        ];
        ref.read(currentScreenProvider.notifier).state = screenIds[index];
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }

  // Activity-specific bottom navigation bar
  Widget _buildActivityBottomNavBar(
      BuildContext context, AppLocalizations localizations) {
    final currentSection = ref.watch(activitySectionProvider);

    return BottomNavigationHelper.createMainBottomNavBar(
      context,
      _getActivityNavIndex(currentSection),
      [
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: localizations.translate('all_activities'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.play_circle_outline),
          label: localizations.translate('new_activity'),
        ),
      ],
      (index) {
        // Map the tapped index to the corresponding section
        final sections = [
          'all_activities',
          'new_activity',
        ];
        final selectedSection = sections[index];

        // Update the activity section
        ref.read(activitySectionProvider.notifier).state = selectedSection;

        // Update the current screen ID
        ref.read(currentScreenProvider.notifier).state = selectedSection;
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }

  // Helper to determine which index is active in the activity navigation bar
  int _getActivityNavIndex(String section) {
    switch (section) {
      case 'all_activities':
        return 0;
      case 'new_activity':
        return 1;
      default:
        return 1; // Default to new activity
    }
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
            ? Colors.blue.withAlpha(50)
            : Colors.grey.withAlpha(30),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(
        Icons.add_location_alt,
        color:
            _getRoutesNavIndex(currentSection) == 2 ? Colors.blue : Colors.grey,
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
          label: localizations.translate('discover_routes'),
        ),
        // Center item (Create) - will be replaced with empty container
        BottomNavigationBarItem(
          icon: Container(), // Empty container to avoid double icons
          label: localizations.translate('create_route'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: localizations.translate('favorite_routes'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: localizations.translate('route_history'),
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

        // Update the current screen ID
        ref.read(currentScreenProvider.notifier).state = selectedSection;
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      centerButton: centerButton,
    );
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

  // Tribe-specific bottom navigation bar
  Widget _buildTribeBottomNavBar(
      BuildContext context, AppLocalizations localizations) {
    final currentSection = ref.watch(tribeSectionProvider);

    // Create a center button for challenges
    final centerButton = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getTribeNavIndex(currentSection) == 2
            ? Colors.blue.withAlpha(50)
            : Colors.grey.withAlpha(30),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(
        Icons.emoji_events,
        color:
            _getTribeNavIndex(currentSection) == 2 ? Colors.blue : Colors.grey,
        size: 28,
      ),
    );

    return BottomNavigationHelper.createHubBottomNavBar(
      context,
      _getTribeNavIndex(currentSection),
      [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dynamic_feed),
          label: localizations.translate('activity_feed'),
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
          label: localizations.translate('leaderboards'),
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

        // Update the current screen ID
        ref.read(currentScreenProvider.notifier).state = selectedSection;
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      centerButton: centerButton,
    );
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
    final localizations = AppLocalizations.of(context);

    switch (routesSection) {
      case 'my_routes':
        return _buildRoutesPlaceholder(localizations.translate('my_routes'),
            localizations.translate('my_routes_description'));
      case 'discover':
        return _buildRoutesPlaceholder(
            localizations.translate('discover_routes'),
            localizations.translate('discover_routes_description'));
      case 'create_route':
        return _buildRoutesPlaceholder(localizations.translate('create_route'),
            localizations.translate('create_route_description'));
      case 'favorites':
        return _buildRoutesPlaceholder(
            localizations.translate('favorite_routes'),
            localizations.translate('favorite_routes_description'));
      case 'history':
        return _buildRoutesPlaceholder(localizations.translate('route_history'),
            localizations.translate('route_history_description'));
      default:
        return _buildRoutesPlaceholder(localizations.translate('my_routes'),
            localizations.translate('my_routes_description'));
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
    final localizations = AppLocalizations.of(context);

    switch (tribeSection) {
      case 'feed':
        return _buildTribePlaceholder(localizations.translate('activity_feed'),
            localizations.translate('activity_feed_description'));
      case 'friends':
        return _buildTribePlaceholder(localizations.translate('friends'),
            localizations.translate('friends_description'));
      case 'challenges':
        return _buildTribePlaceholder(localizations.translate('challenges'),
            localizations.translate('challenges_description'));
      case 'groups':
        return _buildTribePlaceholder(localizations.translate('groups'),
            localizations.translate('groups_description'));
      case 'leaderboard':
        return _buildTribePlaceholder(localizations.translate('leaderboards'),
            localizations.translate('leaderboards_description'));
      default:
        return _buildTribePlaceholder(localizations.translate('activity_feed'),
            localizations.translate('activity_feed_description'));
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
                    // Navigate to activity
                    ref.read(mainTabIndexProvider.notifier).state = 1;
                    ref.read(inActivityHubProvider.notifier).state = true;
                    ref.read(activitySectionProvider.notifier).state =
                        'new_activity';
                    ref.read(currentScreenProvider.notifier).state =
                        'new_activity';
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Color(0xFFFF9800), // Orange
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
        case 'analytics':
          return localizations.translate('analytics');
        default:
          return localizations.translate('activity');
      }
    }

    // If we're in the Routes Hub
    if (inRoutesHub && tabIndex == 2) {
      final routesSection = ref.watch(routesSectionProvider);
      switch (routesSection) {
        case 'my_routes':
          return localizations.translate('my_routes');
        case 'discover':
          return localizations.translate('discover_routes');
        case 'create_route':
          return localizations.translate('create_route');
        case 'favorites':
          return localizations.translate('favorite_routes');
        case 'history':
          return localizations.translate('route_history');
        default:
          return localizations.translate('routes');
      }
    }

    // If we're in the Tribe Hub
    if (inTribeHub && tabIndex == 3) {
      final tribeSection = ref.watch(tribeSectionProvider);
      switch (tribeSection) {
        case 'feed':
          return localizations.translate('activity_feed');
        case 'friends':
          return localizations.translate('friends');
        case 'challenges':
          return localizations.translate('challenges');
        case 'groups':
          return localizations.translate('groups');
        case 'leaderboard':
          return localizations.translate('leaderboards');
        default:
          return localizations.translate('tribe');
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
      default:
        return localizations.translate('app_name');
    }
  }
}
