// lib/providers/gps_providers_extended.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for GPS connection status (for UI purposes)
final gpsConnectedProvider = StateProvider<bool>((ref) => false);
