// lib/providers/gps_providers.g.dart

// Custom implementation to replace auto-generated file
// This avoids using internal APIs that are not meant to be used directly

part of 'gps_providers.dart';

// **************************************************************************
// Custom implementation to replace generated providers
// **************************************************************************

// Provider for GPS service
final gpsServiceProvider = Provider<GPSService>((ref) {
  return GPSService();
});

// Provider for GPS status
final gpsStatusProvider = StreamProvider<GPSStatus>((ref) {
  final gpsService = ref.watch(gpsServiceProvider);
  return gpsService.statusStream;
});

// Provider for GPS position
final gpsPositionProvider = StreamProvider<Position>((ref) {
  final gpsService = ref.watch(gpsServiceProvider);
  return gpsService.positionStream;
});

// Provider for GPS settings
final gpsSettingsProvider = StreamProvider<GPSSettings>((ref) {
  final gpsService = ref.watch(gpsServiceProvider);
  return gpsService.settingsStream;
});

// Provider for current GPS status
final currentGpsStatusProvider = Provider<GPSStatus>((ref) {
  final gpsService = ref.watch(gpsServiceProvider);
  return gpsService.status;
});

// Provider for last known position
final lastPositionProvider = Provider<Position?>((ref) {
  final gpsService = ref.watch(gpsServiceProvider);
  return gpsService.lastPosition;
});

// Provider for current GPS settings
final currentGpsSettingsProvider = Provider<GPSSettings>((ref) {
  final gpsService = ref.watch(gpsServiceProvider);
  return gpsService.settings;
});

// Provider for GPS controller
final gpsControllerProvider = Provider<GPSController>((ref) {
  return GPSController(ref);
});

// Provider for checking if GPS is enabled and ready for use
final gpsReadyProvider = Provider<bool>((ref) {
  final status = ref.watch(currentGpsStatusProvider);
  return status == GPSStatus.enabled || status == GPSStatus.active;
});

// Provider for checking if GPS is actively tracking
final gpsActiveProvider = Provider<bool>((ref) {
  final status = ref.watch(currentGpsStatusProvider);
  return status == GPSStatus.active;
});

// Provider for GPS connection status for sensor status bar
final gpsConnectedProvider = Provider<bool>((ref) {
  final status = ref.watch(currentGpsStatusProvider);
  return status == GPSStatus.active;
});

// Implementation of GpsStatus class for StateNotifier
class GpsStatus extends StateNotifier<GPSStatus> {
  GpsStatus(this.ref) : super(GPSStatus.initializing) {
    _initialize();
  }

  final Ref ref;

  void _initialize() {
    final gpsService = ref.read(gpsServiceProvider);
    gpsService.statusStream.listen((status) {
      state = status;
    });
  }
}

// Implementation of GpsPosition class for StateNotifier
class GpsPosition extends StateNotifier<Position?> {
  GpsPosition(this.ref) : super(null) {
    _initialize();
  }

  final Ref ref;

  void _initialize() {
    final gpsService = ref.read(gpsServiceProvider);
    gpsService.positionStream.listen((position) {
      state = position;
    });
  }
}

// Implementation of GpsSettings class for StateNotifier
class GpsSettings extends StateNotifier<GPSSettings> {
  GpsSettings(this.ref) : super(const GPSSettings()) {
    _initialize();
  }

  final Ref ref;

  void _initialize() {
    final gpsService = ref.read(gpsServiceProvider);
    gpsService.settingsStream.listen((settings) {
      state = settings;
    });
  }
}

// Controller class for GPS operations
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
