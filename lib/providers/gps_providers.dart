// lib/providers/gps_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/gps_service.dart';

part 'gps_providers.g.dart';

// This is the primary file that partners with the generated code
// We've modified our approach to avoid using the automatically generated code
// with internal APIs, instead providing a custom implementation in gps_providers.g.dart

/// GPS Service and Controller API
/// This file defines providers to interact with GPS functionality:
/// - Access GPS status (enabled, active, etc.)
/// - Track position updates
/// - Configure GPS settings
/// - Manage GPS tracking sessions
/// 
/// The implementation details are in the gps_providers.g.dart part file.

// The rest of this file is intentionally left empty since we're using a custom
// implementation in the part file rather than the auto-generated code.
// 
// This structure maintains compatibility with the existing codebase while
// avoiding the issues with internal provider APIs.