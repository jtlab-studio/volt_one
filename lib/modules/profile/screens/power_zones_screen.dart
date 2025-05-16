// lib/modules/profile/screens/power_zones_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../providers/user_profile_provider.dart';

/// Screen for managing Power training zones
class PowerZonesScreen extends ConsumerWidget {
  const PowerZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);

    // Default critical power if not set in profile
    final criticalPower = userProfile.criticalPower;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add large icon at the top
          const Icon(
            Icons.flash_on,
            size: 80,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          Text(
            'Power Zones',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          // Critical Power Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Critical Power',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Critical power is the highest sustainable power output you can maintain for approximately 1 hour of running.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Critical Power value display and edit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flash_on, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            '$criticalPower watts',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _editCriticalPower(context, ref, criticalPower),
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
                      const Text('Number of Power Zones'),
                      DropdownButton<int>(
                        value: userProfile.powerZones,
                        items: [3, 4, 5, 6, 7].map((zoneCount) {
                          return DropdownMenuItem<int>(
                            value: zoneCount,
                            child: Text(zoneCount.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(userProfileProvider.notifier).update(
                                  (state) => state.copyWith(powerZones: value),
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
                            Text('Auto-calculate Power Zones'),
                            Text(
                              'Automatically calculate zones based on your critical power',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: userProfile.autoCalculatePowerZones,
                        onChanged: (value) {
                          ref.read(userProfileProvider.notifier).update(
                                (state) => state.copyWith(
                                    autoCalculatePowerZones: value),
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

          // Power Zones Display
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Power Zones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Show either auto-calculated zones or editable zones
                  userProfile.autoCalculatePowerZones
                      ? _buildCalculatedPowerZones(context, localizations,
                          criticalPower, userProfile.powerZones)
                      : _buildEditablePowerZones(context, ref, localizations,
                          criticalPower, userProfile.powerZones),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Information about power zones
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Power Zones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Critical Power explanation
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.orange.withAlpha(120), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What is Critical Power?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Critical Power (CP) represents the highest power output a runner can maintain for an extended period (approximately 30-60 minutes) without fatigue. It marks the boundary between sustainable aerobic effort and unsustainable anaerobic work. CP is a fundamental physiological marker used to personalize your power training zones, ensuring each zone targets specific adaptations based on your individual capabilities. CP can be determined through structured field tests or derived from recent race performances.',
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
                    'Power zones provide an objective way to measure and structure your running intensity, independent of environmental factors.\n\n'
                    'Zone 1 (Recovery): Very easy, promotes recovery without fatigue.\n'
                    'Zone 2 (Endurance): Aerobic base building, fat metabolism, improves capillary density.\n'
                    'Zone 3 (Tempo): Moderate intensity, improves aerobic capacity.\n'
                    'Zone 4 (Threshold): High intensity but sustainable, improves lactate threshold.\n'
                    'Zone 5 (VO2max): Very high intensity, improves maximal oxygen uptake.\n'
                    'Zone 6+ (Anaerobic): Short burst, develops anaerobic capacity and neuromuscular power.',
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
                            'Power is the most reliable metric for running intensity, as it\'s not affected by external conditions like weather or terrain.',
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

  // Edit Critical Power dialog
  void _editCriticalPower(
      BuildContext context, WidgetRef ref, int currentPower) {
    final controller = TextEditingController(text: currentPower.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Critical Power'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Critical Power',
            suffixText: 'watts',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
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
              final cp = int.tryParse(controller.text);
              if (cp != null && cp > 0) {
                ref.read(userProfileProvider.notifier).update(
                      (state) => state.copyWith(criticalPower: cp),
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

  // Display calculated power zones
  Widget _buildCalculatedPowerZones(BuildContext context,
      AppLocalizations localizations, int cp, int numZones) {
    final zoneData = _calculatePowerZones(cp, numZones);

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
            _getPowerZoneColor(index + 1),
          );
        }),
      ],
    );
  }

  // Display editable power zones
  Widget _buildEditablePowerZones(BuildContext context, WidgetRef ref,
      AppLocalizations localizations, int cp, int numZones) {
    final zoneData = _calculatePowerZones(cp, numZones);

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
            _getPowerZoneColor(index + 1),
            (String name, String lowerBound, String upperBound) {
              // In a real implementation, this would update the zone values
              // But for this example, we'll just show a snackbar
              final range = '$lowerBound - $upperBound watts';
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
                  'Manual zone configuration allows you to customize based on your specific running strengths and training objectives.',
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
                        _editZone(context, zoneName, zoneRange, onSave);
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

  // Extract lower and upper bounds from a range string like "120 - 150 watts"
  List<String> _extractRangeBounds(String rangeString) {
    // Remove units and extract just the numbers
    final rangeOnly = rangeString.replaceAll(RegExp(r'[a-zA-Z]'), '').trim();
    final parts = rangeOnly.split('-').map((s) => s.trim()).toList();

    if (parts.length == 2) {
      return parts;
    }
    // Default values if parsing fails
    return ['0', '0'];
  }

  // Edit zone dialog
  void _editZone(BuildContext context, String currentName, String currentRange,
      Function(String, String, String) onSave) {
    final nameController = TextEditingController(text: currentName);

    // Extract lower and upper bounds from the range string
    final bounds = _extractRangeBounds(currentRange);
    final lowerBoundController = TextEditingController(text: bounds[0]);
    final upperBoundController = TextEditingController(text: bounds[1]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Power Zone'),
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
                      labelText: 'Lower Bound',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('to'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: upperBoundController,
                    decoration: const InputDecoration(
                      labelText: 'Upper Bound',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
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
              if (nameController.text.isNotEmpty &&
                  lowerBoundController.text.isNotEmpty &&
                  upperBoundController.text.isNotEmpty) {
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

  // Calculate Power Zones based on Critical Power
  List<Map<String, dynamic>> _calculatePowerZones(int cp, int numZones) {
    switch (numZones) {
      case 3:
        return [
          {'name': 'Easy', 'range': '0 - ${(cp * 0.75).round()} watts'},
          {
            'name': 'Moderate',
            'range': '${(cp * 0.75).round() + 1} - ${(cp * 0.9).round()} watts'
          },
          {
            'name': 'Hard',
            'range': '${(cp * 0.9).round() + 1} - ${(cp * 1.1).round()} watts'
          },
        ];
      case 4:
        return [
          {'name': 'Recovery', 'range': '0 - ${(cp * 0.65).round()} watts'},
          {
            'name': 'Endurance',
            'range': '${(cp * 0.65).round() + 1} - ${(cp * 0.8).round()} watts'
          },
          {
            'name': 'Tempo',
            'range': '${(cp * 0.8).round() + 1} - ${(cp * 0.95).round()} watts'
          },
          {
            'name': 'Threshold',
            'range': '${(cp * 0.95).round() + 1} - ${(cp * 1.1).round()} watts'
          },
        ];
      case 5:
        return [
          {'name': 'Recovery', 'range': '0 - ${(cp * 0.65).round()} watts'},
          {
            'name': 'Endurance',
            'range': '${(cp * 0.65).round() + 1} - ${(cp * 0.8).round()} watts'
          },
          {
            'name': 'Tempo',
            'range': '${(cp * 0.8).round() + 1} - ${(cp * 0.95).round()} watts'
          },
          {
            'name': 'Threshold',
            'range': '${(cp * 0.95).round() + 1} - ${(cp * 1.05).round()} watts'
          },
          {
            'name': 'Anaerobic',
            'range': '${(cp * 1.05).round() + 1} - ${(cp * 1.2).round()} watts'
          },
        ];
      case 6:
        return [
          {'name': 'Recovery', 'range': '0 - ${(cp * 0.55).round()} watts'},
          {
            'name': 'Endurance',
            'range': '${(cp * 0.55).round() + 1} - ${(cp * 0.75).round()} watts'
          },
          {
            'name': 'Tempo',
            'range': '${(cp * 0.75).round() + 1} - ${(cp * 0.9).round()} watts'
          },
          {
            'name': 'Threshold',
            'range': '${(cp * 0.9).round() + 1} - ${(cp * 1.0).round()} watts'
          },
          {
            'name': 'VO2 Max',
            'range': '${(cp * 1.0).round() + 1} - ${(cp * 1.1).round()} watts'
          },
          {
            'name': 'Anaerobic',
            'range': '${(cp * 1.1).round() + 1} - ${(cp * 1.3).round()} watts'
          },
        ];
      case 7:
        return [
          {'name': 'Recovery', 'range': '0 - ${(cp * 0.5).round()} watts'},
          {
            'name': 'Endurance',
            'range': '${(cp * 0.5).round() + 1} - ${(cp * 0.65).round()} watts'
          },
          {
            'name': 'Tempo',
            'range': '${(cp * 0.65).round() + 1} - ${(cp * 0.8).round()} watts'
          },
          {
            'name': 'Cruise',
            'range': '${(cp * 0.8).round() + 1} - ${(cp * 0.9).round()} watts'
          },
          {
            'name': 'Threshold',
            'range': '${(cp * 0.9).round() + 1} - ${(cp * 1.0).round()} watts'
          },
          {
            'name': 'VO2 Max',
            'range': '${(cp * 1.0).round() + 1} - ${(cp * 1.15).round()} watts'
          },
          {
            'name': 'Anaerobic',
            'range': '${(cp * 1.15).round() + 1} - ${(cp * 1.4).round()} watts'
          },
        ];
      default:
        return [
          {'name': 'Recovery', 'range': '0 - ${(cp * 0.65).round()} watts'},
          {
            'name': 'Endurance',
            'range': '${(cp * 0.65).round() + 1} - ${(cp * 0.8).round()} watts'
          },
          {
            'name': 'Tempo',
            'range': '${(cp * 0.8).round() + 1} - ${(cp * 0.9).round()} watts'
          },
          {
            'name': 'Threshold',
            'range': '${(cp * 0.9).round() + 1} - ${(cp * 1.0).round()} watts'
          },
          {
            'name': 'VO2 Max',
            'range': '${(cp * 1.0).round() + 1} - ${(cp * 1.2).round()} watts'
          },
        ];
    }
  }

  // Get color for Power zone
  Color _getPowerZoneColor(int zone) {
    // Color scheme for Power zones
    final zoneColors = [
      Colors.blue[300]!,
      Colors.teal,
      Colors.green,
      Colors.lime,
      Colors.orange,
      Colors.deepOrange,
      Colors.red,
    ];

    // Make sure we don't go out of bounds
    if (zone > 0 && zone <= zoneColors.length) {
      return zoneColors[zone - 1];
    }

    return Colors.grey;
  }
}
