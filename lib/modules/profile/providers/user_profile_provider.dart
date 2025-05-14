// lib/modules/profile/providers/user_profile_provider.dart - Updated default values

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

// Provider for user profile data
final userProfileProvider = StateProvider<UserProfile>((ref) {
  return const UserProfile(
    name: 'Runner',
    weight: 70,
    height: 175,
    gender: Gender.notSpecified,
    lthr: 160,
    criticalPower: 300, // Default value for Critical Power
    criticalPace: 270, // Default value for Critical Pace (4:30 min/km)
    birthYear: 1990,
    numZones: 5, // Default to 5 HR zones
    powerZones: 5, // Default to 5 power zones
    paceZones: 6, // Default to 6 pace zones
    autoCalculateZones: true, // Default to auto calculate HR zones
    autoCalculatePowerZones: true, // Default to auto calculate power zones
    autoCalculatePaceZones: true, // Default to auto calculate pace zones
  );
});
