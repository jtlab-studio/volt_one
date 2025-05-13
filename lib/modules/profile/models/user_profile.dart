// UserProfile model with no unused imports
class UserProfile {
  final String name;
  final double weight; // kg
  final double height; // cm
  final double legLength; // cm - field for leg length
  final Gender gender;
  final int lthr; // Lactate Threshold Heart Rate
  final int criticalPower; // Critical Power for running - renamed from ftp
  final int birthYear;
  final int numZones; // Number of heart rate zones (3-7)
  final int powerZones; // Number of power zones (3-7)
  final bool autoCalculateZones; // Whether to auto-calculate HR zones
  final bool autoCalculatePowerZones; // Whether to auto-calculate power zones

  const UserProfile({
    required this.name,
    required this.weight,
    required this.height,
    this.legLength = 80.0, // Default value for leg length
    required this.gender,
    required this.lthr,
    this.criticalPower = 300, // Default value for Critical Power (running)
    required this.birthYear,
    required this.numZones,
    this.powerZones = 5, // Default to 5 power zones
    required this.autoCalculateZones,
    this.autoCalculatePowerZones =
        true, // Default to auto-calculating power zones
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
    int? birthYear,
    int? numZones,
    int? powerZones,
    bool? autoCalculateZones,
    bool? autoCalculatePowerZones,
  }) {
    return UserProfile(
      name: name ?? this.name,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      legLength: legLength ?? this.legLength,
      gender: gender ?? this.gender,
      lthr: lthr ?? this.lthr,
      criticalPower: criticalPower ?? this.criticalPower,
      birthYear: birthYear ?? this.birthYear,
      numZones: numZones ?? this.numZones,
      powerZones: powerZones ?? this.powerZones,
      autoCalculateZones: autoCalculateZones ?? this.autoCalculateZones,
      autoCalculatePowerZones:
          autoCalculatePowerZones ?? this.autoCalculatePowerZones,
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
        other.birthYear == birthYear &&
        other.numZones == numZones &&
        other.powerZones == powerZones &&
        other.autoCalculateZones == autoCalculateZones &&
        other.autoCalculatePowerZones == autoCalculatePowerZones;
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
        birthYear.hashCode ^
        numZones.hashCode ^
        powerZones.hashCode ^
        autoCalculateZones.hashCode ^
        autoCalculatePowerZones.hashCode;
  }
}

// Gender enum remains unchanged
enum Gender { male, female, notSpecified }
