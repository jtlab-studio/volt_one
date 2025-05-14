// lib/modules/profile/models/user_profile.dart - Updated to include pace-related fields

class UserProfile {
  final String name;
  final double weight; // kg
  final double height; // cm
  final double legLength; // cm - field for leg length
  final Gender gender;
  final int lthr; // Lactate Threshold Heart Rate
  final int criticalPower; // Critical Power for running
  final int criticalPace; // Critical Pace in seconds per kilometer
  final int birthYear;
  final int numZones; // Number of heart rate zones (3-7)
  final int powerZones; // Number of power zones (3-7)
  final int paceZones; // Number of pace zones (3-7)
  final bool autoCalculateZones; // Whether to auto-calculate HR zones
  final bool autoCalculatePowerZones; // Whether to auto-calculate power zones
  final bool autoCalculatePaceZones; // Whether to auto-calculate pace zones

  const UserProfile({
    required this.name,
    required this.weight,
    required this.height,
    this.legLength = 80.0, // Default value for leg length
    required this.gender,
    required this.lthr,
    this.criticalPower = 300, // Default value for Critical Power (running)
    this.criticalPace = 270, // Default value for Critical Pace (4:30 min/km)
    required this.birthYear,
    required this.numZones,
    this.powerZones = 5, // Default to 5 power zones
    this.paceZones = 6, // Default to 6 pace zones
    required this.autoCalculateZones,
    this.autoCalculatePowerZones =
        true, // Default to auto-calculating power zones
    this.autoCalculatePaceZones =
        true, // Default to auto-calculating pace zones
  });

  // Create a copy with updated fields
  UserProfile copyWith({
    String? name,
    double? weight,
    double? height,
    double? legLength,
    Gender? gender,
    int? lthr,
    int? criticalPower,
    int? criticalPace,
    int? birthYear,
    int? numZones,
    int? powerZones,
    int? paceZones,
    bool? autoCalculateZones,
    bool? autoCalculatePowerZones,
    bool? autoCalculatePaceZones,
  }) {
    return UserProfile(
      name: name ?? this.name,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      legLength: legLength ?? this.legLength,
      gender: gender ?? this.gender,
      lthr: lthr ?? this.lthr,
      criticalPower: criticalPower ?? this.criticalPower,
      criticalPace: criticalPace ?? this.criticalPace,
      birthYear: birthYear ?? this.birthYear,
      numZones: numZones ?? this.numZones,
      powerZones: powerZones ?? this.powerZones,
      paceZones: paceZones ?? this.paceZones,
      autoCalculateZones: autoCalculateZones ?? this.autoCalculateZones,
      autoCalculatePowerZones:
          autoCalculatePowerZones ?? this.autoCalculatePowerZones,
      autoCalculatePaceZones:
          autoCalculatePaceZones ?? this.autoCalculatePaceZones,
    );
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.name == name &&
        other.weight == weight &&
        other.height == height &&
        other.legLength == legLength &&
        other.gender == gender &&
        other.lthr == lthr &&
        other.criticalPower == criticalPower &&
        other.criticalPace == criticalPace &&
        other.birthYear == birthYear &&
        other.numZones == numZones &&
        other.powerZones == powerZones &&
        other.paceZones == paceZones &&
        other.autoCalculateZones == autoCalculateZones &&
        other.autoCalculatePowerZones == autoCalculatePowerZones &&
        other.autoCalculatePaceZones == autoCalculatePaceZones;
  }

  // Hash code
  @override
  int get hashCode {
    return name.hashCode ^
        weight.hashCode ^
        height.hashCode ^
        legLength.hashCode ^
        gender.hashCode ^
        lthr.hashCode ^
        criticalPower.hashCode ^
        criticalPace.hashCode ^
        birthYear.hashCode ^
        numZones.hashCode ^
        powerZones.hashCode ^
        paceZones.hashCode ^
        autoCalculateZones.hashCode ^
        autoCalculatePowerZones.hashCode ^
        autoCalculatePaceZones.hashCode;
  }
}

// Gender enum remains unchanged
enum Gender { male, female, notSpecified }
