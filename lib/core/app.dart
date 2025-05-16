// lib/core/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme_manager.dart';
import 'l10n/app_localizations.dart';

class VoltApp extends ConsumerStatefulWidget {
  const VoltApp({super.key});

  @override
  ConsumerState<VoltApp> createState() => _VoltAppState();
}

class _VoltAppState extends ConsumerState<VoltApp> {
  // Late initialize theme manager
  late ThemeManager _themeManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the theme manager and listen for changes
    _themeManager = ThemeManagerProvider.of(context);
    _themeManager.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  // Force rebuild when theme changes
  void _onThemeChanged() {
    setState(() {
      debugPrint("VoltApp rebuilding due to theme change");
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();
    final appTheme = _themeManager.getCurrentTheme();

    // Watch for locale changes from the provider
    final currentLocale = ref.watch(localeProvider);

    debugPrint(
        "Building VoltApp with theme style: ${appTheme.style} and locale: ${currentLocale.languageCode}${currentLocale.countryCode != null ? '-${currentLocale.countryCode}' : ''}");

    // Common localization delegates
    final localizationsDelegates = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

    // Only include locales that have corresponding JSON files
    final supportedLocales = const [
      Locale('en', 'US'), // English (US)
      Locale('en', 'GB'), // English (UK)
      Locale('es', ''), // Spanish (Spain)
      Locale('es', 'LATAM'), // Spanish (Latin America)
      Locale('de', ''), // German
      Locale('fr', ''), // French
      Locale('it', ''), // Italian
      Locale('ja', ''), // Japanese
      Locale('ko', ''), // Korean
      Locale('pt', 'BR'), // Portuguese (Brazil)
      Locale('pt', 'PT'), // Portuguese (Portugal)
      Locale('ru', ''), // Russian
      Locale('zh', 'Hans'), // Chinese (Simplified)
    ];

    return MaterialApp(
      title: 'Volt Running Tracker',
      theme: appTheme.light,
      darkTheme: appTheme.dark,
      themeMode: _themeManager.themeMode,
      navigatorKey: navigatorKey,
      home: const VoltRootWidget(),
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      // Set the app locale from the provider
      locale: currentLocale,
    );
  }
}
