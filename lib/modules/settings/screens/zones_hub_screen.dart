// lib/modules/settings/screens/zones_hub_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import 'hr_zones_screen.dart';
import 'power_zones_screen.dart';
import 'pace_zones_screen.dart';

// Provider for tracking which zones tab is active
final zoneTabTypeProvider = StateProvider<String>((ref) => 'hr');

class ZonesHubScreen extends ConsumerWidget {
  const ZonesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final zoneTabType = ref.watch(zoneTabTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('training_zones')),
      ),
      body: Column(
        children: [
          // Tab selector for HR, Power, and Pace zones
          _buildZoneTypeTabs(context, ref, zoneTabType, localizations),

          // Zone content based on selected tab
          Expanded(
            child: _getZoneContent(zoneTabType),
          ),
        ],
      ),
    );
  }

  // Build tab bar for selecting zone type
  Widget _buildZoneTypeTabs(
      BuildContext context, 
      WidgetRef ref,
      String currentTab, 
      AppLocalizations localizations) {
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
              Colors.red,
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
              Colors.orange,
            ),
          ),
          Expanded(
            child: _buildZoneTypeTab(
              context,
              ref,
              'pace',
              localizations.translate('pace_zones'),
              Icons.speed,
              currentTab == 'pace',
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  // Individual tab widget
  Widget _buildZoneTypeTab(
      BuildContext context, 
      WidgetRef ref, 
      String tabId,
      String label, 
      IconData icon, 
      bool isSelected,
      Color iconColor) {
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
            Icon(icon, 
                 color: isSelected ? iconColor : Colors.grey, 
                 size: 16),
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

  // Return the content based on selected tab
  Widget _getZoneContent(String zoneType) {
    switch (zoneType) {
      case 'hr':
        return const HRZonesScreen();
      case 'power':
        return const PowerZonesScreen();
      case 'pace':
        return const PaceZonesScreen();
      default:
        return const HRZonesScreen();
    }
  }
}
