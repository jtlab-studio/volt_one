// lib/shared/widgets/sensor_status_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ble_providers.dart';
import '../../providers/gps_providers.dart';

/// Sensor status bar widget that displays connection status of sensors
class SensorStatusBar extends ConsumerWidget {
  const SensorStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gpsConnected = ref.watch(gpsConnectedProvider);
    final heartRateConnected = ref.watch(heartRateConnectedProvider);
    final powerMeterConnected = ref.watch(powerMeterConnectedProvider);

    // Use the same orange color as in the start_activity_screen.dart
    final orangeColor = const Color.fromRGBO(255, 152, 0, 1.0);
    // Default color for disconnected sensors that matches the dark theme
    final disconnectedColor = const Color.fromRGBO(200, 200, 200, 0.7);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: const Color.fromRGBO(0, 0, 0, 0.35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // GPS indicator
          _buildIndicator(
            context,
            'GPS',
            gpsConnected,
            Icons.location_on,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),

          // HRM indicator
          _buildIndicator(
            context,
            'HRM',
            heartRateConnected,
            Icons.favorite,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),

          // Power meter indicator
          _buildIndicator(
            context,
            'STRYD',
            powerMeterConnected,
            Icons.flash_on,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(
      BuildContext context, String label, bool isConnected, IconData icon,
      {required Color connectedColor, required Color disconnectedColor}) {
    return Tooltip(
      message: isConnected ? '$label connected' : '$label not connected',
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isConnected ? connectedColor : disconnectedColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isConnected ? connectedColor : disconnectedColor,
              fontWeight: isConnected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Legacy demo version with toggleable connections - can be removed in production
class SensorStatusBarDemo extends ConsumerWidget {
  const SensorStatusBarDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // These providers should be replaced with the real connection status
    final isGpsConnected = ref.watch(gpsConnectedProvider);
    final isHrmConnected = ref.watch(heartRateConnectedProvider);
    final isStrydConnected = ref.watch(powerMeterConnectedProvider);

    // Use the same orange color as the start button
    final orangeColor = const Color.fromRGBO(255, 152, 0, 1.0);
    // Default color for disconnected sensors that matches the dark theme
    final disconnectedColor = const Color.fromRGBO(200, 200, 200, 0.7);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: const Color.fromRGBO(0, 0, 0, 0.35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildToggleableIndicator(
            context,
            ref,
            'GPS',
            isGpsConnected,
            Icons.location_on,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),
          _buildToggleableIndicator(
            context,
            ref,
            'HRM',
            isHrmConnected,
            Icons.favorite,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),
          _buildToggleableIndicator(
            context,
            ref,
            'STRYD',
            isStrydConnected,
            Icons.flash_on,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleableIndicator(BuildContext context, WidgetRef ref,
      String label, bool isConnected, IconData icon,
      {required Color connectedColor, required Color disconnectedColor}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isConnected ? connectedColor : disconnectedColor,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: isConnected ? connectedColor : disconnectedColor,
            fontWeight: isConnected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
