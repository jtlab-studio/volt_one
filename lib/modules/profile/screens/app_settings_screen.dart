// lib/modules/profile/screens/app_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import 'dart:io' show Platform;

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final isCupertino = Platform.isIOS;

    // Debugging code to check if this widget is being rendered
    print('AppSettingsScreen is being built');

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

        // Theme Customization Section
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
                const SizedBox(height: 16),

                // Primary Color Selector
                ListTile(
                  title: const Text('Primary Color'),
                  subtitle: const Text('Main accent color for the app'),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  onTap: () {
                    // Show color picker dialog
                  },
                ),

                // Material You Toggle
                SwitchListTile(
                  title: const Text('Use Material You (Android 12+)'),
                  subtitle:
                      const Text('Use dynamic colors from your device theme'),
                  value: false,
                  onChanged: (value) {
                    // Toggle Material You
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
                    },
                  ),
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
                  // Set to Spanish (Latin America)
                },
                child: const Text('Español (Latinoamérica)'),
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
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Italian
                },
                child: const Text('Italiano'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Japanese
                },
                child: const Text('日本語'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Korean
                },
                child: const Text('한국어'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Swedish
                },
                child: const Text('Svenska'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Finnish
                },
                child: const Text('Suomi'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Norwegian
                },
                child: const Text('Norsk'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Danish
                },
                child: const Text('Dansk'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Portuguese (Portugal)
                },
                child: const Text('Português (Portugal)'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Portuguese (Brazil)
                },
                child: const Text('Português (Brasil)'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Simplified Chinese
                },
                child: const Text('简体中文'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Traditional Chinese
                },
                child: const Text('繁體中文'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Set to Arabic
                },
                child: const Text('العربية'),
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
                    title: const Text('Español (Latinoamérica)'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Spanish (Latin America)
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
                  ListTile(
                    title: const Text('Italiano'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Italian
                    },
                  ),
                  ListTile(
                    title: const Text('日本語'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Japanese
                    },
                  ),
                  ListTile(
                    title: const Text('한국어'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Korean
                    },
                  ),
                  ListTile(
                    title: const Text('Svenska'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Swedish
                    },
                  ),
                  ListTile(
                    title: const Text('Suomi'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Finnish
                    },
                  ),
                  ListTile(
                    title: const Text('Norsk'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Norwegian
                    },
                  ),
                  ListTile(
                    title: const Text('Dansk'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Danish
                    },
                  ),
                  ListTile(
                    title: const Text('Português (Portugal)'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Portuguese (Portugal)
                    },
                  ),
                  ListTile(
                    title: const Text('Português (Brasil)'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Portuguese (Brazil)
                    },
                  ),
                  ListTile(
                    title: const Text('简体中文'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Simplified Chinese
                    },
                  ),
                  ListTile(
                    title: const Text('繁體中文'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Traditional Chinese
                    },
                  ),
                  ListTile(
                    title: const Text('العربية'),
                    onTap: () {
                      Navigator.pop(context);
                      // Set to Arabic
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
