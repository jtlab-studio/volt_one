import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart'; // Updated import path
import '../../core/router.dart';
import 'screens/main_dashboard_screen.dart';

// Provider for storing whether it's the first launch
final isFirstLaunchProvider = StateProvider<bool>((ref) => true);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the localization delegate to translate text
    final localizations = AppLocalizations.of(context);
    final isFirstLaunch = ref.watch(isFirstLaunchProvider);

    // If not first launch, directly navigate to the main dashboard
    if (!isFirstLaunch) {
      // Use a post-frame callback to avoid build-time navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboardScreen()),
        );
      });

      // Show a loading indicator while we're waiting for the navigation
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_run, size: 64),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                localizations.translate('welcome'),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Mark first launch as complete
                ref.read(isFirstLaunchProvider.notifier).state = false;

                // Navigate to the main dashboard screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainDashboardScreen()),
                );
              },
              child: Text(localizations.translate('get_started')),
            ),
            const SizedBox(height: 32),
            // Language selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${localizations.translate('language')}: "),
                const SizedBox(width: 8),
                DropdownButton<Locale>(
                  value: ref.watch(localeProvider),
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      changeLocale(ref, newLocale);
                    }
                  },
                  items: [
                    // English
                    DropdownMenuItem(
                      value: const Locale('en', ''),
                      child: const Text('English'),
                    ),
                    // German
                    DropdownMenuItem(
                      value: const Locale('de', ''),
                      child: const Text('Deutsch'),
                    ),
                    // Spanish and variants
                    DropdownMenuItem(
                      value: const Locale('es', ''),
                      child: const Text('Español'),
                    ),
                    DropdownMenuItem(
                      value: const Locale('es', 'CL'),
                      child: const Text('Español (Chile)'),
                    ),
                    DropdownMenuItem(
                      value: const Locale('es', 'LATAM'),
                      child: const Text('Español (Latinoamérica)'),
                    ),
                    // French
                    DropdownMenuItem(
                      value: const Locale('fr', ''),
                      child: const Text('Français'),
                    ),
                    // Italian
                    DropdownMenuItem(
                      value: const Locale('it', ''),
                      child: const Text('Italiano'),
                    ),
                    // Japanese
                    DropdownMenuItem(
                      value: const Locale('ja', ''),
                      child: const Text('日本語'),
                    ),
                    // Korean
                    DropdownMenuItem(
                      value: const Locale('ko', ''),
                      child: const Text('한국어'),
                    ),
                    // Portuguese variants
                    DropdownMenuItem(
                      value: const Locale('pt', 'BR'),
                      child: const Text('Português (Brasil)'),
                    ),
                    DropdownMenuItem(
                      value: const Locale('pt', 'PT'),
                      child: const Text('Português (Portugal)'),
                    ),
                    // Russian
                    DropdownMenuItem(
                      value: const Locale('ru', ''),
                      child: const Text('Русский'),
                    ),
                    // Turkish
                    DropdownMenuItem(
                      value: const Locale('tr', ''),
                      child: const Text('Türkçe'),
                    ),
                    // Chinese variants
                    DropdownMenuItem(
                      value: const Locale('zh', 'Hans'),
                      child: const Text('简体中文'),
                    ),
                    DropdownMenuItem(
                      value: const Locale('zh', 'Hant'),
                      child: const Text('繁體中文'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
