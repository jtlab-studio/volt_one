import 'dart:async';
// FIXED: Removed unnecessary import of 'package:flutter/material.dart'
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'storage_service.dart';

/// GPSStatus represents the current status of the GPS service
enum GPSStatus {
  disabled, // GPS is disabled on the device
  noPermission, // App doesn't have permission
  initializing, // GPS is being initialized
  enabled, // GPS is enabled and ready
  active // GPS is actively providing updates
}

/// GPSAccuracy represents the accuracy level of the GPS
enum GPSAccuracy {
  powerSaver, // Lower accuracy, better battery life
  balanced, // Balanced accuracy and battery usage
  highAccuracy, // High accuracy, higher battery usage
  rtk // Highest accuracy (RTK), highest battery usage
}

/// A class to store GPS settings
class GPSSettings {
  final GPSAccuracy accuracy;
  final bool multiFrequency;
  final bool rawMeasurements;
  final bool sensorFusion;
  final bool rtkCorrections;
  final bool externalReceiver;

  const GPSSettings({
    this.accuracy = GPSAccuracy.balanced,
    this.multiFrequency = true,
    this.rawMeasurements = false,
    this.sensorFusion = true,
    this.rtkCorrections = false,
    this.externalReceiver = false,
  });

  /// Create a copy with updated fields
  GPSSettings copyWith({
    GPSAccuracy? accuracy,
    bool? multiFrequency,
    bool? rawMeasurements,
    bool? sensorFusion,
    bool? rtkCorrections,
    bool? externalReceiver,
  }) {
    return GPSSettings(
      accuracy: accuracy ?? this.accuracy,
      multiFrequency: multiFrequency ?? this.multiFrequency,
      rawMeasurements: rawMeasurements ?? this.rawMeasurements,
      sensorFusion: sensorFusion ?? this.sensorFusion,
      rtkCorrections: rtkCorrections ?? this.rtkCorrections,
      externalReceiver: externalReceiver ?? this.externalReceiver,
    );
  }

  /// Convert to LocationSettings for Geolocator
  LocationSettings toLocationSettings() {
    LocationAccuracy geoAccuracy;

    switch (accuracy) {
      case GPSAccuracy.powerSaver:
        geoAccuracy = LocationAccuracy.reduced;
        break;
      case GPSAccuracy.balanced:
        geoAccuracy = LocationAccuracy.medium;
        break;
      case GPSAccuracy.highAccuracy:
        geoAccuracy = LocationAccuracy.high;
        break;
      case GPSAccuracy.rtk:
        geoAccuracy = LocationAccuracy.best;
        break;
    }

    // For Android, we can use specific settings
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: geoAccuracy,
        distanceFilter: 5, // Update every 5 meters of movement
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'GPS Tracking',
          notificationText: 'Volt Running is tracking your location',
          enableWakeLock: true,
        ),
      );
    }
    // For iOS, we can use specific settings
    else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return AppleSettings(
        accuracy: geoAccuracy,
        activityType: ActivityType.fitness,
        distanceFilter: 5,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
      );
    }
    // For other platforms, use generic settings
    else {
      return LocationSettings(
        accuracy: geoAccuracy,
        distanceFilter: 5,
      );
    }
  }

  /// Estimate battery usage in mW (rough approximation)
  double estimateBatteryUsage() {
    double basePower = 0;

    switch (accuracy) {
      case GPSAccuracy.powerSaver:
        basePower = 50;
        break;
      case GPSAccuracy.balanced:
        basePower = 410;
        break;
      case GPSAccuracy.highAccuracy:
        basePower = 2200;
        break;
      case GPSAccuracy.rtk:
        basePower = 3000;
        break;
    }

    // Add power for additional features
    if (multiFrequency) basePower *= 1.2;
    if (rawMeasurements) basePower *= 1.1;
    if (sensorFusion) basePower *= 1.1;
    if (rtkCorrections) basePower *= 1.3;
    if (externalReceiver) basePower *= 0.7; // External might be more efficient

    return basePower;
  }

  /// Estimate accuracy in meters CEP (Circular Error Probable)
  double estimateAccuracy() {
    double baseAccuracy = 0;

    switch (accuracy) {
      case GPSAccuracy.powerSaver:
        baseAccuracy = 10;
        break;
      case GPSAccuracy.balanced:
        baseAccuracy = 3;
        break;
      case GPSAccuracy.highAccuracy:
        baseAccuracy = 1.5;
        break;
      case GPSAccuracy.rtk:
        baseAccuracy = 0.5;
        break;
    }

    // Improve accuracy with additional features
    if (multiFrequency) baseAccuracy *= 0.8;
    if (rawMeasurements) baseAccuracy *= 0.9;
    if (sensorFusion) baseAccuracy *= 0.9;
    if (rtkCorrections) baseAccuracy *= 0.5;
    if (externalReceiver) baseAccuracy *= 0.7;

    return baseAccuracy;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'accuracy': accuracy.index,
      'multiFrequency': multiFrequency,
      'rawMeasurements': rawMeasurements,
      'sensorFusion': sensorFusion,
      'rtkCorrections': rtkCorrections,
      'externalReceiver': externalReceiver,
    };
  }

  /// Create from JSON for retrieval from storage
  factory GPSSettings.fromJson(Map<String, dynamic> json) {
    return GPSSettings(
      accuracy:
          GPSAccuracy.values[json['accuracy'] ?? 1], // Default to balanced
      multiFrequency: json['multiFrequency'] ?? true,
      rawMeasurements: json['rawMeasurements'] ?? false,
      sensorFusion: json['sensorFusion'] ?? true,
      rtkCorrections: json['rtkCorrections'] ?? false,
      externalReceiver: json['externalReceiver'] ?? false,
    );
  }
}

