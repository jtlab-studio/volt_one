// lib/providers/ble_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/ble_device.dart';
import '../services/ble_service.dart';

part 'ble_providers.g.dart';

/// Provider for the BleService
@riverpod
BleService bleService(BleServiceRef ref) {
  return BleService();
}

/// Provider for the list of discovered BLE devices
@riverpod
class DiscoveredDevices extends _$DiscoveredDevices {
  @override
  Stream<List<BleDevice>> build() {
    final bleService = ref.watch(bleServiceProvider);
    return bleService.devicesStream;
  }
}

/// Provider for the list of connected BLE devices
@riverpod
List<BleDevice> connectedDevices(ConnectedDevicesRef ref) {
  final bleService = ref.watch(bleServiceProvider);
  return bleService.connectedDevices;
}

/// Provider for the list of saved BLE devices
@riverpod
List<BleDevice> savedDevices(SavedDevicesRef ref) {
  final bleService = ref.watch(bleServiceProvider);
  return bleService.savedDevices;
}

/// Provider for the BLE scanning state
@riverpod
class ScanningState extends _$ScanningState {
  @override
  Stream<bool> build() {
    final bleService = ref.watch(bleServiceProvider);
    return bleService.scanningStateStream;
  }
}

/// Provider to track if a specific device type is connected
@riverpod
bool deviceTypeConnected(DeviceTypeConnectedRef ref, String type) {
  final connectedDevices = ref.watch(connectedDevicesProvider);
  return connectedDevices.any((device) =>
      device.type == type || device.type == BleDevice.TYPE_COMBINED);
}

/// Provider for BLE connection state changes
@riverpod
class ConnectionState extends _$ConnectionState {
  @override
  Stream<BleDevice> build() {
    final bleService = ref.watch(bleServiceProvider);
    return bleService.connectionStateStream;
  }
}

/// Provider to handle BLE functions
@riverpod
BLEController bleController(BleControllerRef ref) {
  return BLEController(ref);
}

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
    return _bleService.isDeviceTypeConnected(BleDevice.TYPE_HEART_RATE);
  }

  /// Check if a power meter is connected
  bool isPowerMeterConnected() {
    return _bleService.isDeviceTypeConnected(BleDevice.TYPE_POWER);
  }

  /// Check if a cadence sensor is connected
  bool isCadenceSensorConnected() {
    return _bleService.isDeviceTypeConnected(BleDevice.TYPE_CADENCE);
  }
}

/// Quick access providers for heart rate monitor connection state
@riverpod
bool heartRateConnected(HeartRateConnectedRef ref) {
  final bleController = ref.watch(bleControllerProvider);
  return bleController.isHeartRateMonitorConnected();
}

/// Quick access providers for power meter connection state
@riverpod
bool powerMeterConnected(PowerMeterConnectedRef ref) {
  final bleController = ref.watch(bleControllerProvider);
  return bleController.isPowerMeterConnected();
}

/// Quick access providers for cadence sensor connection state
@riverpod
bool cadenceSensorConnected(CadenceSensorConnectedRef ref) {
  final bleController = ref.watch(bleControllerProvider);
  return bleController.isCadenceSensorConnected();
}
