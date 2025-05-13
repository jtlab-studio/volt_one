import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers to track sensor connections
final gpsConnectedProvider = StateProvider<bool>((ref) => false);
final heartRateConnectedProvider = StateProvider<bool>((ref) => false);
final strydConnectedProvider = StateProvider<bool>((ref) => false);

class SensorStatusBar extends ConsumerWidget {
  const SensorStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGpsConnected = ref.watch(gpsConnectedProvider);
    final isHrmConnected = ref.watch(heartRateConnectedProvider);
    final isStrydConnected = ref.watch(strydConnectedProvider);

    // Use the same orange color as the start button
    final orangeColor = Colors.orange;
    // Default color for disconnected sensors that matches the dark theme
    final disconnectedColor = Colors.grey[400];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color:
          Colors.black54, // Slightly lighter than the background for contrast
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIndicator(
            context,
            'GPS',
            isGpsConnected,
            Icons.location_on,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor!,
          ),
          _buildIndicator(
            context,
            'HRM',
            isHrmConnected,
            Icons.favorite,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),
          _buildIndicator(
            context,
            'STRYD',
            isStrydConnected,
            Icons.directions_run,
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

// For demonstration purposes, let's add a demo version with toggleable connections
class SensorStatusBarDemo extends ConsumerWidget {
  const SensorStatusBarDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGpsConnected = ref.watch(gpsConnectedProvider);
    final isHrmConnected = ref.watch(heartRateConnectedProvider);
    final isStrydConnected = ref.watch(strydConnectedProvider);

    // Use the same orange color as the start button
    final orangeColor = Colors.orange;
    // Default color for disconnected sensors that matches the dark theme
    final disconnectedColor = Colors.grey[400];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color:
          Colors.black54, // Slightly lighter than the background for contrast
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildToggleableIndicator(
            context,
            ref,
            'GPS',
            isGpsConnected,
            Icons.location_on,
            gpsConnectedProvider,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor!,
          ),
          _buildToggleableIndicator(
            context,
            ref,
            'HRM',
            isHrmConnected,
            Icons.favorite,
            heartRateConnectedProvider,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),
          _buildToggleableIndicator(
            context,
            ref,
            'STRYD',
            isStrydConnected,
            Icons.directions_run,
            strydConnectedProvider,
            connectedColor: orangeColor,
            disconnectedColor: disconnectedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleableIndicator(
      BuildContext context,
      WidgetRef ref,
      String label,
      bool isConnected,
      IconData icon,
      StateProvider<bool> provider,
      {required Color connectedColor,
      required Color disconnectedColor}) {
    return InkWell(
      onTap: () {
        // Toggle connection state
        ref.read(provider.notifier).state = !isConnected;
      },
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