/// A service to manage GPS functionality
class GPSService {
  // Singleton instance
  static final GPSService _instance = GPSService._internal();
  factory GPSService() => _instance;
  GPSService._internal();

  // Instance of StorageService
  final StorageService _storage = StorageService();

  // Stream controllers
  final _statusController = StreamController<GPSStatus>.broadcast();
  final _positionController = StreamController<Position>.broadcast();
  final _settingsController = StreamController<GPSSettings>.broadcast();

  // Current status and position
  GPSStatus _status = GPSStatus.initializing;
  Position? _lastPosition;
  GPSSettings _settings = const GPSSettings();

  // Position stream subscription
  StreamSubscription<Position>? _positionSubscription;

  // Service state check timer
  Timer? _serviceCheckTimer;

  // Streams
  Stream<GPSStatus> get statusStream => _statusController.stream;
  Stream<Position> get positionStream => _positionController.stream;
  Stream<GPSSettings> get settingsStream => _settingsController.stream;

  // Getters
  GPSStatus get status => _status;
  Position? get lastPosition => _lastPosition;
  GPSSettings get settings => _settings;

  /// Initialize the GPS service
  Future<void> initialize() async {
    // Update status
    _setStatus(GPSStatus.initializing);

    // Load saved settings
    await _loadSettings();

    // Request location permission
    await _requestLocationPermissions();

    // Start service status check timer
    _serviceCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkGpsService(),
    );

