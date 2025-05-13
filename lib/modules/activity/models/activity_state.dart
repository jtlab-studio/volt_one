/// Represents the different states of an activity tracking session
enum ActivityState {
  /// Initial state, no activity in progress
  idle,

  /// An activity is in progress and actively recording data
  active,

  /// An activity is in progress but temporarily paused
  paused,

  /// An activity has been completed and is ready for review/saving
  completed
}
