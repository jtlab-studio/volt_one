import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import '../../responsive/screen_type.dart';
import 'screens/start_activity_screen.dart';
import 'screens/activity_history_screen.dart';

/// State provider for the current activity section
final activitySectionProvider = StateProvider<String>((ref) => 'new_activity');

class ActivityHubScreen extends ConsumerWidget {
  const ActivityHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(activitySectionProvider);
    final localizations = AppLocalizations.of(context);
    final screenType = getScreenType(context);

    // Map section IDs to screen widgets - removed activity_settings and sensors
    final sectionWidgets = {
      'new_activity': const StartActivityScreen(),
      'all_activities': const ActivityHistoryScreen(),
    };

    // Get the current section's screen
    final currentScreen =
        sectionWidgets[selectedSection] ?? const StartActivityScreen();

    // Use different layouts based on screen size
    if (screenType == ScreenType.desktop) {
      return _buildWideLayout(
          context, ref, selectedSection, localizations, currentScreen);
    } else {
      return _buildNarrowLayout(
          context, ref, selectedSection, localizations, currentScreen);
    }
  }

  Widget _buildWideLayout(
      BuildContext context,
      WidgetRef ref,
      String currentSection,
      AppLocalizations localizations,
      Widget currentScreen) {
    // For wider screens, use a sidebar navigation with the content on the right
    return Row(
      children: [
        // Navigation sidebar
        Container(
          width: 220,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1.0,
              ),
            ),
          ),
          child: ListView(
            children: [
              _buildSidebarItem(
                context,
                ref,
                'new_activity',
                localizations.translate('new_activity'),
                Icons.play_circle_outline,
                currentSection == 'new_activity',
              ),
              _buildSidebarItem(
                context,
                ref,
                'all_activities',
                localizations.translate('all_activities'),
                Icons.history,
                currentSection == 'all_activities',
              ),
            ],
          ),
        ),

        // Content area
        Expanded(
          child: currentScreen,
        ),
      ],
    );
  }

  Widget _buildSidebarItem(BuildContext context, WidgetRef ref,
      String sectionId, String label, IconData icon, bool isSelected) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.primaryColor : Colors.grey;
    final bgColor =
        isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.transparent;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
      selected: isSelected,
      selectedTileColor: bgColor,
      onTap: () {
        ref.read(activitySectionProvider.notifier).state = sectionId;
      },
    );
  }

  Widget _buildNarrowLayout(
      BuildContext context,
      WidgetRef ref,
      String currentSection,
      AppLocalizations localizations,
      Widget currentScreen) {
    // For narrower screens, use tabs at the top
    return Column(
      children: [
        // Section selector tabs
        _buildActivitySectionTabs(context, ref, currentSection, localizations),

        // Current section content
        Expanded(child: currentScreen),
      ],
    );
  }

  Widget _buildActivitySectionTabs(BuildContext context, WidgetRef ref,
      String currentSection, AppLocalizations localizations) {
    return Container(
      color: Theme.of(context).primaryColor.withAlpha(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSectionTab(
              context,
              ref,
              'new_activity',
              localizations.translate('new_activity'),
              Icons.play_circle_outline,
              currentSection == 'new_activity',
            ),
            _buildSectionTab(
              context,
              ref,
              'all_activities',
              localizations.translate('all_activities'),
              Icons.history,
              currentSection == 'all_activities',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTab(BuildContext context, WidgetRef ref, String sectionId,
      String label, IconData icon, bool isSelected) {
    final color = isSelected ? Theme.of(context).primaryColor : Colors.grey;

    return InkWell(
      onTap: () {
        ref.read(activitySectionProvider.notifier).state = sectionId;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
