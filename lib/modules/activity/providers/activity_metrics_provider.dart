// lib/modules/activity/providers/activity_metrics_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/exercise_metrics.dart';

/// Provider for storing the current activity metrics
final activityMetricsProvider = StateProvider<ExerciseMetrics>((ref) {
  return const ExerciseMetrics();
});

/// Provider for storing track points of the current activity
final trackPointsProvider = StateProvider<List<Position>>((ref) {
  return [];
});

/// Provider for the currently selected location on the map
final selectedLocationProvider = StateProvider<Position?>((ref) {
  return null;
});

/// Provider for whether to auto-center the map on current location
final autoCenterMapProvider = StateProvider<bool>((ref) {
  return true;
});
