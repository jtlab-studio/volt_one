// lib/modules/profile/screens/app_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import 'dart:io' show Platform;

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final isCupertino = Platform.isIOS;
    final theme = Theme.of(context);

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
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                                  const Text('English'), // Current language
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

        // About Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('about'),
                  style: theme.textTheme.titleMedium?.copyWith(
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
