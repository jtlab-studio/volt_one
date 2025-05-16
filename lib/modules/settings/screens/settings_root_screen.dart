// lib/modules/settings/screens/settings_root_screen.dart - Fixed type conversion issues

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../responsive/screen_type.dart';
import '../settings_module.dart';
import 'volt_settings_screen.dart';
import 'user_info_screen.dart';
import 'activity_alerts_screen.dart';
import 'sensors_screen.dart';
import 'subscription_screen.dart';
import 'training_zones_screen.dart';
import '../../../shared/widgets/global_app_bar.dart'; // Import the global app bar

class SettingsRootScreen extends ConsumerWidget {
  const SettingsRootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final selectedSection = ref.watch(settingsSectionProvider);
    final screenType = getScreenType(context);

    return Scaffold(
      // Use our GlobalAppBar with the cog icon
      appBar: GlobalAppBar(
        title: _getSettingsTitle(selectedSection, localizations),
        // No back button but we'll have the drawer for settings
        automaticallyImplyLeading: true,
      ),

      // Use a Row for desktop/tablet layout with a sidebar, single content for mobile
      body: screenType == ScreenType.mobile
          ? _getSettingsContent(selectedSection)
          : Row(
              children: [
                // Settings navigation menu (left side) - visible on tablet/desktop
                Container(
                  width: 240,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: _buildSettingsOptions(
                      context, ref, selectedSection, localizations),
                ),

                // Settings content area
                Expanded(
                  child: _getSettingsContent(selectedSection),
                ),
              ],
            ),
      // Don't add a bottom navigation bar - we're using the global one
    );
  }

  // Build the list of settings options
  Widget _buildSettingsOptions(
    BuildContext context,
    WidgetRef ref,
    String selectedSection,
    AppLocalizations localizations,
  ) {
    return ListView(
      children: [
        _buildSettingTile(
          context,
          ref,
          'volt_settings',
          localizations.translate('volt_settings'),
          Icons.settings,
          selectedSection == 'volt_settings',
        ),
        _buildSettingTile(
          context,
          ref,
          'user_info',
          localizations.translate('user_info'),
          Icons.person,
          selectedSection == 'user_info',
        ),
        _buildSettingTile(
          context,
          ref,
          'training_zones',
          localizations.translate('training_zones'),
          Icons.favorite,
          selectedSection == 'training_zones',
        ),
        _buildSettingTile(
          context,
          ref,
          'activity_alerts',
          localizations.translate('activity_alerts'),
          Icons.notifications_active,
          selectedSection == 'activity_alerts',
        ),
        _buildSettingTile(
          context,
          ref,
          'sensors',
          localizations.translate('sensors'),
          Icons.bluetooth,
          selectedSection == 'sensors',
        ),
        _buildSettingTile(
          context,
          ref,
          'subscription',
          localizations.translate('subscription'),
          Icons.card_membership,
          selectedSection == 'subscription',
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    WidgetRef ref,
    String sectionId,
    String title,
    IconData icon,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.primaryColor : null;

    // Use RGBA for background color when selected to avoid withOpacity deprecation
    final backgroundColor = isSelected
        ? Color.fromRGBO(theme.primaryColor.r.toInt(),
            theme.primaryColor.g.toInt(), theme.primaryColor.b.toInt(), 0.1)
        : Colors.transparent;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
      selected: isSelected,
      selectedTileColor: backgroundColor,
      onTap: () {
        // Set the selected section
        ref.read(settingsSectionProvider.notifier).state = sectionId;
      },
    );
  }

  Widget _getSettingsContent(String section) {
    switch (section) {
      case 'volt_settings':
        return const VoltSettingsScreen();
      case 'user_info':
        return const UserInfoScreen();
      case 'training_zones':
        return const TrainingZonesScreen();
      case 'activity_alerts':
        return const ActivityAlertsScreen();
      case 'sensors':
        return const SensorsScreen();
      case 'subscription':
        return const SubscriptionScreen();
      default:
        return const VoltSettingsScreen();
    }
  }

  String _getSettingsTitle(String section, AppLocalizations localizations) {
    switch (section) {
      case 'volt_settings':
        return localizations.translate('volt_settings');
      case 'user_info':
        return localizations.translate('user_info');
      case 'training_zones':
        return localizations.translate('training_zones');
      case 'activity_alerts':
        return localizations.translate('activity_alerts');
      case 'sensors':
        return localizations.translate('sensors');
      case 'subscription':
        return localizations.translate('subscription');
      default:
        return localizations.translate('settings');
    }
  }
}
