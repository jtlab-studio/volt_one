// Import this to use the activitySectionProvider
import '../activity_hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';

class ActivityHistoryScreen extends ConsumerWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);

    // For demonstration, we'll show an empty state with the correct message
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_run, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            localizations.translate(
                'no_activities_found'), // Changed from 'no_devices_found'
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              localizations.translate(
                  'start_tracking_message'), // Using a new key for the correct message
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to start activity
              ref.read(activitySectionProvider.notifier).state = 'new_activity';
            },
            icon: const Icon(Icons.add),
            label: Text(localizations.translate('new_activity')),
          ),
        ],
      ),
    );
  }
}
