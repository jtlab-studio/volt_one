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
      Locale('es', ''), // Español
      Locale('de', ''), // Deutsch
      Locale('fr', ''), // Français
      Locale('ru', ''), // Русский
      Locale('pt', 'BR'), // Português (Brasil)
      Locale('pt', 'PT'), // Português (Portugal)
      Locale('it', ''), // Italiano
      Locale('zh', 'Hans'), // 简体中文
      Locale('zh', 'Hant'), // 繁體中文
      Locale('ja', ''), // 日本語
      Locale('ko', ''), // 한국어
      Locale('hi', ''), // हिन्दी
      Locale('vi', ''), // Tiếng Việt
      Locale('id', ''), // Bahasa Indonesia
      Locale('ms', ''), // Bahasa Melayu
      Locale('th', ''), // ไทย
      Locale('tr', ''), // Türkçe
      Locale('sv', ''), // Svenska
      Locale('no', ''), // Norsk
      Locale('da', ''), // Dansk
      Locale('es', 'CL'), // Español (Chile)
      Locale('es', 'LATAM'), // Español (Latinoamérica)
      Locale('ay', ''), // Aymara
      Locale('qu', ''), // Quechua
      Locale('arn', ''), // Mapudungun
      Locale('gn', ''), // Guarani
      Locale('sw', ''), // Swahili
      Locale('nah', ''), // Nahuatl
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
