import 'dart:convert';

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

  /// Device type classification
  static const String TYPE_HEART_RATE = 'heart_rate';
  static const String TYPE_POWER = 'power';
  static const String TYPE_CADENCE = 'cadence';
  static const String TYPE_COMBINED =
      'combined'; // Multiple sensor types in one
  static const String TYPE_UNKNOWN = 'unknown';

  /// Determine device type based on services
  static String determineDeviceType(List<String> services) {
    // Common service UUIDs for fitness devices
    const String HEART_RATE_SERVICE = '0000180d-0000-1000-8000-00805f9b34fb';
    const String CYCLING_POWER_SERVICE = '00001818-0000-1000-8000-00805f9b34fb';
    const String RUNNING_SPEED_CADENCE_SERVICE =
        '00001814-0000-1000-8000-00805f9b34fb';
    const String CYCLING_SPEED_CADENCE_SERVICE =
        '00001816-0000-1000-8000-00805f9b34fb';

    // Stryd often has a custom service
    const String STRYD_SERVICE = 'fb005c80-02e7-f387-1cad-8acd2d8df0c8';

    bool hasHeartRate = services.contains(HEART_RATE_SERVICE);
    bool hasPower = services.contains(CYCLING_POWER_SERVICE) ||
        services.contains(STRYD_SERVICE);
    bool hasCadence = services.contains(RUNNING_SPEED_CADENCE_SERVICE) ||
        services.contains(CYCLING_SPEED_CADENCE_SERVICE);

    // Determine type based on available services
    if (hasHeartRate && (hasPower || hasCadence)) {
      return TYPE_COMBINED;
    } else if (hasHeartRate) {
      return TYPE_HEART_RATE;
    } else if (hasPower) {
      return TYPE_POWER;
    } else if (hasCadence) {
      return TYPE_CADENCE;
    } else {
      return TYPE_UNKNOWN;
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
