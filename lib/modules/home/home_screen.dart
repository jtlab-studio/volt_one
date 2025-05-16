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
    // Group 1: Primary languages
    final primaryLanguages = [
      DropdownMenuItem(
        value: const Locale('en', ''),
        child: _buildLanguageItem('English', '🇺🇸'),
      ),
      DropdownMenuItem(
        value: const Locale('de', ''),
        child: _buildLanguageItem('Deutsch', '🇩🇪'),
      ),
      DropdownMenuItem(
        value: const Locale('fr', ''),
        child: _buildLanguageItem('Français', '🇫🇷'),
      ),
    ];

    // Group 2: Spanish variants
    final spanishVariants = [
      DropdownMenuItem(
        value: const Locale('es', ''),
        child: _buildLanguageItem('Español', '🇪🇸'),
      ),
      DropdownMenuItem(
        value: const Locale('es', 'LATAM'),
        child: _buildLanguageItem('Español (Latinoamérica)', '🌎'),
      ),
      DropdownMenuItem(
        value: const Locale('es', 'CL'),
        child: _buildLanguageItem('Español (Chile)', '🇨🇱'),
      ),
    ];

    // Group 3: Portuguese variants
    final portugueseVariants = [
      DropdownMenuItem(
        value: const Locale('pt', 'BR'),
        child: _buildLanguageItem('Português (Brasil)', '🇧🇷'),
      ),
      DropdownMenuItem(
        value: const Locale('pt', 'PT'),
        child: _buildLanguageItem('Português (Portugal)', '🇵🇹'),
      ),
    ];

    // Group 4: Asian languages
    final asianLanguages = [
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
      DropdownMenuItem(
        value: const Locale('zh', 'Hant'),
        child: _buildLanguageItem('繁體中文', '🇹🇼'),
      ),
    ];

    // Group 5: Other European languages
    final otherEuropeanLanguages = [
      DropdownMenuItem(
        value: const Locale('it', ''),
        child: _buildLanguageItem('Italiano', '🇮🇹'),
      ),
      DropdownMenuItem(
        value: const Locale('ru', ''),
        child: _buildLanguageItem('Русский', '🇷🇺'),
      ),
      DropdownMenuItem(
        value: const Locale('tr', ''),
        child: _buildLanguageItem('Türkçe', '🇹🇷'),
      ),
    ];

    // Combine all groups with dividers
    return [
      ...primaryLanguages,
      const DropdownMenuItem<Locale>(
        enabled: false,
        child: Divider(),
      ),
      ...spanishVariants,
      const DropdownMenuItem<Locale>(
        enabled: false,
        child: Divider(),
      ),
      ...portugueseVariants,
      const DropdownMenuItem<Locale>(
        enabled: false,
        child: Divider(),
      ),
      ...asianLanguages,
      const DropdownMenuItem<Locale>(
        enabled: false,
        child: Divider(),
      ),
      ...otherEuropeanLanguages,
    ];
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
