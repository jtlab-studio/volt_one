import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import 'screens/hr_zones_screen.dart';
import 'screens/power_zones_screen.dart' as power_zones;
import 'screens/pace_zones_screen.dart' as pace_zones;
import '../../shared/widgets/global_burger_menu.dart';

// Provider to track the current profile section
final profileSectionProvider = StateProvider<String>((ref) => 'hr_zones');

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(profileSectionProvider);

    return Scaffold(
      body: _getProfileContent(selectedSection),
      bottomNavigationBar:
          _buildProfileBottomNavBar(context, ref, selectedSection),
    );
  }

  Widget _getProfileContent(String section) {
    switch (section) {
      // Removed user_info
      case 'hr_zones':
        return const HRZonesScreen();
      case 'power_zones':
        return const power_zones.PowerZonesScreen();
      case 'pace_zones':
        return const pace_zones.PaceZonesScreen();
      // Removed app_settings
      default:
        return const HRZonesScreen();
    }
  }

  Widget _buildProfileBottomNavBar(
      BuildContext context, WidgetRef ref, String currentSection) {
    final localizations = AppLocalizations.of(context);

    return BottomNavigationBar(
      currentIndex: _getProfileNavIndex(currentSection),
      onTap: (index) {
        // Map the tapped index to the corresponding section
        final sections = [
          'hr_zones',
          'power_zones',
          'pace_zones',
        ];
        final selectedSection = sections[index];

        // Update the profile section
        ref.read(profileSectionProvider.notifier).state = selectedSection;

        // Also update the current screen ID for the burger menu if needed
        if (ref.read(currentScreenProvider.notifier).state != selectedSection) {
          ref.read(currentScreenProvider.notifier).state = selectedSection;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      elevation: 16,
      iconSize: 24,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: localizations.translate('heart_rate_zones'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.flash_on),
          label: localizations.translate('power_zones'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.speed),
          label: localizations.translate('pace_zones'),
        ),
        // Removed user_info and app_settings
      ],
    );
  }

  int _getProfileNavIndex(String section) {
    switch (section) {
      case 'hr_zones':
        return 0;
      case 'power_zones':
        return 1;
      case 'pace_zones':
        return 2;
      default:
        return 0; // Default to hr_zones
    }
  }
}
