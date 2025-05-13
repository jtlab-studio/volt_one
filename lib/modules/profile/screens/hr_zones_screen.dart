// lib/modules/profile/screens/hr_zones_screen.dart - New dedicated HR zones screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../providers/user_profile_provider.dart';

/// Screen for managing Heart Rate training zones
class HRZonesScreen extends ConsumerWidget {
  const HRZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LTHR Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('lthr'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    localizations.translate('lthr_help'),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // LTHR value display and edit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            '${userProfile.lthr} bpm',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => _editLthr(context, ref, userProfile),
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
                      Text(localizations.translate('number_of_zones')),
                      DropdownButton<int>(
                        value: userProfile.numZones,
                        items: [3, 4, 5, 6, 7].map((zoneCount) {
                          return DropdownMenuItem<int>(
                            value: zoneCount,
                            child: Text(zoneCount.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(userProfileProvider.notifier).update(
                                  (state) => state.copyWith(numZones: value),
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
                                .translate('auto_calculate_zones')),
                            Text(
                              localizations
                                  .translate('auto_calculate_zones_desc'),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: userProfile.autoCalculateZones,
                        onChanged: (value) {
                          ref.read(userProfileProvider.notifier).update(
                                (state) =>
                                    state.copyWith(autoCalculateZones: value),
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

          // Heart Rate Zones Display
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('heart_rate_zones'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Show either auto-calculated zones or editable zones
                  userProfile.autoCalculateZones
                      ? _buildCalculatedHRZones(
                          context, localizations, userProfile)
                      : _buildEditableHRZones(
                          context, ref, localizations, userProfile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Edit LTHR dialog
  void _editLthr(BuildContext context, WidgetRef ref, UserProfile profile) {
    final controller = TextEditingController(text: profile.lthr.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('lthr')),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('lthr'),
            suffixText: 'bpm',
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
              final lthr = int.tryParse(controller.text);
              if (lthr != null && lthr > 0) {
                ref.read(userProfileProvider.notifier).update(
                      (state) => state.copyWith(lthr: lthr),
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

  // Display calculated HR zones
  Widget _buildCalculatedHRZones(BuildContext context,
      AppLocalizations localizations, UserProfile profile) {
    final zoneData = _calculateHeartRateZones(profile.lthr, profile.numZones);

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
            _getZoneColor(index + 1),
          );
        }),
      ],
    );
  }

  // Display editable HR zones
  Widget _buildEditableHRZones(BuildContext context, WidgetRef ref,
      AppLocalizations localizations, UserProfile profile) {
    final zoneData = _calculateHeartRateZones(profile.lthr, profile.numZones);

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
            _getZoneColor(index + 1),
            (String name, String lowerBound, String upperBound) {
              // In a real implementation, this would update the zone values
              // But for this example, we'll just show a snackbar
              final range = '$lowerBound - $upperBound bpm';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Updated Zone ${index + 1}: $name ($range)')),
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
                  localizations.translate('manual_zones_notice'),
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

  // Extract lower and upper bounds from a range string like "120 - 150 bpm"
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

  // Calculate Heart Rate Zones based on LTHR
  List<Map<String, dynamic>> _calculateHeartRateZones(int lthr, int numZones) {
    switch (numZones) {
      case 3:
        return [
          {
            'name': 'Easy',
            'range': '${(lthr * 0.6).round()} - ${(lthr * 0.75).round()} bpm'
          },
          {
            'name': 'Moderate',
            'range':
                '${(lthr * 0.75).round() + 1} - ${(lthr * 0.9).round()} bpm'
          },
          {
            'name': 'Hard',
            'range':
                '${(lthr * 0.9).round() + 1} - ${(lthr * 1.05).round()} bpm'
          },
        ];
      case 4:
        return [
          {
            'name': 'Recovery',
            'range': '${(lthr * 0.6).round()} - ${(lthr * 0.7).round()} bpm'
          },
          {
            'name': 'Endurance',
            'range':
                '${(lthr * 0.7).round() + 1} - ${(lthr * 0.85).round()} bpm'
          },
          {
            'name': 'Tempo',
            'range':
                '${(lthr * 0.85).round() + 1} - ${(lthr * 0.95).round()} bpm'
          },
          {
            'name': 'Threshold+',
            'range':
                '${(lthr * 0.95).round() + 1} - ${(lthr * 1.05).round()} bpm'
          },
        ];
      case 5:
        return [
          {
            'name': 'Recovery',
            'range': '${(lthr * 0.6).round()} - ${(lthr * 0.7).round()} bpm'
          },
          {
            'name': 'Endurance',
            'range': '${(lthr * 0.7).round() + 1} - ${(lthr * 0.8).round()} bpm'
          },
          {
            'name': 'Tempo',
            'range': '${(lthr * 0.8).round() + 1} - ${(lthr * 0.9).round()} bpm'
          },
          {
            'name': 'Threshold',
            'range': '${(lthr * 0.9).round() + 1} - ${(lthr * 1.0).round()} bpm'
          },
          {
            'name': 'VO2 Max',
            'range': '${(lthr * 1.0).round() + 1} - ${(lthr * 1.1).round()} bpm'
          },
        ];
      case 6:
        return [
          {
            'name': 'Recovery',
            'range': '${(lthr * 0.6).round()} - ${(lthr * 0.67).round()} bpm'
          },
          {
            'name': 'Endurance',
            'range':
                '${(lthr * 0.67).round() + 1} - ${(lthr * 0.75).round()} bpm'
          },
          {
            'name': 'Tempo',
            'range':
                '${(lthr * 0.75).round() + 1} - ${(lthr * 0.85).round()} bpm'
          },
          {
            'name': 'SubThreshold',
            'range':
                '${(lthr * 0.85).round() + 1} - ${(lthr * 0.95).round()} bpm'
          },
          {
            'name': 'Threshold',
            'range':
                '${(lthr * 0.95).round() + 1} - ${(lthr * 1.03).round()} bpm'
          },
          {
            'name': 'VO2 Max',
            'range':
                '${(lthr * 1.03).round() + 1} - ${(lthr * 1.1).round()} bpm'
          },
        ];
      case 7:
        return [
          {
            'name': 'Recovery',
            'range': '${(lthr * 0.6).round()} - ${(lthr * 0.65).round()} bpm'
          },
          {
            'name': 'Easy',
            'range':
                '${(lthr * 0.65).round() + 1} - ${(lthr * 0.73).round()} bpm'
          },
          {
            'name': 'Endurance',
            'range':
                '${(lthr * 0.73).round() + 1} - ${(lthr * 0.8).round()} bpm'
          },
          {
            'name': 'Tempo',
            'range':
                '${(lthr * 0.8).round() + 1} - ${(lthr * 0.88).round()} bpm'
          },
          {
            'name': 'SubThreshold',
            'range':
                '${(lthr * 0.88).round() + 1} - ${(lthr * 0.95).round()} bpm'
          },
          {
            'name': 'Threshold',
            'range':
                '${(lthr * 0.95).round() + 1} - ${(lthr * 1.02).round()} bpm'
          },
          {
            'name': 'VO2 Max',
            'range':
                '${(lthr * 1.02).round() + 1} - ${(lthr * 1.1).round()} bpm'
          },
        ];
      default:
        return [
          {
            'name': 'Recovery',
            'range': '${(lthr * 0.6).round()} - ${(lthr * 0.7).round()} bpm'
          },
          {
            'name': 'Endurance',
            'range': '${(lthr * 0.7).round() + 1} - ${(lthr * 0.8).round()} bpm'
          },
          {
            'name': 'Tempo',
            'range': '${(lthr * 0.8).round() + 1} - ${(lthr * 0.9).round()} bpm'
          },
          {
            'name': 'Threshold',
            'range': '${(lthr * 0.9).round() + 1} - ${(lthr * 1.0).round()} bpm'
          },
          {
            'name': 'VO2 Max',
            'range': '${(lthr * 1.0).round() + 1} - ${(lthr * 1.1).round()} bpm'
          },
        ];
    }
  }

  // Get color for HR zone
  Color _getZoneColor(int zone) {
    // Color scheme for HR zones
    final zoneColors = [
      Colors.blue[300]!,
      Colors.blue,
      Colors.green,
      Colors.amber,
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
