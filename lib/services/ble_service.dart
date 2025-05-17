// lib/services/ble_service.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/ble_device.dart';
import 'storage_service.dart';

/// A service for managing Bluetooth Low Energy connections
class BleService {
  // Singleton instance
  static final BleService _instance = BleService._internal();
  factory BleService() => _instance;
  BleService._internal();

  // Instance of StorageService
  final StorageService _storage = StorageService();

  // Stream controllers
  final _devicesStreamController =
      StreamController<List<BleDevice>>.broadcast();
  final _connectionStateController = StreamController<BleDevice>.broadcast();
  final _scanningStateController = StreamController<bool>.broadcast();

  // Track discovered devices
  final List<BleDevice> _discoveredDevices = [];

  // Track connected devices
  final Map<String, BluetoothDevice> _connectedDevices = {};

  // Track saved devices
  final List<BleDevice> _savedDevices = [];

  // Track scanning state
  bool _isScanning = false;

  // Stream of discovered devices
  Stream<List<BleDevice>> get devicesStream => _devicesStreamController.stream;

  // Stream of connection state changes
  Stream<BleDevice> get connectionStateStream =>
      _connectionStateController.stream;

  // Stream of scanning state changes
  Stream<bool> get scanningStateStream => _scanningStateController.stream;

  // Get discovered devices
  List<BleDevice> get discoveredDevices =>
      List.unmodifiable(_discoveredDevices);

  // Get connected devices
  List<BleDevice> get connectedDevices =>
      _discoveredDevices.where((d) => d.connected).toList();

  // Get saved devices
  List<BleDevice> get savedDevices => List.unmodifiable(_savedDevices);

  // Get scanning state
  bool get isScanning => _isScanning;

