// lib/modules/profile/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import 'screens/app_settings_screen.dart';
import 'screens/hr_zones_screen.dart';
import 'screens/power_zones_screen.dart' as power_zones;
import 'screens/pace_zones_screen.dart' as pace_zones;
import 'screens/user_info_screen.dart';
import '../../shared/widgets/global_burger_menu.dart';

// Provider to track the current profile section
final profileSectionProvider = StateProvider<String>((ref) => 'user_info');

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
      case 'user_info':
        return const UserInfoScreen();
      case 'hr_zones':
        return const HRZonesScreen();
      case 'power_zones':
        return const power_zones.PowerZonesScreen();
      case 'pace_zones':
        return const pace_zones.PaceZonesScreen();
      case 'app_settings':
        return const AppSettingsScreen();
      default:
        return const UserInfoScreen();
    }
  }

  Widget _buildProfileBottomNavBar(
      BuildContext context, WidgetRef ref, String currentSection) {
    final palette = ref.watch(colorPaletteProvider);

    return BottomNavigationBar(
      currentIndex: _getProfileNavIndex(currentSection),
      onTap: (index) {
        // Map the tapped index to the corresponding section
        final sections = [
          'user_info',
          'hr_zones',
          'power_zones',
          'pace_zones',
          'app_settings'
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
      selectedItemColor: palette.navSelectedTextColor,
      unselectedItemColor: palette.navUnselectedTextColor,
      elevation: 16,
      iconSize: 24,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User Info',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'HR Zones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flash_on),
          label: 'Power Zones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.speed),
          label: 'Pace Zones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'App Settings',
        ),
      ],
    );
  }

  int _getProfileNavIndex(String section) {
    switch (section) {
      case 'user_info':
        return 0;
      case 'hr_zones':
        return 1;
      case 'power_zones':
        return 2;
      case 'pace_zones':
        return 3;
      case 'app_settings':
        return 4;
      default:
        return 0; // Default to user info
    }
  }
}
