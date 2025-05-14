import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep track of the current locale
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    // Handle locale with regions (e.g., es-CL, pt-BR, zh-Hans)
    String languageCode = locale.languageCode;
    String? countryCode = locale.countryCode;

    String jsonString;

    try {
      // First, try to load the exact regional variant if specified
      if (countryCode != null && countryCode.isNotEmpty) {
        try {
          jsonString = await rootBundle
              .loadString("assets/lang/${languageCode}-${countryCode}.json");
          Map<String, dynamic> jsonMap = json.decode(jsonString);

          _localizedStrings = jsonMap.map((key, value) {
            return MapEntry(key, value.toString());
          });

          return true;
        } catch (e) {
          // If regional variant not found, fall back to base language
          print(
              "Regional variant ${languageCode}-${countryCode} not found, falling back to ${languageCode}");
        }
      }

      // Load the base language JSON file
      jsonString =
          await rootBundle.loadString("assets/lang/${languageCode}.json");
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return true;
    } catch (e) {
      print("Failed to load language file for ${locale.toString()}: $e");

      // Fallback to English if the requested language is not found
      if (languageCode != 'en') {
        print("Falling back to English");
        try {
          jsonString = await rootBundle.loadString("assets/lang/en.json");
          Map<String, dynamic> jsonMap = json.decode(jsonString);

          _localizedStrings = jsonMap.map((key, value) {
            return MapEntry(key, value.toString());
          });
        } catch (e) {
          print("Failed to load fallback English language file: $e");
          // Return empty map if even English fails
          _localizedStrings = {};
        }
      } else {
        // If English itself is failing, return empty map
        _localizedStrings = {};
      }

      return false;
    }
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Base language support
    final supportedLanguages = [
      "en",
      "es",
      "de",
      "fr",
      "ru",
      "pt",
      "it",
      "zh",
      "ja",
      "ko",
      "hi",
      "vi",
      "id",
      "ms",
      "th",
      "tr",
      "sv",
      "no",
      "da",
      "ay", // Aymara
      "qu", // Quechua
      "arn", // Mapudungun (also previously referenced as 'map')
      "gn", // Guarani
      "sw", // Swahili
      "nah" // Nahuatl
    ];

    // Check if the basic language is supported
    if (supportedLanguages.contains(locale.languageCode)) {
      // For languages with regional variants, check the country code
      if (locale.languageCode == 'es') {
        // Handle Spanish variants (Spain, Chile, Latin America)
        return locale.countryCode == null ||
            locale.countryCode == '' ||
            ['CL', 'LATAM'].contains(locale.countryCode);
      } else if (locale.languageCode == 'pt') {
        // Handle Portuguese variants (Brazil, Portugal)
        return locale.countryCode == null ||
            locale.countryCode == '' ||
            ['BR', 'PT'].contains(locale.countryCode);
      } else if (locale.languageCode == 'zh') {
        // Handle Chinese variants (Simplified, Traditional)
        return locale.countryCode == null ||
            locale.countryCode == '' ||
            ['Hans', 'Hant'].contains(locale.countryCode);
      }

      // For languages without variants, any country code is fine
      return true;
    }

    return false;
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
