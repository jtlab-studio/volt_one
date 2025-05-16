// lib/modules/settings/settings_module.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/settings_root_screen.dart';
import 'screens/zones_hub_screen.dart';

/// Entry point for the Settings module
class SettingsModule {
  // Method to register any necessary dependencies or routes
  static void register() {
    // This could register module-specific routes if needed
  }

  // Factory method to create the root settings screen
  static Widget createRootScreen() {
    return const SettingsRootScreen();
  }
  
  // Factory method to create the zones hub screen
  static Widget createZonesHubScreen() {
    return const ZonesHubScreen();
  }
}

// Provider to track the current settings section
final settingsSectionProvider = StateProvider<String>((ref) => 'volt_settings');
