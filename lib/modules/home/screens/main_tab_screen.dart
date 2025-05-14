// lib/modules/home/screens/main_tab_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/adaptive_tab_scaffold.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../profile/profile_screen.dart';
import '../../activity/activity_hub_screen.dart';
import '../../routes/routes_screen.dart';
import '../../tribe/tribe_screen.dart';

/// State provider for the current tab index
final mainTabIndexProvider =
    StateProvider<int>((ref) => 1); // Default to Activity tab

class MainTabScreen extends ConsumerWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainTabIndexProvider);
    final localizations = AppLocalizations.of(context);

    final tabs = [
      TabItem(
        title: localizations.translate('profile'),
        icon: Icons.person,
        screen: const ProfileScreen(),
      ),
      TabItem(
        title: localizations.translate('activity'),
        icon: Icons.directions_run,
        screen: const ActivityHubScreen(),
      ),
      TabItem(
        title: localizations.translate('routes'),
        icon: Icons.map,
        screen: const RoutesScreen(),
      ),
      TabItem(
        title: localizations.translate('tribe'),
        icon: Icons.people,
        screen: const TribeScreen(),
      ),
    ];

    return AdaptiveTabScaffold(
      tabs: tabs,
      currentIndex: currentIndex,
      onTabSelected: (index) {
        ref.read(mainTabIndexProvider.notifier).state = index;
      },
    );
  }
}
