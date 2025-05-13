import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_state.dart';

/// Provider to track the current state of the activity
final activityStateProvider =
    StateProvider<ActivityState>((ref) => ActivityState.idle);
