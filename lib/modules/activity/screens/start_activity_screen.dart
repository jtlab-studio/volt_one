import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/sensor_status_bar.dart';
import '../providers/activity_state_provider.dart';
import '../models/activity_state.dart';

class StartActivityScreen extends ConsumerStatefulWidget {
  const StartActivityScreen({super.key});

  @override
  ConsumerState<StartActivityScreen> createState() =>
      _StartActivityScreenState();
}

class _StartActivityScreenState extends ConsumerState<StartActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Define orange color to be used consistently
  final Color orangeColor = Colors.orange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

    return Scaffold(
      // Removed app bar to avoid duplicate title
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
                // Makes the tab bar visible in light mode
                labelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
              ),

              // Sensor status bar
              const SensorStatusBar(),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMetricsTab(localizations),
                    _buildMapTab(localizations),
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
                    color: orangeColor
                        .withOpacity(0.85), // Orange with transparency
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

  Widget _buildMetricsTab(AppLocalizations localizations) {
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

        // Elevation metric card with gain and loss - custom layout
        MetricCard(
          title: localizations.translate('elevation'),
          value: '',
          customContent: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.translate('elevation_gain'),
                    style: const TextStyle(fontSize: 9),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24, // Increased font size to match others
                            color: AppColors.elevationCardColor,
                          ),
                        ),
                        TextSpan(
                          text: ' m',
                          style: TextStyle(
                            fontSize: 12, // 50% of value size
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.grey[300],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.translate('elevation_loss'),
                    style: const TextStyle(fontSize: 9),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24, // Increased font size to match others
                            color: AppColors.elevationCardColor,
                          ),
                        ),
                        TextSpan(
                          text: ' m',
                          style: TextStyle(
                            fontSize: 12, // 50% of value size
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: AppColors.elevationCardColor,
          icon: Icons.terrain,
          height: metricCardHeight,
        ),
      ],
    );
  }

  Widget _buildMapTab(AppLocalizations localizations) {
    // Reduced metric card height by 50%
    final metricCardHeight = 50.0; // Original was 100.0

    // Reduced spacing between cards
    final cardSpacing = 8.0;

    return Column(
      children: [
        // Two customizable metric cards
        Padding(
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

        // Map placeholder
        Expanded(
          child: Container(
            color: Colors.grey[300],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Map will be displayed here',
                    style: TextStyle(color: Colors.grey[600]),
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
                    backgroundColor: Colors.red,
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
                    backgroundColor: orangeColor, // Changed to orange
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
                    backgroundColor: orangeColor, // Changed to orange
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
                    backgroundColor: Colors.red,
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
                    backgroundColor: orangeColor, // Changed to orange
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
                    backgroundColor: orangeColor, // Changed to orange
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('discard_activity')),
        content: Text(localizations.translate('discard_confirmation')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(localizations.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(activityStateProvider.notifier).state =
                  ActivityState.idle;
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(localizations.translate('discard')),
          ),
        ],
      ),
    );
  }
}
