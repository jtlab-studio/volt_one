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
    final currentLocale = ref.watch(localeProvider);

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

            // Enhanced language selector with proper grouping
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
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
                    child: DropdownButton<Locale>(
                      value: currentLocale,
                      isExpanded: true,
                      underline: const SizedBox(),
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          debugPrint(
                              "Changing locale to: ${newLocale.languageCode}${newLocale.countryCode != null ? '-${newLocale.countryCode}' : ''}");
                          changeLocale(ref, newLocale);
                        }
                      },
                      items: _buildLanguageMenuItems(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build comprehensive language menu items
  List<DropdownMenuItem<Locale>> _buildLanguageMenuItems() {
    // Only include languages that have JSON files
    final allLanguages = [
      DropdownMenuItem(
        value: const Locale('en', 'US'),
        child: _buildLanguageItem('English (US)', '🇺🇸'),
      ),
      DropdownMenuItem(
        value: const Locale('en', 'GB'),
        child: _buildLanguageItem('English (UK)', '🇬🇧'),
      ),
      DropdownMenuItem(
        value: const Locale('de', ''),
        child: _buildLanguageItem('Deutsch', '🇩🇪'),
      ),
      DropdownMenuItem(
        value: const Locale('fr', ''),
        child: _buildLanguageItem('Français', '🇫🇷'),
      ),
      const DropdownMenuItem<Locale>(
        enabled: false,
        child: Divider(),
      ),
      DropdownMenuItem(
        value: const Locale('es', ''),
        child: _buildLanguageItem('Español', '🇪🇸'),
      ),
      DropdownMenuItem(
        value: const Locale('es', 'LATAM'),
        child: _buildLanguageItem('Español (Latinoamérica)', '🌎'),
      ),
      const DropdownMenuItem<Locale>(
        enabled: false,
        child: Divider(),
      ),
      DropdownMenuItem(
        value: const Locale('pt', 'BR'),
        child: _buildLanguageItem('Português (Brasil)', '🇧🇷'),
      ),
      DropdownMenuItem(
        value: const Locale('pt', 'PT'),
        child: _buildLanguageItem('Português (Portugal)', '🇵🇹'),
      ),
      const DropdownMenuItem<Locale>(
        enabled: false,
        child: Divider(),
      ),
      DropdownMenuItem(
        value: const Locale('ja', ''),
        child: _buildLanguageItem('日本語', '🇯🇵'),
      ),
      DropdownMenuItem(
        value: const Locale('ko', ''),
        child: _buildLanguageItem('한국어', '🇰🇷'),
      ),
      DropdownMenuItem(
        value: const Locale('zh', 'Hans'),
        child: _buildLanguageItem('简体中文', '🇨🇳'),
      ),
      const DropdownMenuItem<Locale>(
        enabled: false,
        child: Divider(),
      ),
      DropdownMenuItem(
        value: const Locale('it', ''),
        child: _buildLanguageItem('Italiano', '🇮🇹'),
      ),
      DropdownMenuItem(
        value: const Locale('ru', ''),
        child: _buildLanguageItem('Русский', '🇷🇺'),
      ),
    ];

    return allLanguages;
  }

  // Helper method to create language items with flags
  Widget _buildLanguageItem(String languageName, String flag) {
    return Row(
      children: [
        Text(flag, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(child: Text(languageName)),
      ],
    );
  }
}
