import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
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
                  items: const [
                    DropdownMenuItem(
                      value: Locale('en', ''),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('es', ''),
                      child: Text('Español'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ru', ''),
                      child: Text('Русский'),
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
