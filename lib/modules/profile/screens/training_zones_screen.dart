import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../providers/user_profile_provider.dart';

// Provider for tracking which zones tab is active
final zoneTabTypeProvider = StateProvider<String>((ref) => 'hr');

class TrainingZonesScreen extends ConsumerWidget {
  const TrainingZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final zoneTabType = ref.watch(zoneTabTypeProvider);

    return Column(
      children: [
        // Tab selector for HR vs Power zones
        _buildZoneTypeTabs(context, ref, zoneTabType, localizations),

        // Zone content based on selected tab
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: zoneTabType == 'hr'
                ? _buildHeartRateZones(context, ref, localizations, userProfile)
                : _buildPowerZones(context, ref, localizations, userProfile),
          ),
        ),
      ],
    );
  }

  Widget _buildZoneTypeTabs(BuildContext context, WidgetRef ref,
      String currentTab, AppLocalizations localizations) {
    return Container(
      color: Theme.of(context).primaryColor.withAlpha(20),
      child: Row(
        children: [
          Expanded(
            child: _buildZoneTypeTab(
              context,
              ref,
              'hr',
              localizations.translate('heart_rate_zones'),
              Icons.favorite,
              currentTab == 'hr',
            ),
          ),
          Expanded(
            child: _buildZoneTypeTab(
              context,
              ref,
              'power',
              localizations.translate('power_zones'),
              Icons.flash_on,
              currentTab == 'power',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneTypeTab(BuildContext context, WidgetRef ref, String tabId,
      String label, IconData icon, bool isSelected) {
    final color = isSelected ? Theme.of(context).primaryColor : Colors.grey;

    return InkWell(
      onTap: () {
        ref.read(zoneTabTypeProvider.notifier).state = tabId;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartRateZones(BuildContext context, WidgetRef ref,
      AppLocalizations localizations, UserProfile profile) {
    return Column(
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
                          '${profile.lthr} bpm',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _editLthr(context, ref, profile),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
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
                      value: profile.numZones,
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
                          Text(localizations.translate('auto_calculate_zones')),
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
                      value: profile.autoCalculateZones,
                      onChanged: (value) {
                        ref.read(userProfileProvider.notifier).update(
                              (state) =>
                                  state.copyWith(autoCalculateZones: value),
                            );
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Heart Rate Zones Display or Editor
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
                profile.autoCalculateZones
                    ? _buildCalculatedHRZones(context, localizations, profile)
                    : _buildEditableHRZones(
                        context, ref, localizations, profile),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPowerZones(BuildContext context, WidgetRef ref,
      AppLocalizations localizations, UserProfile profile) {
    return Column(
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
                          '${profile.criticalPower} watts',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          _editCriticalPower(context, ref, profile),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
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
                      value: profile.powerZones,
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
                      value: profile.autoCalculatePowerZones,
                      onChanged: (value) {
                        ref.read(userProfileProvider.notifier).update(
                              (state) => state.copyWith(
                                  autoCalculatePowerZones: value),
                            );
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Power Zones Display or Editor
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
                profile.autoCalculatePowerZones
                    ? _buildCalculatedPowerZones(
                        context, localizations, profile)
                    : _buildEditablePowerZones(
                        context, ref, localizations, profile),
              ],
            ),
          ),
        ),
      ],
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

  // Extract lower and upper bounds from a range string like "120 - 150 bpm" or "200 - 250 watts"
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

  // Edit zone dialog with separate inputs for lower and upper bounds
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