    // Initial check
    await _checkGpsService();
  }

  /// Request location permissions
  Future<void> _requestLocationPermissions() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _setStatus(GPSStatus.noPermission);
          return;
        }
      }

      // For Android, we also need background location for tracking activities
      if (defaultTargetPlatform == TargetPlatform.android) {
        await Permission.locationAlways.request();
      }
    } catch (e) {
      debugPrint('Error requesting location permissions: $e');
      _setStatus(GPSStatus.noPermission);
    }
  }

  /// Start GPS tracking
  Future<bool> startTracking() async {
    if (_status == GPSStatus.disabled || _status == GPSStatus.noPermission) {
      return false;
    }

    try {
      // Stop any existing tracking
      await stopTracking();

      // Get last known position
      try {
        // Use the settings to get current position
        _lastPosition = await Geolocator.getCurrentPosition(
          locationSettings: _settings.toLocationSettings(),
        );
        _positionController.add(_lastPosition!);
      } catch (e) {
        debugPrint('Error getting current position: $e');
        // Continue even if we can't get current position
      }

      // Start position stream
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: _settings.toLocationSettings(),
      ).listen(
        (Position position) {
          _lastPosition = position;
          _positionController.add(position);
          _setStatus(GPSStatus.active);
        },
        onError: (e) {
          debugPrint('Position stream error: $e');
          _checkGpsService();
        },
      );

      _setStatus(GPSStatus.active);
      return true;
    } catch (e) {
      debugPrint('Error starting GPS tracking: $e');
      return false;
    }
  }

  /// Stop GPS tracking
  Future<bool> stopTracking() async {
    try {
      await _positionSubscription?.cancel();
      _positionSubscription = null;

      if (_status == GPSStatus.active) {
        _setStatus(GPSStatus.enabled);
      }

      return true;
    } catch (e) {
      debugPrint('Error stopping GPS tracking: $e');
      return false;
    }
  }

  /// Update GPS settings
  Future<void> updateSettings(GPSSettings newSettings) async {
    _settings = newSettings;
    _settingsController.add(_settings);

    // Save settings
    await _saveSettings();

    // Restart tracking if active
    if (_status == GPSStatus.active) {
      await startTracking();
    }
  }

  /// Get current location once
  Future<Position?> getCurrentLocation() async {
    try {
      // Use the settings for getting the current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: _settings.toLocationSettings(),
      );
      _lastPosition = position;
      _positionController.add(position);
      return position;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  /// Run a GPS field test
  Future<Map<String, dynamic>> runFieldTest(
      {Duration duration = const Duration(seconds: 30)}) async {
    try {
      // Start tracking with current settings
      final success = await startTracking();
      if (!success) {
        return {
          'success': false,
          'error': 'Failed to start GPS',
        };
      }

      // Collect positions for the specified duration
      final positions = <Position>[];
      final completer = Completer<List<Position>>();

      // Listen to position updates
      final subscription = positionStream.listen(
        (position) {
          positions.add(position);
        },
        onError: (e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        },
      );

      // Wait for the specified duration
      Future.delayed(duration, () {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete(positions);
        }
      });

      // Wait for positions
      final collectedPositions = await completer.future;

      // Calculate accuracy metrics
      final accuracyMetrics = _calculateAccuracyMetrics(collectedPositions);

      // Stop tracking
      await stopTracking();

      return {
        'success': true,
        'positions': collectedPositions.length,
        'avgAccuracy': accuracyMetrics['avgAccuracy'],
        'maxAccuracy': accuracyMetrics['maxAccuracy'],
        'minAccuracy': accuracyMetrics['minAccuracy'],
        'time': duration.inSeconds,
      };
    } catch (e) {
      debugPrint('Error running GPS test: $e');
      await stopTracking();
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Dispose the service
  void dispose() {
    _positionSubscription?.cancel();
    _serviceCheckTimer?.cancel();
    _statusController.close();
    _positionController.close();
    _settingsController.close();
  }

  // Helper to set status and notify listeners
  void _setStatus(GPSStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      _statusController.add(_status);
    }
  }

  // Check if GPS service is enabled
  Future<void> _checkGpsService() async {
    try {
      final isEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isEnabled) {
        _setStatus(GPSStatus.disabled);
        return;
      }

      // Check permission
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _setStatus(GPSStatus.noPermission);
        return;
      }

      // If we're not already active, set to enabled
      if (_status != GPSStatus.active) {
        _setStatus(GPSStatus.enabled);
      }

      // Try to get current position if we don't have one
      if (_lastPosition == null) {
        try {
          _lastPosition = await Geolocator.getLastKnownPosition();
          if (_lastPosition != null) {
            _positionController.add(_lastPosition!);
          }
        } catch (e) {
          debugPrint('Error getting last known position: $e');
        }
      }
    } catch (e) {
      debugPrint('Error checking GPS service: $e');
    }
  }

  // Calculate accuracy metrics from positions
  Map<String, double> _calculateAccuracyMetrics(List<Position> positions) {
    if (positions.isEmpty) {
      return {
        'avgAccuracy': 0.0,
        'maxAccuracy': 0.0,
        'minAccuracy': 0.0,
      };
    }

    double sum = 0;
    double max = 0;
    double min = double.infinity;

    for (final position in positions) {
      final accuracy = position.accuracy;
      sum += accuracy;
      if (accuracy > max) max = accuracy;
      if (accuracy < min) min = accuracy;
    }

    return {
      'avgAccuracy': sum / positions.length,
      'maxAccuracy': max,
      'minAccuracy': min,
    };
  }

  // Load settings from storage
  Future<void> _loadSettings() async {
    try {
      final settings = await _storage.getGpsSettings();
      if (settings != null) {
        _settings = settings;
        _settingsController.add(_settings);
      }
    } catch (e) {
      debugPrint('Error loading GPS settings: $e');
    }
  }

  // Save settings to storage
  Future<void> _saveSettings() async {
    try {
      await _storage.saveGpsSettings(_settings);
    } catch (e) {
      debugPrint('Error saving GPS settings: $e');
    }
  }
}
