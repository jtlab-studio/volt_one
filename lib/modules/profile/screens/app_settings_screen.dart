// lib/modules/profile/screens/app_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/theme_provider.dart'; // Import only theme_provider.dart
import '../../../core/theme/color_palettes.dart';
import '../../../core/theme/app_theme_extensions.dart';
import 'theme_preview_screen.dart';
import 'dart:io' show Platform;

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final palette = ref.watch(colorPaletteProvider);
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
                  style: context.textTheme.titleLarge?.copyWith(
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

        // Theme Selection Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Selection',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Choose a color palette for your app',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // Display available color palettes
                ...ColorPalettes.allPalettes.map((p) => _buildPaletteOption(
                      context,
                      ref,
                      p,
                      selectedPalette: palette,
                    )),

                const SizedBox(height: 16),

                // View Full Theme Preview button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.palette),
                    label: const Text('View Full Theme Preview'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ThemePreviewScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Theme Preview
                Text(
                  'Theme Preview',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Light/Dark theme preview
                Row(
                  children: [
                    Expanded(
                      child: _buildThemePreviewCard(
                          context, ref, 'Light Theme', true),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildThemePreviewCard(
                          context, ref, 'Dark Theme', false),
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
                  style: context.textTheme.titleMedium?.copyWith(
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

  // Build palette selection option
  Widget _buildPaletteOption(
      BuildContext context, WidgetRef ref, AppColorPalette palette,
      {required AppColorPalette selectedPalette}) {
    final isSelected = palette.name == selectedPalette.name;

    return ListTile(
      title: Text(palette.name),
      subtitle: Text(palette.description),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: palette.primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withAlpha(25), // Using withAlpha instead of withOpacity
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: palette.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: palette.primaryColor)
          : const Icon(Icons.circle_outlined),
      onTap: () {
        // Update the selected palette
        ref.read(colorPaletteProvider.notifier).setPalette(palette);
      },
    );
  }

  // Theme preview card
  Widget _buildThemePreviewCard(
      BuildContext context, WidgetRef ref, String title, bool isLight) {
    final palette = ref.watch(colorPaletteProvider);

    // Get colors based on theme type
    final backgroundColor =
        isLight ? palette.backgroundColorLight : palette.backgroundColorDark;
    final cardColor = isLight ? palette.cardColorLight : palette.cardColorDark;
    final textColor = isLight ? palette.textColorLight : palette.textColorDark;
    final primaryColor = palette.primaryColor;

    // Navigation preview colors
    final navSelectedColor = palette.navSelectedTextColor;
    final navUnselectedColor = palette.navUnselectedTextColor;

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
                foregroundColor: palette.buttonTextColor,
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
                  color: Colors.black
                      .withAlpha(25), // Using withAlpha instead of withOpacity
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

          const SizedBox(height: 8),

          // Navigation Preview
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isLight
                  ? palette.navBarBackgroundLight
                  : palette.navBarBackgroundDark,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.home, color: navUnselectedColor, size: 16),
                Icon(Icons.directions_run, color: navSelectedColor, size: 16),
                Icon(Icons.map, color: navUnselectedColor, size: 16),
              ],
            ),
          ),
        ],
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
