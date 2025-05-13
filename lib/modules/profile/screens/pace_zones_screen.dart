// lib/modules/profile/screens/pace_zones_screen.dart - New dedicated Pace zones screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for managing Pace training zones
class PaceZonesScreen extends ConsumerWidget {
  const PaceZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, this is a placeholder screen
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.speed,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              'Pace Zones',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'This feature is coming soon!',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Sample card to show what pace zones might look like
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Pace Zones',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildSampleZoneRow(
                      context,
                      1,
                      'Recovery',
                      '6:30+ min/km',
                      Colors.blue[300]!,
                    ),
                    const SizedBox(height: 8),
                    _buildSampleZoneRow(
                      context,
                      2,
                      'Easy',
                      '5:45 - 6:30 min/km',
                      Colors.teal,
                    ),
                    const SizedBox(height: 8),
                    _buildSampleZoneRow(
                      context,
                      3,
                      'Moderate',
                      '5:00 - 5:45 min/km',
                      Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildSampleZoneRow(
                      context,
                      4,
                      'Threshold',
                      '4:15 - 5:00 min/km',
                      Colors.amber,
                    ),
                    const SizedBox(height: 8),
                    _buildSampleZoneRow(
                      context,
                      5,
                      'Interval',
                      '3:45 - 4:15 min/km',
                      Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    _buildSampleZoneRow(
                      context,
                      6,
                      'Sprint',
                      '< 3:45 min/km',
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Information about pace zones
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Pace Zones',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pace zones divide running paces into ranges that correspond to different training intensities. Each zone trains different energy systems and produces specific adaptations.\n\n'
                      'When fully implemented, pace zones will be customized to your fitness level and calculated based on your critical pace or recent race performances.',
                      style: TextStyle(
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pace zones are the most directly actionable training metric, as you can directly control your pace during workouts.',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build a sample zone row
  Widget _buildSampleZoneRow(
    BuildContext context,
    int zoneNumber,
    String zoneName,
    String zoneRange,
    Color zoneColor,
  ) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: zoneColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              zoneNumber.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                zoneName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                zoneRange,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
