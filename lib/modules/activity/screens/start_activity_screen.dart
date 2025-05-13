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
      body: Column(
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

          // Activity controls
          _buildActivityControls(localizations, activityState),
        ],
      ),
    );
  }

  Widget _buildMetricsTab(AppLocalizations localizations) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        // Time metric card
        MetricCard(
          title: localizations.translate('time'),
          value: '00:00:00',
          backgroundColor: Colors.grey[200]!,
          icon: Icons.timer,
        ),

        // Distance metric card
        MetricCard(
          title: localizations.translate('distance'),
          value: '0.00 km',
          backgroundColor: Colors.blue[50]!,
          icon: Icons.straighten,
        ),

        // Pace metric card with average
        MetricCard(
          title: localizations.translate('pace'),
          value: '0:00 min/km',
          subtitle: '${localizations.translate("avg")}: 0:00',
          backgroundColor: AppColors.paceCardColor,
          icon: Icons.speed,
        ),

        // Heart rate metric card with average
        MetricCard(
          title: localizations.translate('heart_rate'),
          value: '0 bpm',
          subtitle: '${localizations.translate("avg")}: 0',
          backgroundColor: AppColors.heartRateCardColor,
          icon: Icons.favorite,
        ),

        // Power metric card with average
        MetricCard(
          title: localizations.translate('power'),
          value: '0 watts',
          subtitle: '${localizations.translate("avg")}: 0',
          backgroundColor: AppColors.powerCardColor,
          icon: Icons.flash_on,
        ),

        // Cadence metric card with average
        MetricCard(
          title: localizations.translate('cadence'),
          value: '0 spm',
          subtitle: '${localizations.translate("avg")}: 0',
          backgroundColor: AppColors.cadenceCardColor,
          icon: Icons.directions_walk,
        ),

        // Elevation metric card with gain and loss
        MetricCard(
          title: localizations.translate('elevation'),
          value: '',
          customContent: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        localizations.translate('elevation_gain'),
                        style: const TextStyle(fontSize: 11), // Reduced size
                      ),
                      const Text(
                        '0 m',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        localizations.translate('elevation_loss'),
                        style: const TextStyle(fontSize: 11), // Reduced size
                      ),
                      const Text(
                        '0 m',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: AppColors.elevationCardColor,
          icon: Icons.terrain,
        ),
      ],
    );
  }

  Widget _buildMapTab(AppLocalizations localizations) {
    return Column(
      children: [
        // Two customizable metric cards
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: localizations.translate('pace'),
                  value: '0:00 min/km',
                  backgroundColor: AppColors.paceCardColor,
                  icon: Icons.speed,
                  height: 100,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: localizations.translate('heart_rate'),
                  value: '0 bpm',
                  backgroundColor: AppColors.heartRateCardColor,
                  icon: Icons.favorite,
                  height: 100,
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
      case ActivityState.idle:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                ref.read(activityStateProvider.notifier).state =
                    ActivityState.active;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(localizations.translate('start')),
            ),
          ),
        );

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

              // Pause button - Using icon only to save space
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(activityStateProvider.notifier).state =
                        ActivityState.paused;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  child: const Icon(Icons.pause), // Icon only
                ),
              ),
              const SizedBox(width: 16),

              // End button - Using icon only to save space
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Show activity summary
                    ref.read(activityStateProvider.notifier).state =
                        ActivityState.completed;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.stop), // Icon only
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

              // Resume button - Using icon only
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(activityStateProvider.notifier).state =
                        ActivityState.active;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.play_arrow), // Icon only
                ),
              ),
              const SizedBox(width: 16),

              // End button - Using icon only
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Show activity summary
                    ref.read(activityStateProvider.notifier).state =
                        ActivityState.completed;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.stop), // Icon only
                ),
              ),
            ],
          ),
        );

      case ActivityState.completed:
        // This state will navigate to the summary screen
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
