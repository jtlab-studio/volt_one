// lib/modules/profile/screens/pace_zones_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../providers/user_profile_provider.dart';

/// Screen for managing Pace training zones
class PaceZonesScreen extends ConsumerWidget {
  const PaceZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);

    // We get the critical pace value from user profile
    final criticalPace = userProfile.criticalPace;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add large icon at the top
          const Icon(
            Icons.speed,
            size: 80,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          Text(
            'Pace Zones',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          // Critical Pace Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Critical Pace',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Critical pace is the pace you can sustain for approximately 1 hour of running. It is a key physiological marker similar to lactate threshold.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Critical Pace value display and edit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.speed, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            _formatPace(criticalPace),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _editCriticalPace(context, ref, criticalPace),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(255, 152, 0, 1.0), // Orange
                          foregroundColor: Colors.white,
                          minimumSize: const Size(100, 36),
                        ),
                        child: Text(localizations.translate('edit')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Zone Configuration Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('zone_configuration'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Number of zones setting
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Number of Pace Zones'),
                      DropdownButton<int>(
                        value: userProfile.paceZones,
                        items: [3, 4, 5, 6, 7].map((zoneCount) {
                          return DropdownMenuItem<int>(
                            value: zoneCount,
                            child: Text(zoneCount.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(userProfileProvider.notifier).update(
                                  (state) => state.copyWith(paceZones: value),
                                );
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Auto-calculate zones toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Auto-calculate Pace Zones'),
                            Text(
                              'Automatically calculate zones based on your critical pace',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: userProfile.autoCalculatePaceZones,
                        onChanged: (value) {
                          ref.read(userProfileProvider.notifier).update(
                                (state) => state.copyWith(
                                    autoCalculatePaceZones: value),
                              );
                        },
                        activeColor:
                            const Color.fromRGBO(255, 152, 0, 1.0), // Orange
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Pace Zones Display
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pace Zones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Show either auto-calculated zones or editable zones
                  userProfile.autoCalculatePaceZones
                      ? _buildCalculatedPaceZones(context, localizations,
                          criticalPace, userProfile.paceZones)
                      : _buildEditablePaceZones(context, ref, localizations,
                          criticalPace, userProfile.paceZones),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

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

                  // Critical Pace explanation
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.green.withAlpha(120), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What is Critical Pace?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Critical Pace (CP) is the fastest pace you can sustain for approximately 30-60 minutes of continuous running. It closely correlates with your lactate threshold pace - the intensity at which lactate begins to accumulate in the blood faster than it can be cleared. Critical Pace serves as the anchor for calculating your personalized pace zones, allowing for precise training intensities that target specific physiological adaptations. You can determine your Critical Pace through time trials, race results, or specific field tests such as a 30-minute time trial.',
                          style: TextStyle(
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Pace zones divide running paces into ranges that correspond to different training intensities. Each zone trains different energy systems and produces specific adaptations.\n\n'
                    'Zone 1 (Recovery): Very easy running that promotes recovery.\n'
                    'Zone 2 (Easy): Aerobic development and fat metabolism.\n'
                    'Zone 3 (Moderate): Improved aerobic capacity and efficiency.\n'
                    'Zone 4 (Threshold): Lactate threshold development.\n'
                    'Zone 5 (Interval): VO2max development.\n'
                    'Zone 6 (Sprint): Anaerobic capacity and neuromuscular power.',
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
                            'Pace zones are the most directly actionable training metric, as you can control your pace during workouts.',
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
    );
  }

  // Edit Critical Pace dialog
  void _editCriticalPace(
      BuildContext context, WidgetRef ref, int currentPaceSeconds) {
    final minutes = currentPaceSeconds ~/ 60;
    final seconds = currentPaceSeconds % 60;

    final minutesController = TextEditingController(text: minutes.toString());
    final secondsController =
        TextEditingController(text: seconds.toString().padLeft(2, '0'));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Critical Pace'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your critical pace (pace you can sustain for about 1 hour)',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minutesController,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(':'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: secondsController,
                    decoration: const InputDecoration(
                      labelText: 'Seconds',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('min/km'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final mins = int.tryParse(minutesController.text) ?? 0;
              final secs = int.tryParse(secondsController.text) ?? 0;

              // Validate input
              if (mins >= 0 && secs >= 0 && secs < 60) {
                final totalSeconds = (mins * 60) + secs;
                if (totalSeconds > 0) {
                  ref.read(userProfileProvider.notifier).update(
                        (state) => state.copyWith(criticalPace: totalSeconds),
                      );
                }
              }

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Format pace from seconds to mm:ss format
  String _formatPace(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')} min/km';
  }

  // Display calculated pace zones
  Widget _buildCalculatedPaceZones(BuildContext context,
      AppLocalizations localizations, int criticalPace, int numZones) {
    final zoneData = _calculatePaceZones(criticalPace, numZones);

    return Column(
      children: [
        ...zoneData.asMap().entries.map((entry) {
          final index = entry.key;
          final zoneInfo = entry.value;
          return _buildZoneRow(
            context,
            index + 1,
            zoneInfo['name'] as String,
            zoneInfo['range'] as String,
            _getPaceZoneColor(index + 1),
          );
        }),
      ],
    );
  }

  // Display editable pace zones
  Widget _buildEditablePaceZones(BuildContext context, WidgetRef ref,
      AppLocalizations localizations, int criticalPace, int numZones) {
    final zoneData = _calculatePaceZones(criticalPace, numZones);

    return Column(
      children: [
        // This would normally be stateful with controllers for each zone
        ...zoneData.asMap().entries.map((entry) {
          final index = entry.key;
          final zoneInfo = entry.value;
          return _buildEditableZoneRow(
            context,
            ref,
            index + 1,
            zoneInfo['name'] as String,
            zoneInfo['range'] as String,
            _getPaceZoneColor(index + 1),
            (String name, String lowerBound, String upperBound) {
              // In a real implementation, this would update the zone values
              final range = '$lowerBound - $upperBound';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Updated Zone ${index + 1}: $name ($range)'),
                ),
              );
            },
          );
        }),

        const SizedBox(height: 16),

        // Note about editing zones
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber, width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Manual zone configuration allows you to customize your pace zones based on your specific training needs and goals.',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Builder for a zone row (non-editable)
  Widget _buildZoneRow(
    BuildContext context,
    int zoneNumber,
    String zoneName,
    String zoneRange,
    Color zoneColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
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
      ),
    );
  }

  // Builder for an editable zone row
  Widget _buildEditableZoneRow(
    BuildContext context,
    WidgetRef ref,
    int zoneNumber,
    String zoneName,
    String zoneRange,
    Color zoneColor,
    Function(String, String, String) onSave,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        zoneName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 16),
                      onPressed: () {
                        _editPaceZone(context, zoneName, zoneRange, onSave);
                      },
                    ),
                  ],
                ),
                Text(
                  zoneRange,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Edit pace zone dialog
  void _editPaceZone(BuildContext context, String currentName,
      String currentRange, Function(String, String, String) onSave) {
    final nameController = TextEditingController(text: currentName);

    // Extract pace ranges - this is more complex for pace since it involves time formatting
    final rangeParts = currentRange.split('-').map((s) => s.trim()).toList();
    String lowerBound = rangeParts.isNotEmpty ? rangeParts[0] : '';
    String upperBound = rangeParts.length > 1 ? rangeParts[1] : '';

    // Remove "min/km" from bounds if present
    lowerBound = lowerBound.replaceAll('min/km', '').trim();
    upperBound = upperBound.replaceAll('min/km', '').trim();

    // Handle special cases like "5:00+" or "< 3:45"
    if (lowerBound.contains('+')) {
      lowerBound = lowerBound.replaceAll('+', '').trim();
      upperBound = ''; // No upper bound for "+" ranges
    } else if (lowerBound.contains('<')) {
      upperBound = lowerBound.replaceAll('<', '').trim();
      lowerBound = ''; // No lower bound for "<" ranges
    }

    final lowerBoundController = TextEditingController(text: lowerBound);
    final upperBoundController = TextEditingController(text: upperBound);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Pace Zone'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Zone Name',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: lowerBoundController,
                    decoration: const InputDecoration(
                      labelText: 'Lower Bound (mm:ss)',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('to'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: upperBoundController,
                    decoration: const InputDecoration(
                      labelText: 'Upper Bound (mm:ss)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'For ranges like "5:00+" use only Lower Bound and for "< 3:45" use only Upper Bound',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  (lowerBoundController.text.isNotEmpty ||
                      upperBoundController.text.isNotEmpty)) {
                onSave(
                  nameController.text,
                  lowerBoundController.text,
                  upperBoundController.text,
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Calculate Pace Zones based on Critical Pace
  List<Map<String, dynamic>> _calculatePaceZones(
      int criticalPaceSeconds, int numZones) {
    // For pace, lower is faster (unlike power and HR where higher is more intense)
    // So we multiply by factors > 1 for easier paces and < 1 for faster paces
    switch (numZones) {
      case 3:
        return [
          {
            'name': 'Easy',
            'range': '${_formatPace((criticalPaceSeconds * 1.15).round())}+',
          },
          {
            'name': 'Moderate',
            'range':
                '${_formatPace((criticalPaceSeconds * 0.95).round())} - ${_formatPace((criticalPaceSeconds * 1.15).round())}',
          },
          {
            'name': 'Hard',
            'range': '< ${_formatPace((criticalPaceSeconds * 0.95).round())}',
          },
        ];
      case 4:
        return [
          {
            'name': 'Recovery',
            'range': '${_formatPace((criticalPaceSeconds * 1.25).round())}+',
          },
          {
            'name': 'Endurance',
            'range':
                '${_formatPace((criticalPaceSeconds * 1.05).round())} - ${_formatPace((criticalPaceSeconds * 1.25).round())}',
          },
          {
            'name': 'Tempo',
            'range':
                '${_formatPace((criticalPaceSeconds * 0.9).round())} - ${_formatPace((criticalPaceSeconds * 1.05).round())}',
          },
          {
            'name': 'Interval',
            'range': '< ${_formatPace((criticalPaceSeconds * 0.9).round())}',
          },
        ];
      case 5:
        return [
          {
            'name': 'Recovery',
            'range': '${_formatPace((criticalPaceSeconds * 1.3).round())}+',
          },
          {
            'name': 'Easy',
            'range':
                '${_formatPace((criticalPaceSeconds * 1.15).round())} - ${_formatPace((criticalPaceSeconds * 1.3).round())}',
          },
          {
            'name': 'Moderate',
            'range':
                '${_formatPace((criticalPaceSeconds * 1.0).round())} - ${_formatPace((criticalPaceSeconds * 1.15).round())}',
          },
          {
            'name': 'Threshold',
            'range':
                '${_formatPace((criticalPaceSeconds * 0.9).round())} - ${_formatPace((criticalPaceSeconds * 1.0).round())}',
          },
          {
            'name': 'Interval',
            'range': '< ${_formatPace((criticalPaceSeconds * 0.9).round())}',
          },
        ];
      case 6:
        return [
          {
            'name': 'Recovery',
            'range': '${_formatPace((criticalPaceSeconds * 1.3).round())}+',
          },
          {
            'name': 'Easy',
            'range':
                '${_formatPace((criticalPaceSeconds * 1.15).round())} - ${_formatPace((criticalPaceSeconds * 1.3).round())}',
          },
          {
            'name': 'Moderate',
            'range':
                '${_formatPace((criticalPaceSeconds * 1.05).round())} - ${_formatPace((criticalPaceSeconds * 1.15).round())}',
          },
          {
            'name': 'Threshold',
            'range':
                '${_formatPace((criticalPaceSeconds * 0.95).round())} - ${_formatPace((criticalPaceSeconds * 1.05).round())}',
          },
          {
            'name': 'Interval',
            'range':
                '${_formatPace((criticalPaceSeconds * 0.85).round())} - ${_formatPace((criticalPaceSeconds * 0.95).round())}',
          },
          {
            'name': 'Sprint',
            'range': '< ${_formatPace((criticalPaceSeconds * 0.85).round())}',
          },
        ];
      case 7:
        return [
          {
            'name': 'Recovery',
            'range': '${_formatPace((criticalPaceSeconds * 1.4).round())}+',
          },
          {
            'name': 'Easy',
            'range':
                '${_formatPace((criticalPaceSeconds * 1.2).round())} - ${_formatPace((criticalPaceSeconds * 1.4).round())}',
          },
          {
            'name': 'Endurance',
            'range':
                '${_formatPace((criticalPaceSeconds * 1.1).round())} - ${_formatPace((criticalPaceSeconds * 1.2).round())}',
          },
          {
            'name': 'Tempo',
            'range':
                '${_formatPace((criticalPaceSeconds * 1.0).round())} - ${_formatPace((criticalPaceSeconds * 1.1).round())}',
          },
          {
            'name': 'Threshold',
            'range':
                '${_formatPace((criticalPaceSeconds * 0.9).round())} - ${_formatPace((criticalPaceSeconds * 1.0).round())}',
          },
          {
            'name': 'Interval',
            'range':
                '${_formatPace((criticalPaceSeconds * 0.8).round())} - ${_formatPace((criticalPaceSeconds * 0.9).round())}',
          },
          {
            'name': 'Sprint',
            'range': '< ${_formatPace((criticalPaceSeconds * 0.8).round())}',
          },
        ];
      default: // Default to 5 zones
        return [
          {
            'name': 'Recovery',
            'range': '${_formatPace((criticalPaceSeconds * 1.3).round())}+',
          },
          {
            'name': 'Easy',
            'range':
                '${_formatPace((criticalPaceSeconds * 1.15).round())} - ${_formatPace((criticalPaceSeconds * 1.3).round())}',
          },
          {
            'name': 'Moderate',
            'range':
                '${_formatPace((criticalPaceSeconds * 1.0).round())} - ${_formatPace((criticalPaceSeconds * 1.15).round())}',
          },
          {
            'name': 'Threshold',
            'range':
                '${_formatPace((criticalPaceSeconds * 0.9).round())} - ${_formatPace((criticalPaceSeconds * 1.0).round())}',
          },
          {
            'name': 'Interval',
            'range': '< ${_formatPace((criticalPaceSeconds * 0.9).round())}',
          },
        ];
    }
  }

  // Get color for pace zone
  Color _getPaceZoneColor(int zone) {
    // Color scheme for Pace zones - using a blend of blues and greens
    final zoneColors = [
      Colors.blue[300]!,
      Colors.teal[300]!,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
    ];

    // Make sure we don't go out of bounds
    if (zone > 0 && zone <= zoneColors.length) {
      return zoneColors[zone - 1];
    }

    return Colors.grey;
  }
}
