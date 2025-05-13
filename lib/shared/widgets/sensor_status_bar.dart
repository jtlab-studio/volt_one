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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Theme.of(context)
          .primaryColor
          .withAlpha(25), // Using withAlpha instead of withOpacity
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIndicator(context, 'GPS', isGpsConnected, Icons.location_on),
          _buildIndicator(context, 'HRM', isHrmConnected, Icons.favorite),
          _buildIndicator(
              context, 'Stryd', isStrydConnected, Icons.directions_run),
        ],
      ),
    );
  }

  Widget _buildIndicator(
      BuildContext context, String label, bool isConnected, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isConnected ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: isConnected ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
