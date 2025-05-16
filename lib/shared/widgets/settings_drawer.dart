import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import '../../modules/settings/settings_module.dart';
// Removed unused import for settings_root_screen.dart

// Create a provider to manage the settings drawer state if needed
final settingsDrawerOpenProvider = StateProvider<bool>((ref) => false);

class SettingsDrawer extends ConsumerWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Drawer(
      width: 280, // Slightly narrower than default for a cleaner look
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header with styling
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // Fixed: Converting Color values to int (from double)
                color: Color.fromRGBO(
                    theme.primaryColor.r.toInt(),
                    theme.primaryColor.g.toInt(),
                    theme.primaryColor.b.toInt(),
                    0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    localizations.translate('settings'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // Close drawer
                      Navigator.pop(context);
                    },
                    tooltip: localizations.translate('close'),
                  ),
                ],
              ),
            ),

            // Settings options
            Expanded(
              child: _buildSettingsOptions(context, ref, localizations),
            ),

            // Version info at bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Volt v1.0.0',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOptions(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    return ListView(
      children: [
        _buildSettingTile(
          context,
          ref,
          'volt_settings',
          localizations.translate('volt_settings'),
          Icons.tune,
        ),
        _buildSettingTile(
          context,
          ref,
          'user_info',
          localizations.translate('user_info'),
          Icons.person,
        ),
        _buildSettingTile(
          context,
          ref,
          'training_zones',
          localizations.translate('training_zones'),
          Icons.favorite,
        ),
        _buildSettingTile(
          context,
          ref,
          'activity_alerts',
          localizations.translate('activity_alerts'),
          Icons.notifications_active,
        ),
        _buildSettingTile(
          context,
          ref,
          'sensors',
          localizations.translate('sensors'),
          Icons.bluetooth,
        ),
        _buildSettingTile(
          context,
          ref,
          'subscription',
          localizations.translate('subscription'),
          Icons.card_membership,
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
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Set the selected section
        ref.read(settingsSectionProvider.notifier).state = sectionId;

        // Close the drawer
        Navigator.pop(context);

        // Navigate to settings screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SettingsModule.createRootScreen(),
          ),
        );
      },
    );
  }
}
