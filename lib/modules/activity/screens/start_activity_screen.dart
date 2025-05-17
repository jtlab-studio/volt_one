import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/location_display.dart';
import '../widgets/sensor_connection_indicator.dart';
import '../providers/activity_state_provider.dart';
import '../models/activity_state.dart';
import '../../../providers/ble_providers.dart' as ble;
import '../../../providers/gps_providers.dart' as gps;
import '../../../providers/ble_providers_extended.dart';
import '../../../providers/gps_providers_extended.dart';

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
  final Color orangeColor =
      const Color.fromRGBO(255, 152, 0, 1.0); // Colors.orange

  // Activity metrics
  String _elapsedTime = '00:00:00';
  double _distance = 0.0;
  String _pace = '0:00';
  String _avgPace = '0:00';
  int _heartRate = 0;
  int _avgHeartRate = 0;
  int _power = 0;
  int _avgPower = 0;
  int _cadence = 0;
  int _avgCadence = 0;
  int _elevationGain = 0;
  int _elevationLoss = 0;

  // Activity tracking
  DateTime? _startTime;
  DateTime? _pauseTime;
  List<Position> _trackPoints = [];
  StreamSubscription<Position>? _positionSubscription;
  Timer? _activityTimer;

  // Heart rate and other sensor data
  StreamSubscription? _heartRateSubscription;
  StreamSubscription? _powerSubscription;
  StreamSubscription? _cadenceSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Connect to saved devices and GPS automatically on launch
    _initializeConnections();
  }

  Future<void> _initializeConnections() async {
    // Initialize BLE and GPS controllers
    final bleController = ref.read(ble.bleControllerProvider);
    final gpsController = ref.read(gps.gpsControllerProvider);

    try {
      // Initialize BLE subsystem
      await bleController.initialize();

      // Connect to all saved BLE devices
      await bleController.connectToAllSavedDevices();

      // Initialize GPS
      await gpsController.initialize();

      // Start GPS tracking if permissions are available
      if (gpsController.isGpsAvailable()) {
        await gpsController.startTracking();
      }

      // Start sensor data simulation for testing - even without real sensors
      _startSensorTracking();
    } catch (e) {
      debugPrint('Error initializing connections: $e');
    }

    // Listen for activity state changes to start/stop tracking
    ref.listen(activityStateProvider, (previous, next) {
      if (next == ActivityState.active && previous != ActivityState.active) {
        _startActivity();
      } else if (next == ActivityState.paused &&
          previous == ActivityState.active) {
        _pauseActivity();
      } else if (next == ActivityState.active &&
          previous == ActivityState.paused) {
        _resumeActivity();
      } else if (next == ActivityState.idle &&
          (previous == ActivityState.active ||
              previous == ActivityState.paused ||
              previous == ActivityState.completed)) {
        _resetActivity();
      } else if (next == ActivityState.completed &&
          (previous == ActivityState.active ||
              previous == ActivityState.paused)) {
        _completeActivity();
      }
    });
  }

  void _startActivity() {
    _startTime = DateTime.now();
    _pauseTime = null;
    _trackPoints = [];

    // Start tracking position
    _startPositionTracking();

    // Start heart rate and other sensor tracking
    _startSensorTracking();

    // Start timer for UI updates
    _startActivityTimer();
  }

  void _pauseActivity() {
    _pauseTime = DateTime.now();

    // Stop position updates but keep the data
    _positionSubscription?.pause();

    // Pause the timer
    _activityTimer?.cancel();
  }

  void _resumeActivity() {
    // Calculate the pause duration and adjust the start time
    if (_pauseTime != null && _startTime != null) {
      final pauseDuration = DateTime.now().difference(_pauseTime!);
      _startTime = _startTime!.add(pauseDuration);
      _pauseTime = null;
    }

    // Resume position updates
    _positionSubscription?.resume();

    // Restart the timer
    _startActivityTimer();
  }

  void _completeActivity() {
    // Stop all tracking
    _stopTracking();

    // Here you would typically save the activity to storage
    // and show a summary screen
  }

  void _resetActivity() {
    // Stop all tracking
    _stopTracking();

    // Reset all metrics
    setState(() {
      _elapsedTime = '00:00:00';
      _distance = 0.0;
      _pace = '0:00';
      _avgPace = '0:00';
      _heartRate = 0;
      _avgHeartRate = 0;
      _power = 0;
      _avgPower = 0;
      _cadence = 0;
      _avgCadence = 0;
      _elevationGain = 0;
      _elevationLoss = 0;
      _trackPoints = [];
      _startTime = null;
      _pauseTime = null;
    });
  }

  void _stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;

    _heartRateSubscription?.cancel();
    _powerSubscription?.cancel();
    _cadenceSubscription?.cancel();

    _activityTimer?.cancel();
    _activityTimer = null;
  }

  void _startPositionTracking() {
    // Make sure GPS is shown as connected
    ref.read(gpsConnectedProvider.notifier).state = true;

    // Get the controller to listen to position updates
    final gpsController = ref.read(gps.gpsControllerProvider);

    // Subscribe to position updates - fixed the AsyncValue issue
    _positionSubscription = Geolocator.getPositionStream().listen((position) {
      // Check if widget is still mounted before calling setState
      if (!mounted) return;

      // Add the new position to track points
      setState(() {
        _trackPoints.add(position);

        // Calculate distance
        if (_trackPoints.length > 1) {
          final lastPoint = _trackPoints[_trackPoints.length - 2];
          final newPoint = position;

          // Calculate distance between last point and new point
          final segmentDistance = Geolocator.distanceBetween(
            lastPoint.latitude,
            lastPoint.longitude,
            newPoint.latitude,
            newPoint.longitude,
          );

          // Add to total distance (convert meters to kilometers)
          _distance += segmentDistance / 1000;

          // Calculate current pace (minutes per kilometer)
          if (_startTime != null) {
            final elapsedSeconds =
                DateTime.now().difference(_startTime!).inSeconds;
            if (elapsedSeconds > 0 && _distance > 0) {
              // Pace in seconds per kilometer
              final paceSeconds = (elapsedSeconds / _distance).round();

              // Format as mm:ss
              final paceMinutes = (paceSeconds / 60).floor();
              final paceRemainder = paceSeconds % 60;
              _pace =
                  '$paceMinutes:${paceRemainder.toString().padLeft(2, '0')}';

              // Use the same formula for average pace
              _avgPace = _pace;
            }
          }

          // Calculate elevation changes
          final elevationChange = newPoint.altitude - lastPoint.altitude;
          if (elevationChange > 0) {
            _elevationGain += elevationChange.round();
          } else {
            _elevationLoss += (-elevationChange).round();
          }
        }
      });
    });
  }

  void _startSensorTracking() {
    // Cancel any existing subscriptions
    _heartRateSubscription?.cancel();
    _powerSubscription?.cancel();
    _cadenceSubscription?.cancel();

    // Simulate heart rate data for demonstration
    // In a real app, you would connect to the actual heart rate sensor
    _heartRateSubscription =
        Stream.periodic(const Duration(seconds: 1)).listen((_) {
      // Check if widget is still mounted before calling setState
      if (!mounted) return;

      // In a real app, you would get this from the heart rate sensor
      // This is just a simulation with random fluctuations around 140 bpm
      setState(() {
        _heartRate = 140 + (DateTime.now().millisecond % 20 - 10);

        // Calculate average - Fix type error with explicit cast to int
        if (_avgHeartRate == 0) {
          _avgHeartRate = _heartRate;
        } else {
          _avgHeartRate = ((_avgHeartRate * 9 + _heartRate) / 10).toInt();
        }
      });

      // Make sure heartRateConnected is true for visual status
      ref.read(heartRateConnectedProvider.notifier).state = true;
    });

    // Simulate power data
    _powerSubscription =
        Stream.periodic(const Duration(seconds: 1)).listen((_) {
      // Check if widget is still mounted before calling setState
      if (!mounted) return;

      setState(() {
        _power = 250 + (DateTime.now().millisecond % 40 - 20);

        // Calculate average - Fix type error with explicit cast to int
        if (_avgPower == 0) {
          _avgPower = _power;
        } else {
          _avgPower = ((_avgPower * 9 + _power) / 10).toInt();
        }
      });

      // Make sure power meter is shown as connected
      ref.read(powerMeterConnectedProvider.notifier).state = true;
    });

    // Simulate cadence data
    _cadenceSubscription =
        Stream.periodic(const Duration(seconds: 1)).listen((_) {
      // Check if widget is still mounted before calling setState
      if (!mounted) return;

      setState(() {
        _cadence = 175 + (DateTime.now().millisecond % 10 - 5);

        // Calculate average - Fix type error with explicit cast to int
        if (_avgCadence == 0) {
          _avgCadence = _cadence;
        } else {
          _avgCadence = ((_avgCadence * 9 + _cadence) / 10).toInt();
        }
      });

      // Make sure cadence sensor is shown as connected
      ref.read(cadenceSensorConnectedProvider.notifier).state = true;
    });
  }

  void _startActivityTimer() {
    // Update the elapsed time every second
    _activityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Check if widget is still mounted before calling setState
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_startTime != null) {
        final elapsed = DateTime.now().difference(_startTime!);

        setState(() {
          // Format as hh:mm:ss
          final hours = elapsed.inHours.toString().padLeft(2, '0');
          final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');

          _elapsedTime = '$hours:$minutes:$seconds';
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _stopTracking();
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

              // Use the new sensor connection indicator for better visual feedback
              const SensorConnectionIndicator(),

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
                    color: Color.fromARGB(
                      217, // 85% of 255
                      255, // R value for orange
                      152, // G value for orange
                      0, // B value for orange
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
          value: _elapsedTime,
          backgroundColor: AppColors.paceCardColor,
          icon: Icons.timer,
          height: metricCardHeight,
        ),

        // Distance metric card
        MetricCard(
          title: localizations.translate('distance'),
          value: _distance.toStringAsFixed(2),
          unit: 'km',
          backgroundColor: AppColors.paceCardColor,
          icon: Icons.straighten,
          height: metricCardHeight,
        ),

        // Pace metric card with average
        MetricCard(
          title: localizations.translate('pace'),
          value: _pace,
          unit: 'min/km',
          subtitle: '${localizations.translate("avg")}: $_avgPace',
          backgroundColor: AppColors.paceCardColor,
          icon: Icons.speed,
          height: metricCardHeight,
        ),

        // Heart rate metric card with average
        MetricCard(
          title: localizations.translate('heart_rate'),
          value: _heartRate.toString(),
          unit: 'bpm',
          subtitle: '${localizations.translate("avg")}: $_avgHeartRate',
          backgroundColor: AppColors.heartRateCardColor,
          icon: Icons.favorite,
          height: metricCardHeight,
        ),

        // Power metric card with average
        MetricCard(
          title: localizations.translate('power'),
          value: _power.toString(),
          unit: 'watts',
          subtitle: '${localizations.translate("avg")}: $_avgPower',
          backgroundColor: AppColors.powerCardColor,
          icon: Icons.flash_on,
          height: metricCardHeight,
        ),

        // Cadence metric card with average
        MetricCard(
          title: localizations.translate('cadence'),
          value: _cadence.toString(),
          unit: 'spm',
          subtitle: '${localizations.translate("avg")}: $_avgCadence',
          backgroundColor: AppColors.cadenceCardColor,
          icon: Icons.directions_walk,
          height: metricCardHeight,
        ),

        // Elevation Gain metric card - SPLIT INTO SEPARATE CARD
        MetricCard(
          title: localizations.translate('elevation_gain'),
          value: _elevationGain.toString(),
          unit: 'm',
          backgroundColor: AppColors.elevationCardColor,
          icon: Icons.trending_up,
          height: metricCardHeight,
        ),

        // Elevation Loss metric card - SPLIT INTO SEPARATE CARD
        MetricCard(
          title: localizations.translate('elevation_loss'),
          value: _elevationLoss.toString(),
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
                    value: _pace,
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
                    value: _heartRate.toString(),
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

        // Map with current location
        Expanded(
          child: Stack(
            children: [
              // Map placeholder with theme-appropriate color
              Container(
                color: isDarkMode
                    ? const Color.fromRGBO(30, 30, 30, 1.0) // Dark background
                    : const Color.fromRGBO(
                        240, 240, 240, 1.0), // Light background
              ),

              // Display current location
              Center(
                child: _buildMapContent(isDarkMode),
              ),

              // Location indicator
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: _centerMapOnCurrentLocation,
                  child: const Icon(Icons.my_location),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapContent(bool isDarkMode) {
    final lastPositionAsync = ref.watch(gps.lastPositionProvider);

    // If we have position data from tracking, show it
    if (_trackPoints.isNotEmpty) {
      return LocationDisplay(
        position: _trackPoints.last,
        isCurrentLocation: true,
        showDetails: true,
      );
    }

    // If no track points yet, check last known position
    if (lastPositionAsync != null) {
      return LocationDisplay(
        position: lastPositionAsync,
        isCurrentLocation: false,
        showDetails: true,
      );
    }

    // If no position available yet, show status
    return const LocationStatusDisplay();
  }

  void _centerMapOnCurrentLocation() {
    final gpsController = ref.read(gps.gpsControllerProvider);
    gpsController.getCurrentLocation();
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
