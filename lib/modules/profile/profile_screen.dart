// lib/modules/profile/profile_screen.dart - Complete implementation with bottom navigation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import 'screens/app_settings_screen.dart';
import '../../shared/widgets/global_burger_menu.dart'; // Import for currentScreenProvider

// Provider to track the current profile section
final profileSectionProvider = StateProvider<String>((ref) => 'user_info');

// Orange color to use throughout the app
final orangeColor = const Color.fromRGBO(255, 152, 0, 1.0);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(profileSectionProvider);

    // Get localization for translations
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: _getProfileContent(selectedSection),
      bottomNavigationBar: _buildProfileBottomNavBar(
          context, ref, selectedSection, localizations),
    );
  }

  Widget _getProfileContent(String section) {
    switch (section) {
      case 'user_info':
        // Use user profile section of existing implementation
        return _UserProfileContent();
      case 'hr_zones':
        return _HRZonesContent();
      case 'power_zones':
        return _PowerZonesContent();
      case 'pace_zones':
        return _PaceZonesContent();
      case 'app_settings':
        return const AppSettingsScreen();
      default:
        return _UserProfileContent();
    }
  }

  Widget _buildProfileBottomNavBar(BuildContext context, WidgetRef ref,
      String currentSection, AppLocalizations localizations) {
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
      selectedItemColor: orangeColor,
      unselectedItemColor: Colors.grey,
      elevation: 16, // Add elevation for shadow
      iconSize: 24, // Consistent icon size
      selectedFontSize: 12, // Font size for selected items
      unselectedFontSize: 12, // Font size for unselected items
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'User',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: 'Cardio',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.flash_on),
          label: 'Power',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.speed),
          label: 'Pacing',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: 'Settings',
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

// Placeholder widgets for the different sections
class _UserProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('User Info Content - Use Existing Implementation'),
    );
  }
}

class _HRZonesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Heart Rate Zones Content - Use HR zones implementation'),
    );
  }
}

class _PowerZonesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Power Zones Content - Use Power zones implementation'),
    );
  }
}

class _PaceZonesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Pace Zones Content - Use Pace zones implementation'),
    );
  }
}
