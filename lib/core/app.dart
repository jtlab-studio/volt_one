// lib/core/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'theme_manager.dart';
import 'l10n/app_localizations.dart';

class VoltApp extends StatefulWidget {
  const VoltApp({super.key});

  @override
  State<VoltApp> createState() => _VoltAppState();
}

class _VoltAppState extends State<VoltApp> {
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

    debugPrint("Building VoltApp with theme style: ${appTheme.style}");

    // Common localization delegates
    final localizationsDelegates = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

    final supportedLocales = const [
      Locale('en', ''), // English
      Locale('es', ''), // Español
      Locale('de', ''), // Deutsch
      Locale('fr', ''), // Français
      Locale('ru', ''), // Русский
      // Add other locales as needed
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
    );
  }
}
