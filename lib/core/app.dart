// lib/core/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart'; // Add this import
import 'l10n/app_localizations.dart';

class VoltApp extends ConsumerWidget {
  const VoltApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.watch(navigatorKeyProvider);
    final themeMode = ref.watch(themeModeProvider);
    // Replace materialThemeProvider with dynamicThemeProvider
    final materialTheme = ref.watch(dynamicThemeProvider);
    final locale = ref.watch(localeProvider);

    // Common localization delegates
    final localizationsDelegates = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

    final supportedLocales = const [
      Locale('en', ''), // English
      Locale('es', ''), // Spanish
      Locale('de', ''), // German
      Locale('fr', ''), // French
      Locale('ru', ''), // Russian
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
