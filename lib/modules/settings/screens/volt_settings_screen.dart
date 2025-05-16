// lib/modules/settings/screens/volt_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router.dart';
import '../../../theme/app_theme.dart';
import '../../../core/theme_manager.dart';
import 'dart:io' show Platform;

class VoltSettingsScreen extends ConsumerWidget {
  const VoltSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    // Get theme manager
    final themeManager = MediaQuery.of(context).size.width >= 600
        ? ThemeManagerProvider.of(context)
        : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // App Appearance Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('appearance'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Dark Mode Toggle
                _buildToggleSetting(
                  context,
                  localizations.translate('dark_mode'),
                  localizations.translate('dark_mode_desc'),
                  ThemeManagerProvider.of(context).themeMode == ThemeMode.dark,
                  (value) {
                    ThemeManagerProvider.of(context).setThemeMode(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Theme Style Selection
                if (themeManager != null) ...[
                  Text(
                    localizations.translate('theme_style'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildThemeStyleOption(
                        context,
                        Icons.crop_square,
                        localizations.translate('standard'),
                        themeManager.themeStyle == ThemeStyle.standard,
                        () => themeManager.setThemeStyle(ThemeStyle.standard),
                      ),
                      const SizedBox(width: 16),
                      _buildThemeStyleOption(
                        context,
                        Icons.blur_on,
                        localizations.translate('glassmorphic'),
                        themeManager.themeStyle == ThemeStyle.glassmorphic,
                        () =>
                            themeManager.setThemeStyle(ThemeStyle.glassmorphic),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Units and Language Settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('region_settings'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Units toggle
                _buildToggleSetting(
                  context,
                  localizations.translate('imperial_units'),
                  localizations.translate('imperial_units_desc'),
                  false, // Default to metric
                  (value) {
                    // Toggle units logic here
                  },
                ),

                const SizedBox(height: 16),

                // Language Selector
                Text(
                  localizations.translate('language'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () =>
                      _showLanguageSelector(context, ref, localizations),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_getLanguageName(currentLocale)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // About Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('about'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  Widget _buildToggleSetting(
    BuildContext context,
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    if (Platform.isIOS) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      );
    } else {
      return SwitchListTile(
        title: Text(title),
        subtitle: Text(description),
        value: value,
        onChanged: onChanged,
      );
    }
  }

  Widget _buildThemeStyleOption(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromRGBO(
                  theme.primaryColor.r,
                  theme.primaryColor.g,
                  theme.primaryColor.b,
                  0.15,
                )
              : null,
          border: Border.all(
            color:
                isSelected ? theme.primaryColor : Colors.grey.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.primaryColor : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? theme.primaryColor : null,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to get language name based on locale
  String _getLanguageName(Locale locale) {
    final languageCode = locale.languageCode;
    final countryCode = locale.countryCode;

    if (languageCode == 'en') {
      if (countryCode == 'US') return 'English (US)';
      if (countryCode == 'GB') return 'English (UK)';
      return 'English';
    }
    if (languageCode == 'es') {
      if (countryCode == 'LATAM') return 'Español (Latinoamérica)';
      return 'Español';
    }
    if (languageCode == 'de') return 'Deutsch';
    if (languageCode == 'fr') return 'Français';
    if (languageCode == 'it') return 'Italiano';
    if (languageCode == 'ru') return 'Русский';
    if (languageCode == 'pt') {
      if (countryCode == 'BR') return 'Português (Brasil)';
      if (countryCode == 'PT') return 'Português (Portugal)';
      return 'Português';
    }
    if (languageCode == 'ja') return '日本語';
    if (languageCode == 'ko') return '한국어';
    if (languageCode == 'zh') {
      if (countryCode == 'Hans') return '简体中文';
      return '中文';
    }

    return 'Unknown';
  }

  void _showLanguageSelector(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    final currentLocale = ref.read(localeProvider);

    // Only include languages that have JSON files
    final availableLocales = [
      {
        'locale': const Locale('en', 'US'),
        'name': 'English (US)',
        'flag': '🇺🇸'
      },
      {
        'locale': const Locale('en', 'GB'),
        'name': 'English (UK)',
        'flag': '🇬🇧'
      },
      {'locale': const Locale('es', ''), 'name': 'Español', 'flag': '🇪🇸'},
      {
        'locale': const Locale('es', 'LATAM'),
        'name': 'Español (Latinoamérica)',
        'flag': '🌎'
      },
      {'locale': const Locale('de', ''), 'name': 'Deutsch', 'flag': '🇩🇪'},
      {'locale': const Locale('fr', ''), 'name': 'Français', 'flag': '🇫🇷'},
      {'locale': const Locale('it', ''), 'name': 'Italiano', 'flag': '🇮🇹'},
      {
        'locale': const Locale('pt', 'BR'),
        'name': 'Português (Brasil)',
        'flag': '🇧🇷'
      },
      {
        'locale': const Locale('pt', 'PT'),
        'name': 'Português (Portugal)',
        'flag': '🇵🇹'
      },
      {'locale': const Locale('ru', ''), 'name': 'Русский', 'flag': '🇷🇺'},
      {'locale': const Locale('ja', ''), 'name': '日本語', 'flag': '🇯🇵'},
      {'locale': const Locale('ko', ''), 'name': '한국어', 'flag': '🇰🇷'},
      {'locale': const Locale('zh', 'Hans'), 'name': '简体中文', 'flag': '🇨🇳'},
    ];

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(localizations.translate('language')),
            actions: availableLocales.map((langData) {
              final locale = langData['locale'] as Locale;
              final name = langData['name'] as String;
              final flag = langData['flag'] as String;

              final isSelected =
                  locale.languageCode == currentLocale.languageCode &&
                      (locale.countryCode == currentLocale.countryCode ||
                          (locale.countryCode == null &&
                              currentLocale.countryCode == null));

              return CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // Only change if different from current
                  if (!isSelected) {
                    changeLocale(ref, locale);
                    // Show a confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Language changed to $name'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(flag, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Text(name),
                      ],
                    ),
                    if (isSelected)
                      const Icon(CupertinoIcons.check_mark,
                          color: CupertinoColors.activeBlue),
                  ],
                ),
              );
            }).toList(),
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
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableLocales.length,
                itemBuilder: (context, index) {
                  final langData = availableLocales[index];
                  final locale = langData['locale'] as Locale;
                  final name = langData['name'] as String;
                  final flag = langData['flag'] as String;

                  final isSelected =
                      locale.languageCode == currentLocale.languageCode &&
                          (locale.countryCode == currentLocale.countryCode ||
                              (locale.countryCode == null &&
                                  currentLocale.countryCode == null));

                  return ListTile(
                    leading: Text(flag, style: const TextStyle(fontSize: 24)),
                    title: Text(name),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    selected: isSelected,
                    onTap: () {
                      Navigator.pop(context);
                      // Only change if different from current
                      if (!isSelected) {
                        changeLocale(ref, locale);
                        // Show a confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Language changed to $name'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  );
                },
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
