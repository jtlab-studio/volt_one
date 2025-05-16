// lib/shared/widgets/language_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/router.dart';
import 'dart:io' show Platform;

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${localizations.translate('language')}:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: InkWell(
              onTap: () => _showLanguageSelector(context, ref, localizations),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_getLanguageName(currentLocale)),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      if (countryCode == 'CL') return 'Español (Chile)';
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
      if (countryCode == 'Hant') return '繁體中文';
      return '中文';
    }

    return 'Unknown';
  }

  void _showLanguageSelector(
      BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    final currentLocale = ref.read(localeProvider);

    // Define available locales with their display names and flags
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
      {
        'locale': const Locale('es', 'CL'),
        'name': 'Español (Chile)',
        'flag': '🇨🇱'
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
