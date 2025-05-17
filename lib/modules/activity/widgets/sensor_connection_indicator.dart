// lib/modules/activity/widgets/sensor_connection_indicator.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/gps_providers_extended.dart';
import '../../../providers/ble_providers_extended.dart';

class SensorConnectionIndicator extends ConsumerWidget {
  const SensorConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch connection status providers
    final isGpsConnected = ref.watch(gpsConnectedProvider);
    final isHeartRateConnected = ref.watch(heartRateConnectedProvider);
    final isPowerConnected = ref.watch(powerMeterConnectedProvider);
    final isCadenceConnected = ref.watch(cadenceSensorConnectedProvider);

    // Use the same orange color as in other screens
    final orangeColor = const Color.fromRGBO(255, 152, 0, 1.0);

    // Default color for disconnected sensors that matches the current theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final disconnectedColor = isDarkMode
        ? const Color.fromRGBO(200, 200, 200, 0.7)
        : const Color.fromRGBO(120, 120, 120, 0.7);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isDarkMode
          ? const Color.fromRGBO(0, 0, 0, 0.35)
          : const Color.fromRGBO(0, 0, 0, 0.15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // GPS indicator
          _buildIndicator(
            context,
            'GPS',
            isGpsConnected,
            Icons.location_on,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),

          // Heart rate monitor indicator
          _buildIndicator(
            context,
            'HRM',
            isHeartRateConnected,
            Icons.favorite,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),

          // Power meter indicator
          _buildIndicator(
            context,
            'POWER',
            isPowerConnected,
            Icons.flash_on,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),

          // Cadence sensor indicator
          _buildIndicator(
            context,
            'CADENCE',
            isCadenceConnected,
            Icons.speed,
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
