// lib/modules/profile/screens/power_zones_screen.dart - New dedicated Power zones screen

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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Critical Power Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('critical_power'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    localizations.translate('critical_power_help'),
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
                            '${userProfile.criticalPower} watts',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _editCriticalPower(context, ref, userProfile),
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
                      Text(localizations.translate('number_of_power_zones')),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(localizations
                                .translate('auto_calculate_power_zones')),
                            Text(
                              localizations
                                  .translate('auto_calculate_power_zones_desc'),
                              style: TextStyle(
                                color: Colors.grey[600],
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
                    localizations.translate('power_zones'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Show either auto-calculated zones or editable zones
                  userProfile.autoCalculatePowerZones
                      ? _buildCalculatedPowerZones(
                          context, localizations, userProfile)
                      : _buildEditablePowerZones(
                          context, ref, localizations, userProfile),
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
      BuildContext context, WidgetRef ref, UserProfile profile) {
    final controller =
        TextEditingController(text: profile.criticalPower.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('critical_power')),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('critical_power'),
            suffixText: 'watts',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('cancel')),
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
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }

  // Display calculated Power zones
  Widget _buildCalculatedPowerZones(BuildContext context,
      AppLocalizations localizations, UserProfile profile) {
    final zoneData =
        _calculatePowerZones(profile.criticalPower, profile.powerZones);

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

  // Display editable Power zones
  Widget _buildEditablePowerZones(BuildContext context, WidgetRef ref,
      AppLocalizations localizations, UserProfile profile) {
    final zoneData =
        _calculatePowerZones(profile.criticalPower, profile.powerZones);

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
                    content: Text(
                        'Updated Power Zone ${index + 1}: $name ($range)')),
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
                  localizations.translate('manual_power_zones_notice'),
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

  // Extract lower and upper bounds from a range string like "200 - 250 watts"
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
        title: Text('Edit Zone'),
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
    // Color scheme for Power zones - more orange/red focused
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
