// lib/modules/settings/screens/training_zones_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../responsive/screen_type.dart';
import 'hr_zones_screen.dart';
import 'power_zones_screen.dart';

// Provider for tracking which zones tab is active
final zoneTabTypeProvider = StateProvider<String>((ref) => 'hr');

class TrainingZonesScreen extends ConsumerWidget {
  const TrainingZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final zoneTabType = ref.watch(zoneTabTypeProvider);
    final screenType = getScreenType(context);

    return _buildResponsiveLayout(
        context, ref, zoneTabType, localizations, screenType);
  }

  Widget _buildResponsiveLayout(
    BuildContext context,
    WidgetRef ref,
    String currentTab,
    AppLocalizations localizations,
    ScreenType screenType,
  ) {
    // Desktop/Tablet layout with side tabs
    if (screenType == ScreenType.desktop || screenType == ScreenType.tablet) {
      return Row(
        children: [
          // Side tabs for larger screens
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              children: [
                _buildSideTab(
                  context,
                  ref,
                  'hr',
                  localizations.translate('heart_rate_zones'),
                  Icons.favorite,
                  currentTab == 'hr',
                  Colors.red,
                ),
                _buildSideTab(
                  context,
                  ref,
                  'power',
                  localizations.translate('power_zones'),
                  Icons.flash_on,
                  currentTab == 'power',
                  Colors.orange,
                ),
              ],
            ),
          ),

          // Zone content based on selected tab
          Expanded(
            child: _getZoneContent(currentTab),
          ),
        ],
      );
    } else {
      // Mobile layout with top tabs
      return Column(
        children: [
          // Tab selector for HR and Power zones
          _buildZoneTypeTabs(context, ref, currentTab, localizations),

          // Zone content based on selected tab
          Expanded(
            child: _getZoneContent(currentTab),
          ),
        ],
      );
    }
  }

  // Build side tab for desktop/tablet layout
  Widget _buildSideTab(
    BuildContext context,
    WidgetRef ref,
    String tabId,
    String label,
    IconData icon,
    bool isSelected,
    Color iconColor,
  ) {
    // Create a safe color for background when selected
    final Color bgColor = isSelected
        ? Theme.of(context).primaryColor.withAlpha(20)
        : Colors.transparent;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? iconColor : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: bgColor,
      onTap: () {
        ref.read(zoneTabTypeProvider.notifier).state = tabId;
      },
    );
  }

  // Build top tabs for mobile layout
  Widget _buildZoneTypeTabs(
    BuildContext context,
    WidgetRef ref,
    String currentTab,
    AppLocalizations localizations,
  ) {
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
        ],
      ),
    );
  }

  // Individual tab widget for mobile layout
  Widget _buildZoneTypeTab(
    BuildContext context,
    WidgetRef ref,
    String tabId,
    String label,
    IconData icon,
    bool isSelected,
    Color iconColor,
  ) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? iconColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
      default:
        return const HRZonesScreen();
    }
  }
}
