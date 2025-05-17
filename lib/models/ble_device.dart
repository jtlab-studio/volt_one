import 'dart:convert'; // Keep this import as it's used in toJson/fromJson method

/// Represents a Bluetooth Low Energy device
class BleDevice {
  final String id;
  final String name;
  final String type;
  final int rssi;
  final bool connected;

  // List of available services
  final List<String> services;

  // Last connection timestamp
  final DateTime? lastConnected;

  // Is it a favorite/saved device?
  final bool isSaved;

  // Device specific metadata
  final Map<String, dynamic> metadata;

  BleDevice({
    required this.id,
    required this.name,
    required this.type,
    this.rssi = 0,
    this.connected = false,
    this.services = const [],
    this.lastConnected,
    this.isSaved = false,
    this.metadata = const {},
  });

  /// Create a copy of the device with modified properties
  BleDevice copyWith({
    String? id,
    String? name,
    String? type,
    int? rssi,
    bool? connected,
    List<String>? services,
    DateTime? lastConnected,
    bool? isSaved,
    Map<String, dynamic>? metadata,
  }) {
    return BleDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rssi: rssi ?? this.rssi,
      connected: connected ?? this.connected,
      services: services ?? this.services,
      lastConnected: lastConnected ?? this.lastConnected,
      isSaved: isSaved ?? this.isSaved,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Device type classification - using lowerCamelCase as recommended
  static const String typeHeartRate = 'heart_rate';
  static const String typePower = 'power';
  static const String typeCadence = 'cadence';
  static const String typeCombined = 'combined'; // Multiple sensor types in one
  static const String typeUnknown = 'unknown';

  /// Determine device type based on services
  static String determineDeviceType(List<String> services) {
    // Common service UUIDs for fitness devices - using lowerCamelCase
    const String heartRateService = '0000180d-0000-1000-8000-00805f9b34fb';
    const String cyclingPowerService = '00001818-0000-1000-8000-00805f9b34fb';
    const String runningSpeedCadenceService =
        '00001814-0000-1000-8000-00805f9b34fb';
    const String cyclingSpeedCadenceService =
        '00001816-0000-1000-8000-00805f9b34fb';

    // Stryd often has a custom service
    const String strydService = 'fb005c80-02e7-f387-1cad-8acd2d8df0c8';

    bool hasHeartRate = services.contains(heartRateService);
    bool hasPower = services.contains(cyclingPowerService) ||
        services.contains(strydService);
    bool hasCadence = services.contains(runningSpeedCadenceService) ||
        services.contains(cyclingSpeedCadenceService);

    // Determine type based on available services
    if (hasHeartRate && (hasPower || hasCadence)) {
      return typeCombined;
    } else if (hasHeartRate) {
      return typeHeartRate;
    } else if (hasPower) {
      return typePower;
    } else if (hasCadence) {
      return typeCadence;
    } else {
      return typeUnknown;
    }
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'services': services,
      'lastConnected': lastConnected?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create from JSON for retrieval from storage
  factory BleDevice.fromJson(Map<String, dynamic> json) {
    return BleDevice(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      services: List<String>.from(json['services'] ?? []),
      lastConnected: json['lastConnected'] != null
          ? DateTime.parse(json['lastConnected'])
          : null,
      isSaved: true, // If it's in storage, it's saved
      metadata: json['metadata'] ?? {},
    );
  }

  @override
  String toString() {
    return 'BleDevice(id: $id, name: $name, type: $type, connected: $connected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BleDevice && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
