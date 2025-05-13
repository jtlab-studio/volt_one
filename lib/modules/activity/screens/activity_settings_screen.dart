import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';

class ActivitySettingsScreen extends ConsumerWidget {
  const ActivitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Thresholds section
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  localizations.translate('thresholds'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                title: Text('Pace'), // Fixed capitalization
                subtitle: const Text('4:00 - 5:30 min/km'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Open pace threshold settings
                },
              ),
              ListTile(
                title: Text('Heart Rate'), // Fixed capitalization
                subtitle: const Text('120 - 160 bpm'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Open heart rate threshold settings
                },
              ),
              ListTile(
                title: Text('Power'), // Fixed capitalization
                subtitle: const Text('200 - 300 watts'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Open power threshold settings
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Alerts section
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  localizations.translate('alerts'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                title: Text(localizations.translate('haptic')),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // Toggle haptic feedback
                  },
                ),
              ),
              ListTile(
                title: Text(localizations.translate('tts')),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // Toggle text-to-speech
                  },
                ),
              ),
              ListTile(
                title: Text(localizations.translate('tones')),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // Toggle audio tones
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // TTS Settings section
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  localizations.translate('tts'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                title: Text(localizations.translate('language')),
                subtitle: const Text('English'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Open language settings
                },
              ),
              ListTile(
                title: Text(localizations.translate('voice')),
                subtitle: const Text('Default'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Open voice settings
                },
              ),
              ListTile(
                title: Text(localizations.translate('pitch')),
                subtitle: const Text('1.0'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Open pitch settings
                },
              ),
              ListTile(
                title: Text(localizations.translate('speech_rate')),
                subtitle: const Text('1.0'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Open speech rate settings
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
