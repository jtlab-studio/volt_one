// lib/providers/ble_providers_extended.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ble_device.dart';

// State providers for sensor connection status
// These make it possible to manually set connection status for testing

/// Provider for heart rate monitor connection status
final heartRateConnectedProvider = StateProvider<bool>((ref) => false);

/// Provider for power meter connection status
final powerMeterConnectedProvider = StateProvider<bool>((ref) => false);

/// Provider for cadence sensor connection status
final cadenceSensorConnectedProvider = StateProvider<bool>((ref) => false);

/// Provider for whether any heart rate device is available
final hasHeartRateDeviceProvider = StateProvider<bool>((ref) => true);

/// Provider for whether any power meter is available
final hasPowerMeterProvider = StateProvider<bool>((ref) => true);

/// Provider for whether any cadence sensor is available
final hasCadenceSensorProvider = StateProvider<bool>((ref) => true);
