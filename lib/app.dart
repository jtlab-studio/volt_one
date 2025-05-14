import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'core/l10n/app_localizations.dart'; // Updated import path

class VoltApp extends ConsumerWidget {
  const VoltApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.watch(navigatorKeyProvider);
    final themeMode = ref.watch(themeModeProvider);
    final materialTheme = ref.watch(materialThemeProvider);
    final locale = ref.watch(localeProvider);

    // Common localization delegates
    final localizationsDelegates = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

    // Updated list of supported locales based on JSON files in assets/lang folder
    final supportedLocales = const [
      Locale('en', ''), // English
      Locale('de', ''), // German
      Locale('es', ''), // Spanish
      Locale('es', 'CL'), // Spanish (Chile)
      Locale('es', 'LATAM'), // Spanish (Latin America)
      Locale('fr', ''), // French
      Locale('it', ''), // Italian
      Locale('ja', ''), // Japanese
      Locale('ko', ''), // Korean
      Locale('pt', 'BR'), // Portuguese (Brazil)
      Locale('pt', 'PT'), // Portuguese (Portugal)
      Locale('ru', ''), // Russian
      Locale('tr', ''), // Turkish
      Locale('zh', 'Hans'), // Chinese (Simplified)
      Locale('zh', 'Hant'), // Chinese (Traditional)
    ];

    return MaterialApp(
      title: 'Volt Running Tracker',
      theme: materialTheme.light,
      darkTheme: materialTheme.dark,
      themeMode: themeMode,
      navigatorKey: navigatorKey,
      home: const VoltRootWidget(),
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
    );
  }
}
