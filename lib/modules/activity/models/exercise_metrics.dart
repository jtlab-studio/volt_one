/// A model class to store exercise metrics
class ExerciseMetrics {
  // Time tracking
  final String elapsedTime;
  final DateTime? startTime;
  final DateTime? pauseTime;

  // Distance and pace
  final double distance; // in kilometers
  final String pace; // pace in min/km (format: "MM:SS")
  final String avgPace; // average pace in min/km

  // Heart rate
  final int heartRate; // in bpm
  final int avgHeartRate; // average heart rate

  // Power
  final int power; // in watts
  final int avgPower; // average power

  // Cadence
  final int cadence; // in steps per minute
  final int avgCadence; // average cadence

  // Elevation
  final int elevationGain; // in meters
  final int elevationLoss; // in meters

  const ExerciseMetrics({
    this.elapsedTime = '00:00:00',
    this.startTime,
    this.pauseTime,
    this.distance = 0.0,
    this.pace = '0:00',
    this.avgPace = '0:00',
    this.heartRate = 0,
    this.avgHeartRate = 0,
    this.power = 0,
    this.avgPower = 0,
    this.cadence = 0,
    this.avgCadence = 0,
    this.elevationGain = 0,
    this.elevationLoss = 0,
  });

  /// Create a copy with updated fields
  ExerciseMetrics copyWith({
    String? elapsedTime,
    DateTime? startTime,
    DateTime? pauseTime,
    double? distance,
    String? pace,
    String? avgPace,
    int? heartRate,
    int? avgHeartRate,
    int? power,
    int? avgPower,
    int? cadence,
    int? avgCadence,
    int? elevationGain,
    int? elevationLoss,
  }) {
    return ExerciseMetrics(
      elapsedTime: elapsedTime ?? this.elapsedTime,
      startTime: startTime ?? this.startTime,
      pauseTime: pauseTime ?? this.pauseTime,
      distance: distance ?? this.distance,
      pace: pace ?? this.pace,
      avgPace: avgPace ?? this.avgPace,
      heartRate: heartRate ?? this.heartRate,
      avgHeartRate: avgHeartRate ?? this.avgHeartRate,
      power: power ?? this.power,
      avgPower: avgPower ?? this.avgPower,
      cadence: cadence ?? this.cadence,
      avgCadence: avgCadence ?? this.avgCadence,
      elevationGain: elevationGain ?? this.elevationGain,
      elevationLoss: elevationLoss ?? this.elevationLoss,
    );
  }
}
