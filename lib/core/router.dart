// lib/core/router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modules/home/home_screen.dart';

// Provider to manage the current locale - default to US English since we have that file
final localeProvider = StateProvider<Locale>((ref) => const Locale('en', 'US'));

// Simple router provider
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

// Root widget that displays the home screen
class VoltRootWidget extends StatelessWidget {
  const VoltRootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

// Function to change the app's locale
void changeLocale(WidgetRef ref, Locale newLocale) {
  ref.read(localeProvider.notifier).state = newLocale;
}
