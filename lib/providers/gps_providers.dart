import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/gps_service.dart';

part 'gps_providers.g.dart';

/// Provider for the GPS service
@riverpod
GPSService gpsService(GpsServiceRef ref) {
  return GPSService();
}

/// Provider for GPS status
@riverpod
class GpsStatus extends _$GpsStatus {
  @override
  Stream<GPSStatus> build() {
    final gpsService = ref.watch(gpsServiceProvider);
    return gpsService.statusStream;
  }
}

/// Provider for GPS position
@riverpod
class GpsPosition extends _$GpsPosition {
  @override
  Stream<Position> build() {
    final gpsService = ref.watch(gpsServiceProvider);
    return gpsService.positionStream;
  }
}

/// Provider for GPS settings
@riverpod
class GpsSettings extends _$GpsSettings {
  @override
  Stream<GPSSettings> build() {
    final gpsService = ref.watch(gpsServiceProvider);
    return gpsService.settingsStream;
  }
}

/// Provider for current GPS status
@riverpod
GPSStatus currentGpsStatus(CurrentGpsStatusRef ref) {
  final gpsService = ref.watch(gpsServiceProvider);
  return gpsService.status;
}

/// Provider for last known position
@riverpod
Position? lastPosition(LastPositionRef ref) {
  final gpsService = ref.watch(gpsServiceProvider);
  return gpsService.lastPosition;
}

/// Provider for current GPS settings
@riverpod
GPSSettings currentGpsSettings(CurrentGpsSettingsRef ref) {
  final gpsService = ref.watch(gpsServiceProvider);
  return gpsService.settings;
}

/// Provider to handle GPS functions
@riverpod
GPSController gpsController(GpsControllerRef ref) {
  return GPSController(ref);
}

/// Controller class for GPS operations
class GPSController {
  final Ref _ref;

  GPSController(this._ref);

  /// Get the GPS service
  GPSService get _gpsService => _ref.read(gpsServiceProvider);

  /// Initialize the GPS service
  Future<void> initialize() async {
    await _gpsService.initialize();
  }

  /// Start GPS tracking
  Future<bool> startTracking() async {
    return await _gpsService.startTracking();
  }

  /// Stop GPS tracking
  Future<bool> stopTracking() async {
    return await _gpsService.stopTracking();
  }

  /// Update GPS settings
  Future<void> updateSettings(GPSSettings settings) async {
    await _gpsService.updateSettings(settings);
  }

  /// Get current location once
  Future<Position?> getCurrentLocation() async {
    return await _gpsService.getCurrentLocation();
  }

  /// Run a GPS field test
  Future<Map<String, dynamic>> runFieldTest(
      {Duration duration = const Duration(seconds: 30)}) async {
    return await _gpsService.runFieldTest(duration: duration);
  }

  /// Check if GPS is enabled and has permission
  bool isGpsAvailable() {
    final status = _ref.read(currentGpsStatusProvider);
    return status == GPSStatus.enabled || status == GPSStatus.active;
  }

  /// Check if GPS is actively tracking
  bool isGpsActive() {
    final status = _ref.read(currentGpsStatusProvider);
    return status == GPSStatus.active;
  }

  /// Get current settings
  GPSSettings getCurrentSettings() {
    return _ref.read(currentGpsSettingsProvider);
  }

  /// Get GPS accuracy string
  String getAccuracyString() {
    final settings = _ref.read(currentGpsSettingsProvider);
    return '${settings.estimateAccuracy().toStringAsFixed(1)} m CEP';
  }

  /// Get GPS battery usage string
  String getBatteryUsageString() {
    final settings = _ref.read(currentGpsSettingsProvider);
    final powerUsage = settings.estimateBatteryUsage();
    return '≈ ${powerUsage.toStringAsFixed(0)} mW';
  }
}

/// Provider for checking if GPS is enabled and ready for use
@riverpod
bool gpsReady(GpsReadyRef ref) {
  final status = ref.watch(currentGpsStatusProvider);
  return status == GPSStatus.enabled || status == GPSStatus.active;
}

/// Provider for checking if GPS is actively tracking
@riverpod
bool gpsActive(GpsActiveRef ref) {
  final status = ref.watch(currentGpsStatusProvider);
  return status == GPSStatus.active;
}

/// Provider for GPS connection status for sensor status bar
@riverpod
bool gpsConnected(GpsConnectedRef ref) {
  final status = ref.watch(currentGpsStatusProvider);
  return status == GPSStatus.active;
}
