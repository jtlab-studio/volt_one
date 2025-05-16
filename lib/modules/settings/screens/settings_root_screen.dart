import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../settings_module.dart';
import 'volt_settings_screen.dart';
import 'user_info_screen.dart';
import 'activity_alerts_screen.dart';
import 'sensors_screen.dart';
import 'subscription_screen.dart';

class SettingsRootScreen extends ConsumerWidget {
  const SettingsRootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final selectedSection = ref.watch(settingsSectionProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('settings')),
        // We want back button to return to main app
        automaticallyImplyLeading: true,
        // No need for actions in the settings screens
        actions: const [],
      ),
      body: SafeArea(
        child: isTablet
            ? Row(
                children: [
                  // Settings navigation menu (left side) - Only on tablets
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
                    child: ListView(
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
                    ),
                  ),

                  // Settings content (right side)
                  Expanded(
                    child: _getSettingsContent(selectedSection),
                  ),
                ],
              )
            : _getSettingsContent(
                selectedSection), // Full-screen content on phones
      ),
      // Only show bottom navigation on phones, not on tablets
      bottomNavigationBar: isTablet
          ? null
          : _buildBottomNavigation(
              context, ref, selectedSection, localizations),
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

    // Create a transparent color by default
    final Color transparentColor = Colors.transparent;

    // Using a safe approach for setting background color when selected
    final Color? bgColor =
        isSelected ? theme.primaryColor.withOpacity(0.1) : transparentColor;

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
      selectedTileColor: bgColor,
      onTap: () {
        ref.read(settingsSectionProvider.notifier).state = sectionId;
      },
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context,
    WidgetRef ref,
    String currentSection,
    AppLocalizations localizations,
  ) {
    return BottomNavigationBar(
      currentIndex: _getNavIndex(currentSection),
      onTap: (index) {
        final sections = [
          'volt_settings',
          'user_info',
          'activity_alerts',
          'sensors',
          'subscription',
        ];
        // Make sure we don't go out of bounds
        if (index < sections.length) {
          ref.read(settingsSectionProvider.notifier).state = sections[index];
        }
      },
      type: BottomNavigationBarType.fixed, // Important for more than 3 items
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: localizations.translate('volt_settings'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: localizations.translate('user_info'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.notifications_active),
          label: localizations.translate('activity_alerts'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bluetooth),
          label: localizations.translate('sensors'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.card_membership),
          label: localizations.translate('subscription'),
        ),
      ],
    );
  }

  Widget _getSettingsContent(String section) {
    switch (section) {
      case 'volt_settings':
        return const VoltSettingsScreen();
      case 'user_info':
        return const UserInfoScreen();
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

  int _getNavIndex(String section) {
    switch (section) {
      case 'volt_settings':
        return 0;
      case 'user_info':
        return 1;
      case 'activity_alerts':
        return 2;
      case 'sensors':
        return 3;
      case 'subscription':
        return 4;
      default:
        return 0;
    }
  }
}
