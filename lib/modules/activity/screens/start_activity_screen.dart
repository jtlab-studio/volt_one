// lib/modules/activity/screens/start_activity_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/sensor_status_bar.dart';
import '../providers/activity_state_provider.dart';
import '../models/activity_state.dart';
import '../../../providers/ble_providers.dart'; // Added missing import
import '../../../providers/gps_providers.dart'; // Added missing import

class StartActivityScreen extends ConsumerStatefulWidget {
  const StartActivityScreen({super.key});

  @override
  ConsumerState<StartActivityScreen> createState() =>
      _StartActivityScreenState();
}

class _StartActivityScreenState extends ConsumerState<StartActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Define orange color to be used consistently (using RGBA)
  final Color orangeColor =
      const Color.fromRGBO(255, 152, 0, 1.0); // Colors.orange

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // For demonstration, connect some sensors after a delay
    Future.delayed(const Duration(seconds: 2), () {
      ref.read(gpsConnectedProvider.notifier).state = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      ref.read(heartRateConnectedProvider.notifier).state = true;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final activityState = ref.watch(activityStateProvider);

    // Get the current theme to respect the app's theme settings
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Use theme-appropriate colors
    final backgroundColor =
        isDarkMode ? AppColors.darkBackground : theme.scaffoldBackgroundColor;
    // Removed unused cardColor variable

    return Scaffold(
      // Use the theme's background color instead of hardcoded black
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Tab bar without appbar
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: localizations.translate('metrics')),
                  Tab(text: localizations.translate('map')),
                ],
                // Use theme-appropriate colors
                labelColor: isDarkMode ? Colors.white : Colors.black87,
                indicatorColor: theme.primaryColor,
              ),

              // Use the demo version for better interaction
              const SensorStatusBarDemo(),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMetricsTab(localizations, isDarkMode, theme),
                    _buildMapTab(localizations, isDarkMode, theme),
                  ],
                ),
              ),
            ],
          ),

          // Only show the floating action button in idle state
          if (activityState == ActivityState.idle)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center, // Center of screen
                child: Container(
                  height: 80, // Larger circle
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(
                      orangeColor.r,
                      orangeColor.g,
                      orangeColor.b,
                      0.85, // Using RGBA for opacity
                    ),
                  ),
                  child: IconButton(
                    iconSize: 48,
                    color: Colors.white,
                    icon: const Icon(Icons.play_arrow_rounded),
                    onPressed: () {
                      ref.read(activityStateProvider.notifier).state =
                          ActivityState.active;
                    },
                  ),
                ),
              ),
            ),

          // Show action controls for non-idle states
          if (activityState != ActivityState.idle)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildActivityControls(localizations, activityState),
            ),
        ],
      ),
    );
  }

  Widget _buildMetricsTab(
    AppLocalizations localizations,
    bool isDarkMode,
    ThemeData theme,
  ) {
    // Reduced metric card height by 50%
    final metricCardHeight = 70.0; // Original was 140.0

    // Reduced spacing between cards
    final cardSpacing = 8.0;

    // Since cards are 50% shorter, adjust the grid aspect ratio to look better
    final gridAspectRatio = 1.8; // Wider than tall for the compact cards

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: gridAspectRatio,
      padding: EdgeInsets.all(cardSpacing),
      mainAxisSpacing: cardSpacing,
      crossAxisSpacing: cardSpacing,
      children: [
        // Time metric card
        MetricCard(
          title: localizations.translate('time'),
          value: '00:00:00',
          backgroundColor: AppColors.paceCardColor,
          icon: Icons.timer,
          height: metricCardHeight,
        ),

        // Distance metric card
        MetricCard(
          title: localizations.translate('distance'),
          value: '0.00',
          unit: 'km',
          backgroundColor: AppColors.paceCardColor,
          icon: Icons.straighten,
          height: metricCardHeight,
        ),

        // Pace metric card with average
        MetricCard(
          title: localizations.translate('pace'),
          value: '0:00',
          unit: 'min/km',
          subtitle: '${localizations.translate("avg")}: 0:00',
          backgroundColor: AppColors.paceCardColor,
          icon: Icons.speed,
          height: metricCardHeight,
        ),

        // Heart rate metric card with average
        MetricCard(
          title: localizations.translate('heart_rate'),
          value: '0',
          unit: 'bpm',
          subtitle: '${localizations.translate("avg")}: 0',
          backgroundColor: AppColors.heartRateCardColor,
          icon: Icons.favorite,
          height: metricCardHeight,
        ),

        // Power metric card with average
        MetricCard(
          title: localizations.translate('power'),
          value: '0',
          unit: 'watts',
          subtitle: '${localizations.translate("avg")}: 0',
          backgroundColor: AppColors.powerCardColor,
          icon: Icons.flash_on,
          height: metricCardHeight,
        ),

        // Cadence metric card with average
        MetricCard(
          title: localizations.translate('cadence'),
          value: '0',
          unit: 'spm',
          subtitle: '${localizations.translate("avg")}: 0',
          backgroundColor: AppColors.cadenceCardColor,
          icon: Icons.directions_walk,
          height: metricCardHeight,
        ),

        // Elevation Gain metric card - SPLIT INTO SEPARATE CARD
        MetricCard(
          title: localizations.translate('elevation_gain'),
          value: '0',
          unit: 'm',
          backgroundColor: AppColors.elevationCardColor,
          icon: Icons.trending_up,
          height: metricCardHeight,
        ),

        // Elevation Loss metric card - SPLIT INTO SEPARATE CARD
        MetricCard(
          title: localizations.translate('elevation_loss'),
          value: '0',
          unit: 'm',
          backgroundColor: AppColors.elevationCardColor,
          icon: Icons.trending_down,
          height: metricCardHeight,
        ),
      ],
    );
  }

  Widget _buildMapTab(
    AppLocalizations localizations,
    bool isDarkMode,
    ThemeData theme,
  ) {
    // Reduced metric card height by 50%
    final metricCardHeight = 50.0; // Original was 100.0

    // Reduced spacing between cards
    final cardSpacing = 8.0;

    return Column(
      children: [
        // Two customizable metric cards with proper padding
        SafeArea(
          // Set bottom to false since we only need top padding
          bottom: false,
          child: Padding(
            padding: EdgeInsets.all(cardSpacing),
            child: Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: localizations.translate('pace'),
                    value: '0:00',
                    unit: 'min/km',
                    backgroundColor: AppColors.paceCardColor,
                    icon: Icons.speed,
                    height: metricCardHeight,
                  ),
                ),
                SizedBox(width: cardSpacing),
                Expanded(
                  child: MetricCard(
                    title: localizations.translate('heart_rate'),
                    value: '0',
                    unit: 'bpm',
                    backgroundColor: AppColors.heartRateCardColor,
                    icon: Icons.favorite,
                    height: metricCardHeight,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Add a SizedBox with height equivalent to padding to prevent overflow
        SizedBox(height: cardSpacing),

        // Map placeholder - theme-appropriate color
        Expanded(
          child: Container(
            color: isDarkMode
                ? const Color.fromRGBO(30, 30, 30, 1.0) // Dark background
                : const Color.fromRGBO(240, 240, 240, 1.0), // Light background
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 64,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Map will be displayed here',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityControls(
      AppLocalizations localizations, ActivityState state) {
    switch (state) {
      case ActivityState.active:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Discard button - Using icon only to save space
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showDiscardConfirmation(context, localizations);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(
                        244, 67, 54, 1.0), // AppColors.error
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.delete), // Icon only
                ),
              ),
              const SizedBox(width: 16),

              // Pause button - Using orange color
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(activityStateProvider.notifier).state =
                        ActivityState.paused;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        orangeColor, // Using the orangeColor variable
                    foregroundColor:
                        Colors.white, // White text for better contrast
                  ),
                  child: const Icon(Icons.pause),
                ),
              ),
              const SizedBox(width: 16),

              // End button - Using orange color
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Show activity summary
                    ref.read(activityStateProvider.notifier).state =
                        ActivityState.completed;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        orangeColor, // Using the orangeColor variable
                    foregroundColor:
                        Colors.white, // White text for better contrast
                  ),
                  child: const Icon(Icons.stop),
                ),
              ),
            ],
          ),
        );

      case ActivityState.paused:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Discard button - Using icon only
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showDiscardConfirmation(context, localizations);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(
                        244, 67, 54, 1.0), // AppColors.error
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.delete), // Icon only
                ),
              ),
              const SizedBox(width: 16),

              // Resume button - Using orange color
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(activityStateProvider.notifier).state =
                        ActivityState.active;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        orangeColor, // Using the orangeColor variable
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.play_arrow),
                ),
              ),
              const SizedBox(width: 16),

              // End button - Using orange color
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Show activity summary
                    ref.read(activityStateProvider.notifier).state =
                        ActivityState.completed;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        orangeColor, // Using the orangeColor variable
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.stop),
                ),
              ),
            ],
          ),
        );

      case ActivityState.idle:
      case ActivityState.completed:
        // Idle state now uses a centered orange button
        // Completed state will navigate to the summary screen
        return const SizedBox();
    }
  }

  void _showDiscardConfirmation(
      BuildContext context, AppLocalizations localizations) {
    // Get theme to use appropriate colors
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Use theme colors instead of hardcoded dark
        backgroundColor:
            isDarkMode ? const Color.fromRGBO(50, 50, 50, 1.0) : Colors.white,
        title: Text(
          localizations.translate('discard_activity'),
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        ),
        content: Text(
          localizations.translate('discard_confirmation'),
          style: TextStyle(
              color: isDarkMode
                  ? const Color.fromRGBO(255, 255, 255, 0.7)
                  : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              localizations.translate('cancel'),
              style: TextStyle(
                  color: isDarkMode
                      ? const Color.fromRGBO(200, 200, 200, 1.0)
                      : Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(activityStateProvider.notifier).state =
                  ActivityState.idle;
            },
            style: TextButton.styleFrom(
              foregroundColor:
                  const Color.fromRGBO(244, 67, 54, 1.0), // AppColors.error
            ),
            child: Text(localizations.translate('discard')),
          ),
        ],
      ),
    );
  }
}
