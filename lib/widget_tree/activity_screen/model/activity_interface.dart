import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';

class ActivityInterface {
  ActivityInterface({
    required this.totalWorkouts,
    required this.activeDays,
    required this.programsComplete,
    required this.trophiesEarned,
    required this.completedWorkouts,
  });

  final int? totalWorkouts;
  final int? activeDays;
  final int? programsComplete;
  final int? trophiesEarned;
  final List<FirebaseUserWorkoutComplete> completedWorkouts;
}