  /// Initialize the service
  Future<void> initialize() async {
    // Request necessary permissions
    if (Platform.isAndroid) {
      await _requestAndroidPermissions();
    } else if (Platform.isIOS) {
      // iOS permissions are handled by the OS
    }

    // Load saved devices from storage
    await _loadSavedDevices();

    // Listen for adapter state changes
    FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        // Update state for any already connected devices
        _updateConnectedDevicesStatus();
      }
    });

    // Listen for connection state changes
    // In FlutterBluePlus, use the connection state stream
    FlutterBluePlus.connectionStateChanges.listen((event) {
      _updateDeviceConnectionState(event.device,
          event.connectionState == BluetoothConnectionState.connected);
    });

    // Listen for scan results
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        _addDiscoveredDevice(result);
      }
      _devicesStreamController.add(_discoveredDevices);
    });

    // Listen for scan state changes
    // Use isScanning property to track scan state
    FlutterBluePlus.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      _scanningStateController.add(_isScanning);
    });

    // Update state for any already connected devices
    _updateConnectedDevicesStatus();
  }

  /// Request Android permissions needed for BLE scanning
  Future<void> _requestAndroidPermissions() async {
    // For Android 12+ we need fine location, bluetooth scan & connect permissions
    if (Platform.isAndroid) {
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      await Permission.location.request();
    }
  }

  /// Check for any already connected devices
  Future<void> _updateConnectedDevicesStatus() async {
    try {
      final devices = FlutterBluePlus.connectedDevices;
      for (var device in devices) {
        _connectedDevices[device.remoteId.str] = device;
        _updateDeviceConnectionState(device, true);
      }
    } catch (e) {
      debugPrint('Error getting connected devices: $e');
    }
  }

  /// Start scanning for BLE devices
  Future<void> startScan(
      {Duration duration = const Duration(seconds: 15)}) async {
    if (_isScanning) return;

    try {
      // Check for permissions first
      if (Platform.isAndroid) {
        final bluetoothScan = await Permission.bluetoothScan.status;
        final bluetoothConnect = await Permission.bluetoothConnect.status;
        final location = await Permission.location.status;

        if (bluetoothScan != PermissionStatus.granted ||
            bluetoothConnect != PermissionStatus.granted ||
            location != PermissionStatus.granted) {
          throw Exception('Missing required permissions');
        }
      }

      // Clear previous results except saved devices
      _discoveredDevices.removeWhere((device) => !device.isSaved);

      // Set scanning state
      _isScanning = true;
      _scanningStateController.add(_isScanning);

      // Update UI with any existing devices
      _devicesStreamController.add(_discoveredDevices);

      // Start scanning
      await FlutterBluePlus.startScan(
        timeout: duration,
        androidScanMode: AndroidScanMode.lowLatency,
      );
    } catch (e) {
      _isScanning = false;
      _scanningStateController.add(_isScanning);
      debugPrint('Error starting scan: $e');
      rethrow;
    }
  }

  /// Stop scanning for BLE devices
  Future<void> stopScan() async {
    if (!_isScanning) return;

    try {
      await FlutterBluePlus.stopScan();
      _isScanning = false;
      _scanningStateController.add(_isScanning);
    } catch (e) {
      debugPrint('Error stopping scan: $e');
    }
  }

  /// Connect to a BLE device
  Future<bool> connectToDevice(String deviceId) async {
    try {
      // Find the device in discovered devices
      final index = _discoveredDevices.indexWhere((d) => d.id == deviceId);
      if (index < 0) return false;

      // Get the device
      final device = _discoveredDevices[index];

      // If already connected, return
      if (device.connected) return true;

      // Find or create BluetoothDevice
      BluetoothDevice? bleDevice;
      if (_connectedDevices.containsKey(deviceId)) {
        bleDevice = _connectedDevices[deviceId];
      } else {
        // Find device by ID from discovered devices
        try {
          final scanResults = await FlutterBluePlus.scanResults.first;
          for (final scanResult in scanResults) {
            if (scanResult.device.remoteId.str == deviceId) {
              bleDevice = scanResult.device;
              break;
            }
          }
        } catch (e) {
          debugPrint('Error finding device by ID: $e');
        }

        // If device not found in scan results, create it from ID
        if (bleDevice == null) {
          final id = DeviceIdentifier(deviceId);
          // Create device from ID correctly using BluetoothDevice constructor
          bleDevice = BluetoothDevice.fromId(deviceId);
        }
      }

      if (bleDevice == null) return false;

      // Connect to the device
      await bleDevice.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
      );

      // Store in connected devices map
      _connectedDevices[deviceId] = bleDevice;

      // Update connection state
      _updateDeviceConnectionState(bleDevice, true);

      // Discover services after a short delay to ensure connection is stable
      await Future.delayed(const Duration(milliseconds: 500));

      final services = await bleDevice.discoverServices();
      final serviceIds = services.map((s) => s.uuid.toString()).toList();

      // Update device services
      final updatedDevice = device.copyWith(
          services: serviceIds,
          connected: true,
          lastConnected: DateTime.now(),
          type: BleDevice.determineDeviceType(serviceIds));

      // Update in discovered devices
      _discoveredDevices[index] = updatedDevice;

      // Update saved device if this is one
      final savedIndex = _savedDevices.indexWhere((d) => d.id == deviceId);
      if (savedIndex >= 0) {
        _savedDevices[savedIndex] = updatedDevice.copyWith(isSaved: true);
        await _saveSavedDevices();
      }

      _devicesStreamController.add(_discoveredDevices);
      _connectionStateController.add(updatedDevice);

      return true;
    } catch (e) {
      debugPrint('Error connecting to device: $e');
      return false;
    }
  }

  /// Disconnect from a BLE device
  Future<bool> disconnectFromDevice(String deviceId) async {
    try {
      if (!_connectedDevices.containsKey(deviceId)) return false;

      // Get the device
      final bleDevice = _connectedDevices[deviceId];
      if (bleDevice == null) return false;

      // Disconnect
      await bleDevice.disconnect();

      // Update connection state
      _updateDeviceConnectionState(bleDevice, false);

      return true;
    } catch (e) {
      debugPrint('Error disconnecting from device: $e');
      return false;
    }
  }

  /// Save a device for future quick-connect
  Future<bool> saveDevice(String deviceId) async {
    try {
      // Find device in discovered devices
      final index = _discoveredDevices.indexWhere((d) => d.id == deviceId);
      if (index < 0) return false;

      final device = _discoveredDevices[index];

      // Update device with saved flag
      final savedDevice = device.copyWith(isSaved: true);
      _discoveredDevices[index] = savedDevice;

      // Add to saved devices if not already there
      if (!_savedDevices.any((d) => d.id == deviceId)) {
        _savedDevices.add(savedDevice);
      } else {
        // Update in saved devices
        final savedIndex = _savedDevices.indexWhere((d) => d.id == deviceId);
        _savedDevices[savedIndex] = savedDevice;
      }

      // Save to storage
      await _saveSavedDevices();

      // Update streams
      _devicesStreamController.add(_discoveredDevices);

      return true;
    } catch (e) {
      debugPrint('Error saving device: $e');
      return false;
    }
  }

  /// Remove a saved device
  Future<bool> removeSavedDevice(String deviceId) async {
    try {
      // Remove from saved devices
      _savedDevices.removeWhere((d) => d.id == deviceId);

      // Update discovered devices
      final index = _discoveredDevices.indexWhere((d) => d.id == deviceId);
      if (index >= 0) {
        final device = _discoveredDevices[index];
        _discoveredDevices[index] = device.copyWith(isSaved: false);
      }

      // Save to storage
      await _saveSavedDevices();

      // Update streams
      _devicesStreamController.add(_discoveredDevices);

      return true;
    } catch (e) {
      debugPrint('Error removing saved device: $e');
      return false;
    }
  }

  /// Connect to all saved devices
  Future<void> connectToAllSavedDevices() async {
    for (var device in _savedDevices) {
      if (!device.connected) {
        await connectToDevice(device.id);
        // Add a short delay between connections to avoid overwhelming the BLE stack
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  /// Check if a specific type of device is connected
  bool isDeviceTypeConnected(String type) {
    return connectedDevices.any((device) =>
        device.type == type || device.type == BleDevice.typeCombined);
  }

  /// Get a connected device by type
  BleDevice? getConnectedDeviceByType(String type) {
    return connectedDevices.firstWhere(
      (device) => device.type == type || device.type == BleDevice.typeCombined,
      orElse: () => connectedDevices.firstWhere(
        (device) => device.type == BleDevice.typeUnknown,
        orElse: () => throw Exception('No device of type $type connected'),
      ),
    );
  }

  /// Dispose the service
  void dispose() {
    _devicesStreamController.close();
    _connectionStateController.close();
    _scanningStateController.close();
  }

  // Helper to add or update a discovered device
  void _addDiscoveredDevice(ScanResult result) {
    // Create a BLE device from scan result
    final deviceId = result.device.remoteId.str;
    final deviceName = result.device.platformName.isNotEmpty
        ? result.device.platformName
        : 'Unknown Device';

    // Check if already in the list
    final index = _discoveredDevices.indexWhere((d) => d.id == deviceId);

    // Check if this is a saved device
    final isSaved = _savedDevices.any((d) => d.id == deviceId);

    // Check if connected
    final isConnected = _connectedDevices.containsKey(deviceId);

    if (index >= 0) {
      // Update existing device
      final existingDevice = _discoveredDevices[index];
      _discoveredDevices[index] = existingDevice.copyWith(
        name: deviceName.isNotEmpty ? deviceName : existingDevice.name,
        rssi: result.rssi,
        connected: isConnected,
        isSaved: isSaved || existingDevice.isSaved,
      );
    } else {
      // Create new device
      final newDevice = BleDevice(
        id: deviceId,
        name: deviceName,
        type: BleDevice.typeUnknown, // Will update after connection
        rssi: result.rssi,
        connected: isConnected,
        isSaved: isSaved,
      );

      _discoveredDevices.add(newDevice);
    }
  }

  // Helper to update device connection state
  void _updateDeviceConnectionState(BluetoothDevice bleDevice, bool connected) {
    final deviceId = bleDevice.remoteId.str;

    if (connected) {
      _connectedDevices[deviceId] = bleDevice;
    } else {
      _connectedDevices.remove(deviceId);
    }

    // Update in discovered devices
    final index = _discoveredDevices.indexWhere((d) => d.id == deviceId);
    if (index >= 0) {
      final device = _discoveredDevices[index];
      final updatedDevice = device.copyWith(
        connected: connected,
        lastConnected: connected ? DateTime.now() : device.lastConnected,
      );
      _discoveredDevices[index] = updatedDevice;

      // Notify listeners
      _connectionStateController.add(updatedDevice);
    } else if (connected) {
      // If device is connected but not in discovered devices, add it
      final newDevice = BleDevice(
        id: deviceId,
        name: bleDevice.platformName.isNotEmpty
            ? bleDevice.platformName
            : 'Unknown Device',
        type: BleDevice.typeUnknown,
        connected: true,
        lastConnected: DateTime.now(),
        isSaved: _savedDevices.any((d) => d.id == deviceId),
      );

      _discoveredDevices.add(newDevice);
      _connectionStateController.add(newDevice);
    }

    // Update saved devices too
    final savedIndex = _savedDevices.indexWhere((d) => d.id == deviceId);
    if (savedIndex >= 0) {
      final savedDevice = _savedDevices[savedIndex];
      _savedDevices[savedIndex] = savedDevice.copyWith(
        connected: connected,
        lastConnected: connected ? DateTime.now() : savedDevice.lastConnected,
      );
    }

    // Update streams
    _devicesStreamController.add(_discoveredDevices);
  }

  // Load saved devices from storage
  Future<void> _loadSavedDevices() async {
    try {
      final devices = await _storage.getSavedDevices();
      _savedDevices.clear();
      _savedDevices.addAll(devices);

      // Also add them to discovered devices
      for (var device in devices) {
        if (!_discoveredDevices.any((d) => d.id == device.id)) {
          _discoveredDevices.add(device);
        }
      }

      _devicesStreamController.add(_discoveredDevices);
    } catch (e) {
      debugPrint('Error loading saved devices: $e');
    }
  }

  // Save devices to storage
  Future<void> _saveSavedDevices() async {
    try {
      await _storage.saveBleDevices(_savedDevices);
    } catch (e) {
      debugPrint('Error saving devices: $e');
    }
  }
}
