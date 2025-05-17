// lib/providers/ble_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ble_device.dart';
import '../services/ble_service.dart';

part 'ble_providers.g.dart';

/// Provider for the list of discovered BLE devices
class DiscoveredDevices extends StateNotifier<List<BleDevice>> {
  final BleService _bleService;

  DiscoveredDevices(this._bleService) : super([]) {
    // Subscribe to device updates
    _bleService.devicesStream.listen((devices) {
      state = devices;
    });
  }
}

/// Provider to track if a specific device type is connected
bool deviceTypeConnected(Ref ref, String type) {
  final connectedDevices = ref.watch(connectedDevicesProvider);
  return connectedDevices.any(
      (device) => device.type == type || device.type == BleDevice.typeCombined);
}

/// Provider for BLE connection state changes
class ConnectionState extends StateNotifier<BleDevice?> {
  final BleService _bleService;

  ConnectionState(this._bleService) : super(null) {
    // Subscribe to connection state changes
    _bleService.connectionStateStream.listen((device) {
      state = device;
    });
  }
}

/// Provider to track BLE scanning state
class ScanningState extends StateNotifier<bool> {
  final BleService _bleService;

  ScanningState(this._bleService) : super(false) {
    // Subscribe to scanning state changes
    _bleService.scanningStateStream.listen((isScanning) {
      state = isScanning;
    });
  }
}

/// Provider to check if a heart rate monitor is connected
bool heartRateConnected(Ref ref) {
  final bleController = ref.watch(bleControllerProvider);
  return bleController.isHeartRateMonitorConnected();
}

/// Provider to check if a power meter is connected
bool powerMeterConnected(Ref ref) {
  final bleController = ref.watch(bleControllerProvider);
  return bleController.isPowerMeterConnected();
}

/// Provider to check if a cadence sensor is connected
bool cadenceSensorConnected(Ref ref) {
  final bleController = ref.watch(bleControllerProvider);
  return bleController.isCadenceSensorConnected();
}
