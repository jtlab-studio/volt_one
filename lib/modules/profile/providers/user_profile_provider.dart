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
    birthYear: 1990,
    numZones: 5, // Default to 5 zones
    autoCalculateZones: true, // Default to auto calculate zones
  );
});
