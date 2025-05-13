// lib/modules/profile/screens/app_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../shared/widgets/color_picker_dialog.dart';
import 'dart:io' show Platform;

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    // Using themeSettings variable now in the UI
    final isCupertino = Platform.isIOS;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAppSettingsSection(
            context, ref, localizations, themeMode, isCupertino),
        const SizedBox(height: 24),
        _buildThemeCustomizationSection(context, ref, localizations),
        const SizedBox(height: 24),
        _buildAboutSection(context, localizations, isCupertino),
      ],
    );
  }

  Widget _buildAppSettingsSection(BuildContext context, WidgetRef ref,
      AppLocalizations localizations, ThemeMode themeMode, bool isCupertino) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Theme toggle
        isCupertino
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(localizations.translate('dark_mode')),
                  CupertinoSwitch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      // Toggle theme
                      ref.read(themeModeProvider.notifier).state =
                          value ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ],
              )
            : SwitchListTile(
                title: Text(localizations.translate('dark_mode')),
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  // Toggle theme
                  ref.read(themeModeProvider.notifier).state =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              ),

        const SizedBox(height: 16),

        // Units toggle
        isCupertino
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localizations.translate('imperial_units')),
                      Text(
                        localizations.translate('imperial_units_desc'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: false, // Default to metric
                    onChanged: (value) {
                      // Toggle units
                    },
                  ),
                ],
              )
            : SwitchListTile(
                title: Text(localizations.translate('imperial_units')),
                subtitle: Text(localizations.translate('imperial_units_desc')),
                value: false, // Default to metric
                onChanged: (value) {
                  // Toggle units
                },
              ),

        const SizedBox(height: 16),

        // Language selector
        isCupertino
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(localizations.translate('language')),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      _showLanguageSelector(context, ref, localizations);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('English'), // Current language
                          const Icon(CupertinoIcons.chevron_down),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : ListTile(
                title: Text(localizations.translate('language')),
                subtitle: const Text('English'), // Current language
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showLanguageSelector(context, ref, localizations);
                },
              ),
      ],
    );

    // Wrap in appropriate container based on platform
    return isCupertino
        ? Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CupertinoColors.systemGrey5),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            child: content,
          )
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          );
  }

  Widget _buildThemeCustomizationSection(
      BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    final themeSettings = ref.watch(themeSettingsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Customization',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Primary Color Selector
            ListTile(
              title: const Text('Primary Color'),
              subtitle: const Text('Main accent color for the app'),
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: themeSettings.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              onTap: () => _showColorPicker(
                context: context,
                ref: ref,
                initialColor: themeSettings.primaryColor,
                title: 'Select Primary Color',
                onColorSelected: (color) {
                  ref
                      .read(themeSettingsProvider.notifier)
                      .updatePrimaryColor(color);
                },
              ),
            ),

            // Secondary Color Selector
            ListTile(
              title: const Text('Secondary Color'),
              subtitle: const Text('Complementary accent color'),
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: themeSettings.secondaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              onTap: () => _showColorPicker(
                context: context,
                ref: ref,
                initialColor: themeSettings.secondaryColor,
                title: 'Select Secondary Color',
                onColorSelected: (color) {
                  ref
                      .read(themeSettingsProvider.notifier)
                      .updateSecondaryColor(color);
                },
              ),
            ),

            // Material You Toggle
            SwitchListTile(
              title: const Text('Use Material You (Android 12+)'),
              subtitle: const Text('Use dynamic colors from your device theme'),
              value: themeSettings.useMaterialYou,
              onChanged: (value) {
                ref.read(themeSettingsProvider.notifier).toggleMaterialYou();
              },
            ),

            const Divider(),

            // Reset to Defaults Button
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reset to Default Colors'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                ),
                onPressed: () {
                  ref.read(themeSettingsProvider.notifier).resetToDefaults();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker({
    required BuildContext context,
    required WidgetRef ref,
    required Color initialColor,
    required String title,
    required Function(Color) onColorSelected,
  }) {
    showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(
        initialColor: initialColor,
        title: title,
        onColorSelected: onColorSelected,
      ),
    );
  }

  Widget _buildAboutSection(
      BuildContext context, AppLocalizations localizations, bool isCupertino) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('about'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildAboutTile(
            context, localizations.translate('version'), '1.0.0', null),
        _buildAboutTile(context, localizations.translate('terms_of_service'),
            '', () => _launchURL('https://example.com/terms')),
        _buildAboutTile(context, localizations.translate('privacy_policy'), '',
            () => _launchURL('https://example.com/privacy')),
        _buildAboutTile(context, localizations.translate('help_support'), '',
            () => _launchURL('https://example.com/support')),
      ],
    );

    // Wrap in appropriate container based on platform
    return isCupertino
        ? Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CupertinoColors.systemGrey5),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            child: content,
          )
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          );
  }

  Widget _buildAboutTile(BuildContext context, String title, String subtitle,
      VoidCallback? onTap) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.arrow_forward_ios) : null,
      onTap: onTap,
    );
  }

  void _showLanguageSelector(
      BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(localizations.translate('language')),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to English
                },
                child: const Text('English'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Spanish
                },
                child: const Text('Español'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Russian
                },
                child: const Text('Русский'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(localizations.translate('cancel')),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(localizations.translate('language')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English'),
                  onTap: () {
                    Navigator.pop(context);
                    // Set to English
                  },
                ),
                ListTile(
                  title: const Text('Español'),
                  onTap: () {
                    Navigator.pop(context);
                    // Set to Spanish
                  },
                ),
                ListTile(
                  title: const Text('Русский'),
                  onTap: () {
                    Navigator.pop(context);
                    // Set to Russian
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(localizations.translate('cancel')),
              ),
            ],
          );
        },
      );
    }
  }

  void _launchURL(String url) {
    // You would use url_launcher package to launch URLs
    // For now, we'll just do nothing
  }
}
