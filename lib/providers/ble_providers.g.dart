// lib/providers/ble_providers.g.dart

part of 'ble_providers.dart';

// Simple provider implementations that don't rely on internal Riverpod APIs

/// Provider for the BLE service
final bleServiceProvider = Provider<BleService>((ref) {
  return BleService();
});

/// Provider for discovered devices
final discoveredDevicesProvider = StreamProvider<List<BleDevice>>((ref) {
  final bleService = ref.watch(bleServiceProvider);
  return bleService.devicesStream;
});

/// Provider for connected devices
final connectedDevicesProvider = Provider<List<BleDevice>>((ref) {
  final bleService = ref.watch(bleServiceProvider);
  return bleService.connectedDevices;
});

/// Provider for saved devices
final savedDevicesProvider = Provider<List<BleDevice>>((ref) {
  final bleService = ref.watch(bleServiceProvider);
  return bleService.savedDevices;
});

/// Provider for scanning state
final scanningStateProvider = StreamProvider<bool>((ref) {
  final bleService = ref.watch(bleServiceProvider);
  return bleService.scanningStateStream;
});

/// Provider for checking if a device type is connected
final deviceTypeConnectedProvider = Provider.family<bool, String>((ref, type) {
  final connectedDevices = ref.watch(connectedDevicesProvider);
  return connectedDevices.any(
      (device) => device.type == type || device.type == BleDevice.typeCombined);
});

/// Provider for connection state
final connectionStateProvider = StreamProvider<BleDevice>((ref) {
  final bleService = ref.watch(bleServiceProvider);
  return bleService.connectionStateStream;
});

/// Controller class for BLE operations
class BLEController {
  final Ref _ref;

  BLEController(this._ref);

  /// Get the BLE service
  BleService get _bleService => _ref.read(bleServiceProvider);

  /// Initialize the BLE service
  Future<void> initialize() async {
    await _bleService.initialize();
  }

  /// Start scanning for devices
  Future<void> startScan(
      {Duration duration = const Duration(seconds: 15)}) async {
    await _bleService.startScan(duration: duration);
  }

  /// Stop scanning for devices
  Future<void> stopScan() async {
    await _bleService.stopScan();
  }

  /// Connect to a device
  Future<bool> connectToDevice(String deviceId) async {
    return await _bleService.connectToDevice(deviceId);
  }

  /// Disconnect from a device
  Future<bool> disconnectFromDevice(String deviceId) async {
    return await _bleService.disconnectFromDevice(deviceId);
  }

  /// Save a device
  Future<bool> saveDevice(String deviceId) async {
    return await _bleService.saveDevice(deviceId);
  }

  /// Remove a saved device
  Future<bool> removeSavedDevice(String deviceId) async {
    return await _bleService.removeSavedDevice(deviceId);
  }

  /// Connect to all saved devices
  Future<void> connectToAllSavedDevices() async {
    await _bleService.connectToAllSavedDevices();
  }

  /// Check if a heart rate monitor is connected
  bool isHeartRateMonitorConnected() {
    return _bleService.isDeviceTypeConnected(BleDevice.typeHeartRate);
  }

  /// Check if a power meter is connected
  bool isPowerMeterConnected() {
    return _bleService.isDeviceTypeConnected(BleDevice.typePower);
  }

  /// Check if a cadence sensor is connected
  bool isCadenceSensorConnected() {
    return _bleService.isDeviceTypeConnected(BleDevice.typeCadence);
  }
}

/// Provider for the BLE controller
final bleControllerProvider = Provider<BLEController>((ref) {
  return BLEController(ref);
});

/// Provider for heart rate monitor connection status
final heartRateConnectedProvider = Provider<bool>((ref) {
  final bleController = ref.watch(bleControllerProvider);
  return bleController.isHeartRateMonitorConnected();
});

/// Provider for power meter connection status
final powerMeterConnectedProvider = Provider<bool>((ref) {
  final bleController = ref.watch(bleControllerProvider);
  return bleController.isPowerMeterConnected();
});

/// Provider for cadence sensor connection status
final cadenceSensorConnectedProvider = Provider<bool>((ref) {
  final bleController = ref.watch(bleControllerProvider);
  return bleController.isCadenceSensorConnected();
});
