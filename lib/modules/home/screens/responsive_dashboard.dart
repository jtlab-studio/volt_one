import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../responsive/screen_type.dart';
import '../../../core/theme/app_colors.dart';
import '../../activity/activity_hub_screen.dart';
import '../../settings/settings_module.dart';

// Main tab index provider
final mainTabIndexProvider = StateProvider<int>((ref) => 0);

class ResponsiveDashboard extends ConsumerStatefulWidget {
  const ResponsiveDashboard({super.key});

  @override
  ConsumerState<ResponsiveDashboard> createState() =>
      _ResponsiveDashboardState();
}

class _ResponsiveDashboardState extends ConsumerState<ResponsiveDashboard> {
  @override
  Widget build(BuildContext context) {
    // Fixed method signature - removed WidgetRef parameter
    final localizations = AppLocalizations.of(context);
    final currentTabIndex = ref.watch(mainTabIndexProvider);
    final screenType = getScreenType(context);

    // Define main screens - no settings here since it's accessed from the header
    final mainScreens = [
      _buildDashboardContent(context, localizations),
      const ActivityHubScreen(),
    ];

    // Use different layouts based on screen size
    if (screenType == ScreenType.desktop) {
      return _buildDesktopLayout(
          context, localizations, currentTabIndex, mainScreens);
    } else if (screenType == ScreenType.tablet) {
      return _buildTabletLayout(
          context, localizations, currentTabIndex, mainScreens);
    } else {
      return _buildMobileLayout(
          context, localizations, currentTabIndex, mainScreens);
    }
  }

  Widget _buildDesktopLayout(
      BuildContext context,
      AppLocalizations localizations,
      int currentTabIndex,
      List<Widget> screens) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(currentTabIndex, localizations)),
        actions: [
          // Add settings button in appbar for quick access
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: localizations.translate('settings'),
            onPressed: () {
              _openSettingsScreen(context);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar navigation
          NavigationRail(
            extended: true,
            selectedIndex: currentTabIndex,
            onDestinationSelected: (index) {
              ref.read(mainTabIndexProvider.notifier).state = index;
            },
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.dashboard),
                label: Text(localizations.translate('dashboard')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.directions_run),
                label: Text(localizations.translate('activity')),
              ),
            ],
          ),

          // Vertical divider
          const VerticalDivider(thickness: 1, width: 1),

          // Content area
          Expanded(
            child: screens[currentTabIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
      BuildContext context,
      AppLocalizations localizations,
      int currentTabIndex,
      List<Widget> screens) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(currentTabIndex, localizations)),
        actions: [
          // Add settings button in appbar for quick access
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: localizations.translate('settings'),
            onPressed: () {
              _openSettingsScreen(context);
            },
          ),
        ],
      ),
      body: screens[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        onTap: (index) {
          ref.read(mainTabIndexProvider.notifier).state = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: localizations.translate('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_run),
            label: localizations.translate('activity'),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
      BuildContext context,
      AppLocalizations localizations,
      int currentTabIndex,
      List<Widget> screens) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(currentTabIndex, localizations)),
        actions: [
          // Add settings button in appbar for quick access
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: localizations.translate('settings'),
            onPressed: () {
              _openSettingsScreen(context);
            },
          ),
        ],
      ),
      body: screens[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        onTap: (index) {
          ref.read(mainTabIndexProvider.notifier).state = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: localizations.translate('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_run),
            label: localizations.translate('activity'),
          ),
        ],
      ),
    );
  }

  // Open the settings screen as a new page
  void _openSettingsScreen(BuildContext context) {
    // Reset to default settings section when opening
    ref.read(settingsSectionProvider.notifier).state = 'volt_settings';

    // Navigate to settings screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsModule.createRootScreen(),
      ),
    );
  }

  String _getTitle(int tabIndex, AppLocalizations localizations) {
    switch (tabIndex) {
      case 0:
        return localizations.translate('dashboard');
      case 1:
        return localizations.translate('activity');
      default:
        return localizations.translate('app_name');
    }
  }

  Widget _buildDashboardContent(
      BuildContext context, AppLocalizations localizations) {
    // Dashboard content implementation remains the same
    final screenType = getScreenType(context);

    return SafeArea(
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

              // Quick action card - responsive layout
              if (screenType == ScreenType.desktop)
                _buildWideActionCards(context, localizations)
              else
                _buildStackedActionCards(context, localizations),

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
                      ? const Color.fromRGBO(50, 50, 50, 1.0)
                      : const Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  localizations.translate('no_activities_yet'),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromRGBO(200, 200, 200, 1.0)
                        : const Color.fromRGBO(100, 100, 100, 1.0),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Stats section - responsive layout
              Text(
                localizations.translate('your_statistics'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              if (screenType == ScreenType.desktop)
                _buildWideStatsGrid(context)
              else
                _buildStackedStatsGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  // Other dashboard methods remain the same...
  Widget _buildWideActionCards(
      BuildContext context, AppLocalizations localizations) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            localizations.translate('start_new_activity'),
            localizations.translate('track_your_progress'),
            Icons.play_arrow_rounded,
            () {
              ref.read(mainTabIndexProvider.notifier).state = 1; // Activity tab
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            localizations.translate('activity_history'),
            localizations.translate('view_your_past_activities'),
            Icons.history,
            () {
              // Navigate to activity history
              ref.read(mainTabIndexProvider.notifier).state = 1; // Activity tab
              ref.read(activitySectionProvider.notifier).state =
                  'all_activities';
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStackedActionCards(
      BuildContext context, AppLocalizations localizations) {
    return Column(
      children: [
        _buildActionCard(
          context,
          localizations.translate('start_new_activity'),
          localizations.translate('track_your_progress'),
          Icons.play_arrow_rounded,
          () {
            ref.read(mainTabIndexProvider.notifier).state = 1; // Activity tab
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context,
          localizations.translate('activity_history'),
          localizations.translate('view_your_past_activities'),
          Icons.history,
          () {
            // Navigate to activity history
            ref.read(mainTabIndexProvider.notifier).state = 1; // Activity tab
            ref.read(activitySectionProvider.notifier).state = 'all_activities';
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    // Use the orange color from app colors
    final orangeColor = AppColors.secondary;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  // Fixed: Use .r, .g, .b instead of .red, .green, .blue
                  color: Color.fromRGBO(
                      orangeColor.r, orangeColor.g, orangeColor.b, 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: orangeColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromRGBO(170, 170, 170, 1.0)
                            : const Color.fromRGBO(100, 100, 100, 1.0),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromRGBO(170, 170, 170, 1.0)
                    : const Color.fromRGBO(130, 130, 130, 1.0),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideStatsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(context, 'Total Distance', '0.0 km', Icons.straighten),
        _buildStatCard(context, 'Total Time', '0:00', Icons.timer),
        _buildStatCard(context, 'Avg Pace', '0:00 /km', Icons.speed),
      ],
    );
  }

  Widget _buildStackedStatsGrid(BuildContext context) {
    return Column(
      children: [
        _buildStatCard(context, 'Total Distance', '0.0 km', Icons.straighten),
        const SizedBox(height: 8),
        _buildStatCard(context, 'Total Time', '0:00', Icons.timer),
        const SizedBox(height: 8),
        _buildStatCard(context, 'Avg Pace', '0:00 /km', Icons.speed),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
