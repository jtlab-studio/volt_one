// lib/modules/profile/screens/app_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_provider.dart'; // Import the theme provider
import '../../../shared/widgets/color_picker_dialog.dart';
import 'dart:io' show Platform;

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final themeSettings = ref.watch(themeSettingsProvider);
    final isCupertino = Platform.isIOS;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // App Settings Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('app_settings'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

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
                        subtitle: Text(
                            localizations.translate('imperial_units_desc')),
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
                              _showLanguageSelector(
                                  context, ref, localizations);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: CupertinoColors.systemGrey4),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Enhanced Theme Customization Section
        Card(
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
                const SizedBox(height: 8),

                Text(
                  'Customize your app\'s color palette',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // Primary Color Selector
                ListTile(
                  title: const Text('Primary Color'),
                  subtitle: const Text(
                      'Main accent color for buttons and highlights'),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: themeSettings.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  onTap: () {
                    _showColorPicker(
                        context, 'Primary Color', themeSettings.primaryColor,
                        (color) {
                      ref
                          .read(themeSettingsProvider.notifier)
                          .updatePrimaryColor(color);
                    });
                  },
                ),

                // Secondary Color Selector
                ListTile(
                  title: const Text('Secondary Color'),
                  subtitle: const Text(
                      'Used for floating action buttons and accents'),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: themeSettings.secondaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  onTap: () {
                    _showColorPicker(context, 'Secondary Color',
                        themeSettings.secondaryColor, (color) {
                      ref
                          .read(themeSettingsProvider.notifier)
                          .updateSecondaryColor(color);
                    });
                  },
                ),

                // Success Color Selector
                ListTile(
                  title: const Text('Success Color'),
                  subtitle:
                      const Text('Used for positive actions and confirmations'),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: themeSettings.successColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  onTap: () {
                    _showColorPicker(
                        context, 'Success Color', themeSettings.successColor,
                        (color) {
                      ref
                          .read(themeSettingsProvider.notifier)
                          .updateSuccessColor(color);
                    });
                  },
                ),

                // Warning Color Selector
                ListTile(
                  title: const Text('Warning Color'),
                  subtitle: const Text('Used for alerts that need attention'),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: themeSettings.warningColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  onTap: () {
                    _showColorPicker(
                        context, 'Warning Color', themeSettings.warningColor,
                        (color) {
                      ref
                          .read(themeSettingsProvider.notifier)
                          .updateWarningColor(color);
                    });
                  },
                ),

                // Error Color Selector
                ListTile(
                  title: const Text('Error Color'),
                  subtitle:
                      const Text('Used for errors and destructive actions'),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: themeSettings.errorColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  onTap: () {
                    _showColorPicker(
                        context, 'Error Color', themeSettings.errorColor,
                        (color) {
                      ref
                          .read(themeSettingsProvider.notifier)
                          .updateErrorColor(color);
                    });
                  },
                ),

                // Material You Toggle
                SwitchListTile(
                  title: const Text('Use Material You (Android 12+)'),
                  subtitle:
                      const Text('Use dynamic colors from your device theme'),
                  value: themeSettings.useMaterialYou,
                  onChanged: (value) {
                    // Toggle Material You
                    ref
                        .read(themeSettingsProvider.notifier)
                        .toggleMaterialYou();
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
                      // Reset to defaults
                      ref
                          .read(themeSettingsProvider.notifier)
                          .resetToDefaults();
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Theme Preview
                Text(
                  'Theme Preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                // Light/Dark theme preview
                Row(
                  children: [
                    Expanded(
                      child: _buildThemePreviewCard(
                          context, 'Light Theme', themeSettings, true),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildThemePreviewCard(
                          context, 'Dark Theme', themeSettings, false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // About Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('about'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(localizations.translate('version')),
                  subtitle: const Text('1.0.0'),
                ),
                ListTile(
                  title: Text(localizations.translate('terms_of_service')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Open terms of service
                  },
                ),
                ListTile(
                  title: Text(localizations.translate('privacy_policy')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Open privacy policy
                  },
                ),
                ListTile(
                  title: Text(localizations.translate('help_support')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Open help & support
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Theme preview card
  Widget _buildThemePreviewCard(BuildContext context, String title,
      ThemeSettings settings, bool isLight) {
    // Get colors based on theme type
    final primaryColor = isLight
        ? settings.primaryColor
        : _darkenColor(settings.primaryColor, 0.2);
    final backgroundColor = isLight ? Colors.white : const Color(0xFF121212);
    final textColor = isLight ? Colors.black87 : Colors.white;
    final cardColor = isLight ? Colors.white : const Color(0xFF2C2C2C);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Sample Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: null,
              child: const Text('Button'),
            ),
          ),

          const SizedBox(height: 8),

          // Sample Card
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: primaryColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sample card',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to darken a color
  Color _darkenColor(Color color, double factor) {
    assert(factor >= 0 && factor <= 1);

    int r = (color.red * (1 - factor)).round();
    int g = (color.green * (1 - factor)).round();
    int b = (color.blue * (1 - factor)).round();

    return Color.fromRGBO(r, g, b, 1.0);
  }

  void _showColorPicker(BuildContext context, String title, Color initialColor,
      Function(Color) onColorSelected) {
    showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(
        title: title,
        initialColor: initialColor,
        onColorSelected: onColorSelected,
      ),
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
                  // Set to German
                },
                child: const Text('Deutsch'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to French
                },
                child: const Text('Français'),
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
            content: SingleChildScrollView(
              child: Column(
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
                    title: const Text('Deutsch'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to German
                    },
                  ),
                  ListTile(
                    title: const Text('Français'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to French
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
}
