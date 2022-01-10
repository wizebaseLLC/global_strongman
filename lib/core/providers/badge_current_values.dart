import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/core/controller/badges_controller.dart';
import 'package:global_strongman/core/model/badge.dart';
import 'package:global_strongman/core/model/firebase_user.dart';

/// Provider class with all the data and logic required to build the badge screens.
class BadgeCurrentValues with ChangeNotifier {
  int _completedBadgeCount = 0;
  int get completedBadgeCount => _completedBadgeCount;

  int _totalBadgeCount = 0;
  int get totalBadgeCount => _totalBadgeCount;

  int _totalActiveDays = 0;
  int get totalActiveDays => _totalActiveDays;

  int _totalWorkoutsDone = 0;
  int get totalWorkoutsDone => _totalWorkoutsDone;
  // List<Badge> _workoutCountList = [];
  // List<Badge> get workoutCountList => _workoutCountList;

  /// Check if this provider ran atleast once
  bool _didRunAtleastOnce = false;
  bool get didRunAtleastOnce => _didRunAtleastOnce;

  /// Check if this provider should run again
  bool _isDirty = false;
  bool get isDirty => _isDirty;

  void setIsDirty() {
    _isDirty = true;
  }

  List<Badge> getWorkoutCountList() => [
        completed1Workouts,
        completed10Workouts,
        completed50Workouts,
        completed100Workouts,
        completed500Workouts,
        completed1000Workouts,
      ];
  List<Badge> getStrengthList() => [
        completed10StrengthWorkouts,
        completed50StrengthWorkouts,
        completed100StrengthWorkouts,
        completed500StrengthWorkouts,
        completed1000StrengthWorkouts,
      ];
  List<Badge> getCardioList() => [
        completed10CardioWorkouts,
        completed50CardioWorkouts,
        completed100CardioWorkouts,
        completed500CardioWorkouts,
        completed1000CardioWorkouts,
      ];
  List<Badge> getRehabList() => [
        completed10RehabWorkouts,
        completed50RehabWorkouts,
        completed100RehabWorkouts,
        completed500RehabWorkouts,
        completed1000RehabWorkouts,
      ];
  List<Badge> getStrongmanList() => [
        completed10StrongmanWorkouts,
        completed50StrongmanWorkouts,
        completed100StrongmanWorkouts,
        completed500StrongmanWorkouts,
        completed1000StrongmanWorkouts,
      ];
  List<Badge> getBenchPressList() => [
        reach100lbBenchPress,
        reach200lbBenchPress,
        reach300lbBenchPress,
        reach400lbBenchPress,
        reach500lbBenchPress,
      ];
  List<Badge> getSquatList() => [
        reach100lbSquat,
        reach200lbSquat,
        reach300lbSquat,
        reach400lbSquat,
        reach500lbSquat,
      ];
  List<Badge> getDeadliftList() => [
        reach100lbDeadlift,
        reach200lbDeadlift,
        reach300lbDeadlift,
        reach400lbDeadlift,
        reach500lbDeadlift,
      ];
  List<Badge> getActiveDaysList() => [
        reach1ActiveDays,
        reach30ActiveDays,
        reach90ActiveDays,
        reach120ActiveDays,
        reach360ActiveDays,
      ];

  List<Badge> getAllSortedBadges() => [
        ...getActiveDaysList(),
        ...getWorkoutCountList(),
        ...getStrengthList(),
        ...getCardioList(),
        ...getRehabList(),
        ...getStrongmanList(),
        ...getBenchPressList(),
        ...getSquatList(),
        ...getDeadliftList(),
      ];
  Badge completed1Workouts = BadgesController.completeWorkouts(value: 1);

  Badge completed10Workouts = BadgesController.completeWorkouts(value: 10);

  Badge completed50Workouts = BadgesController.completeWorkouts(value: 50);

  Badge completed100Workouts = BadgesController.completeWorkouts(value: 100);

  Badge completed500Workouts = BadgesController.completeWorkouts(value: 500);

  Badge completed1000Workouts = BadgesController.completeWorkouts(value: 1000);

  Badge completed10StrengthWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 10,
    category: 'strength',
  );
  Badge completed50StrengthWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 50,
    category: 'strength',
  );
  Badge completed100StrengthWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 100,
    category: 'strength',
  );
  Badge completed500StrengthWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 500,
    category: 'strength',
  );
  Badge completed1000StrengthWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 1000,
    category: 'strength',
  );
  Badge completed10CardioWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 10,
    category: 'cardio',
  );
  Badge completed50CardioWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 50,
    category: 'cardio',
  );
  Badge completed100CardioWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 100,
    category: 'cardio',
  );
  Badge completed500CardioWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 500,
    category: 'cardio',
  );
  Badge completed1000CardioWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 1000,
    category: 'cardio',
  );
  Badge completed10RehabWorkouts = BadgesController.completeCategorizedWorkouts(
    value: 10,
    category: 'rehab',
  );
  Badge completed50RehabWorkouts = BadgesController.completeCategorizedWorkouts(
    value: 50,
    category: 'rehab',
  );
  Badge completed100RehabWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 100,
    category: 'rehab',
  );
  Badge completed500RehabWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 500,
    category: 'rehab',
  );
  Badge completed1000RehabWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 1000,
    category: 'rehab',
  );
  Badge completed10StrongmanWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 10,
    category: 'strongman',
  );
  Badge completed50StrongmanWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 50,
    category: 'strongman',
  );
  Badge completed100StrongmanWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 100,
    category: 'strongman',
  );
  Badge completed500StrongmanWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 500,
    category: 'strongman',
  );
  Badge completed1000StrongmanWorkouts =
      BadgesController.completeCategorizedWorkouts(
    value: 1000,
    category: 'strongman',
  );

  Badge reach100lbBenchPress = BadgesController.surpasSpecificWorkouts(
    value: 100,
    specificWorkout: "bench_press",
  );
  Badge reach200lbBenchPress = BadgesController.surpasSpecificWorkouts(
    value: 200,
    specificWorkout: "bench_press",
  );
  Badge reach300lbBenchPress = BadgesController.surpasSpecificWorkouts(
    value: 300,
    specificWorkout: "bench_press",
  );
  Badge reach400lbBenchPress = BadgesController.surpasSpecificWorkouts(
    value: 400,
    specificWorkout: "bench_press",
  );
  Badge reach500lbBenchPress = BadgesController.surpasSpecificWorkouts(
    value: 500,
    specificWorkout: "bench_press",
  );

  Badge reach100lbSquat = BadgesController.surpasSpecificWorkouts(
    value: 100,
    specificWorkout: "squat",
  );
  Badge reach200lbSquat = BadgesController.surpasSpecificWorkouts(
    value: 200,
    specificWorkout: "squat",
  );
  Badge reach300lbSquat = BadgesController.surpasSpecificWorkouts(
    value: 300,
    specificWorkout: "squat",
  );
  Badge reach400lbSquat = BadgesController.surpasSpecificWorkouts(
    value: 400,
    specificWorkout: "squat",
  );
  Badge reach500lbSquat = BadgesController.surpasSpecificWorkouts(
    value: 500,
    specificWorkout: "squat",
  );

  Badge reach100lbDeadlift = BadgesController.surpasSpecificWorkouts(
    value: 100,
    specificWorkout: "deadlift",
  );
  Badge reach200lbDeadlift = BadgesController.surpasSpecificWorkouts(
    value: 200,
    specificWorkout: "deadlift",
  );
  Badge reach300lbDeadlift = BadgesController.surpasSpecificWorkouts(
    value: 300,
    specificWorkout: "deadlift",
  );
  Badge reach400lbDeadlift = BadgesController.surpasSpecificWorkouts(
    value: 400,
    specificWorkout: "deadlift",
  );
  Badge reach500lbDeadlift = BadgesController.surpasSpecificWorkouts(
    value: 500,
    specificWorkout: "deadlift",
  );

  Badge reach1ActiveDays = BadgesController.activeDays(value: 1);
  Badge reach30ActiveDays = BadgesController.activeDays(value: 30);
  Badge reach90ActiveDays = BadgesController.activeDays(value: 90);
  Badge reach120ActiveDays = BadgesController.activeDays(value: 120);
  Badge reach360ActiveDays = BadgesController.activeDays(value: 360);

  Future<void> _setActiveDays() async {
    try {
      final int activeDays = await BadgesController().getActiveDays();

      reach1ActiveDays.currentValue = activeDays;
      reach30ActiveDays.currentValue = activeDays;
      reach90ActiveDays.currentValue = activeDays;
      reach120ActiveDays.currentValue = activeDays;
      reach360ActiveDays.currentValue = activeDays;

      for (final value in [
        reach1ActiveDays,
        reach30ActiveDays,
        reach90ActiveDays,
        reach120ActiveDays,
        reach360ActiveDays
      ]) {
        if (activeDays >= value.value) {
          value.meetsCriteria = true;
          _completedBadgeCount += 1;
        }
      }
    } catch (e) {
      Future.error(e);
    }
  }

  Future<void> _setMaxDeadlift() async {
    try {
      final int? value = await BadgesController()
          .getSpecificWorkoutMaxLift(workoutId: "deadlift");

      if (value != null) {
        reach100lbDeadlift.currentValue = value;
        reach200lbDeadlift.currentValue = value;
        reach300lbDeadlift.currentValue = value;
        reach400lbDeadlift.currentValue = value;
        reach500lbDeadlift.currentValue = value;

        for (final i in [
          reach100lbDeadlift,
          reach200lbDeadlift,
          reach300lbDeadlift,
          reach400lbDeadlift,
          reach500lbDeadlift
        ]) {
          if (value >= i.value) {
            i.meetsCriteria = true;
            _completedBadgeCount += 1;
          }
          _totalBadgeCount += 1;
        }
      }
    } catch (e) {
      Future.error(e);
    }
  }

  Future<void> _setMaxSquat() async {
    try {
      final int? value = await BadgesController()
          .getSpecificWorkoutMaxLift(workoutId: "squats");

      if (value != null) {
        reach100lbSquat.currentValue = value;
        reach200lbSquat.currentValue = value;
        reach300lbSquat.currentValue = value;
        reach400lbSquat.currentValue = value;
        reach500lbSquat.currentValue = value;

        for (final i in [
          reach100lbSquat,
          reach200lbSquat,
          reach300lbSquat,
          reach400lbSquat,
          reach500lbSquat
        ]) {
          if (value >= i.value) {
            i.meetsCriteria = true;
            _completedBadgeCount += 1;
          }
        }
        _totalBadgeCount += 1;
      }
    } catch (e) {
      Future.error(e);
    }
  }

  Future<void> _setMaxBenchPress() async {
    try {
      final int? value = await BadgesController()
          .getSpecificWorkoutMaxLift(workoutId: "bench_press");

      if (value != null) {
        reach100lbBenchPress.currentValue = value;
        reach200lbBenchPress.currentValue = value;
        reach300lbBenchPress.currentValue = value;
        reach400lbBenchPress.currentValue = value;
        reach500lbBenchPress.currentValue = value;

        for (final i in [
          reach100lbBenchPress,
          reach200lbBenchPress,
          reach300lbBenchPress,
          reach400lbBenchPress,
          reach500lbBenchPress
        ]) {
          if (value >= i.value) {
            i.meetsCriteria = true;
            _completedBadgeCount += 1;
          }
          _totalBadgeCount += 1;
        }
      }
    } catch (e) {
      Future.error(e);
    }
  }

  Future<void> _setWorkoutCounts() async {
    try {
      final DocumentSnapshot<FirebaseUser> userDocument =
          await BadgesController().getUserDocument();
      final int value = userDocument.data()?.completed_workouts ?? 0;

      completed1Workouts.currentValue = value;
      completed50Workouts.currentValue = value;
      completed100Workouts.currentValue = value;
      completed500Workouts.currentValue = value;
      completed1000Workouts.currentValue = value;

      for (final i in [
        completed1Workouts,
        completed50Workouts,
        completed100Workouts,
        completed500Workouts,
        completed1000Workouts
      ]) {
        if (value >= i.value) {
          i.meetsCriteria = true;
          _completedBadgeCount += 1;
        }
        _totalBadgeCount += 1;
      }

      _totalActiveDays = userDocument.data()?.active_days ?? 0;
      _totalWorkoutsDone = userDocument.data()?.completed_workouts ?? 0;
    } catch (e) {
      Future.error(e);
    }
  }

  Future<void> _setStrengthCategory() async {
    try {
      final DocumentSnapshot<FirebaseUser> userDocument =
          await BadgesController().getUserDocument();

      final FirebaseUser? user = userDocument.data();

      if (user != null) {
        completed10StrengthWorkouts.currentValue = user.strength ?? 0;
        completed50StrengthWorkouts.currentValue = user.strength ?? 0;
        completed100StrengthWorkouts.currentValue = user.strength ?? 0;
        completed500StrengthWorkouts.currentValue = user.strength ?? 0;
        completed1000StrengthWorkouts.currentValue = user.strength ?? 0;

        for (final i in [
          completed10StrengthWorkouts,
          completed50StrengthWorkouts,
          completed100StrengthWorkouts,
          completed500StrengthWorkouts,
          completed1000StrengthWorkouts
        ]) {
          if ((user.strength ?? 0) >= i.value) {
            i.meetsCriteria = true;
            _completedBadgeCount += 1;
          }
          _totalBadgeCount += 1;
        }

        completed10RehabWorkouts.currentValue = user.rehab ?? 0;
        completed50RehabWorkouts.currentValue = user.rehab ?? 0;
        completed100RehabWorkouts.currentValue = user.rehab ?? 0;
        completed500RehabWorkouts.currentValue = user.rehab ?? 0;
        completed1000RehabWorkouts.currentValue = user.rehab ?? 0;

        for (final i in [
          completed10RehabWorkouts,
          completed50RehabWorkouts,
          completed100RehabWorkouts,
          completed500RehabWorkouts,
          completed1000RehabWorkouts
        ]) {
          if ((user.rehab ?? 0) >= i.value) {
            i.meetsCriteria = true;
            _completedBadgeCount += 1;
          }
          _totalBadgeCount += 1;
        }

        completed10CardioWorkouts.currentValue = user.cardio ?? 0;
        completed50CardioWorkouts.currentValue = user.cardio ?? 0;
        completed100CardioWorkouts.currentValue = user.cardio ?? 0;
        completed500CardioWorkouts.currentValue = user.cardio ?? 0;
        completed1000CardioWorkouts.currentValue = user.cardio ?? 0;

        for (final i in [
          completed10CardioWorkouts,
          completed50CardioWorkouts,
          completed100CardioWorkouts,
          completed500CardioWorkouts,
          completed1000CardioWorkouts
        ]) {
          if ((user.cardio ?? 0) >= i.value) {
            i.meetsCriteria = true;
            _completedBadgeCount += 1;
          }
          _totalBadgeCount += 1;
        }

        completed10StrongmanWorkouts.currentValue = user.strongman ?? 0;
        completed50StrongmanWorkouts.currentValue = user.strongman ?? 0;
        completed100StrongmanWorkouts.currentValue = user.strongman ?? 0;
        completed500StrongmanWorkouts.currentValue = user.strongman ?? 0;
        completed1000StrongmanWorkouts.currentValue = user.strongman ?? 0;

        for (final i in [
          completed10StrongmanWorkouts,
          completed50StrongmanWorkouts,
          completed100StrongmanWorkouts,
          completed500StrongmanWorkouts,
          completed1000StrongmanWorkouts
        ]) {
          if ((user.strongman ?? 0) >= i.value) {
            i.meetsCriteria = true;
            _completedBadgeCount += 1;
          }
          _totalBadgeCount += 1;
        }
      }
    } catch (e) {
      Future.error(e);
    }
  }

  Future<void> runSetMetrics() async {
    _completedBadgeCount = 0;
    _totalBadgeCount = 0;
    _totalActiveDays = 0;
    _totalWorkoutsDone = 0;
    await Future.wait([
      _setStrengthCategory(),
      _setWorkoutCounts(),
      _setMaxBenchPress(),
      _setMaxSquat(),
      _setMaxDeadlift(),
      _setActiveDays(),
    ]);
    _didRunAtleastOnce = true;
    _isDirty = false;
    notifyListeners();
  }

  void resetToDefault() {
    reach1ActiveDays.currentValue = 0;
    reach30ActiveDays.currentValue = 0;
    reach90ActiveDays.currentValue = 0;
    reach120ActiveDays.currentValue = 0;
    reach360ActiveDays.currentValue = 0;

    reach100lbDeadlift.currentValue = 0;
    reach200lbDeadlift.currentValue = 0;
    reach300lbDeadlift.currentValue = 0;
    reach400lbDeadlift.currentValue = 0;
    reach500lbDeadlift.currentValue = 0;

    reach100lbSquat.currentValue = 0;
    reach200lbSquat.currentValue = 0;
    reach300lbSquat.currentValue = 0;
    reach400lbSquat.currentValue = 0;
    reach500lbSquat.currentValue = 0;

    reach100lbBenchPress.currentValue = 0;
    reach200lbBenchPress.currentValue = 0;
    reach300lbBenchPress.currentValue = 0;
    reach400lbBenchPress.currentValue = 0;
    reach500lbBenchPress.currentValue = 0;

    completed1Workouts.currentValue = 0;
    completed50Workouts.currentValue = 0;
    completed100Workouts.currentValue = 0;
    completed500Workouts.currentValue = 0;
    completed1000Workouts.currentValue = 0;

    completed10StrengthWorkouts.currentValue = 0;
    completed50StrengthWorkouts.currentValue = 0;
    completed100StrengthWorkouts.currentValue = 0;
    completed500StrengthWorkouts.currentValue = 0;
    completed1000StrengthWorkouts.currentValue = 0;

    completed10RehabWorkouts.currentValue = 0;
    completed50RehabWorkouts.currentValue = 0;
    completed100RehabWorkouts.currentValue = 0;
    completed500RehabWorkouts.currentValue = 0;
    completed1000RehabWorkouts.currentValue = 0;

    completed10CardioWorkouts.currentValue = 0;
    completed50CardioWorkouts.currentValue = 0;
    completed100CardioWorkouts.currentValue = 0;
    completed500CardioWorkouts.currentValue = 0;
    completed1000CardioWorkouts.currentValue = 0;

    completed10StrongmanWorkouts.currentValue = 0;
    completed50StrongmanWorkouts.currentValue = 0;
    completed100StrongmanWorkouts.currentValue = 0;
    completed500StrongmanWorkouts.currentValue = 0;
    completed1000StrongmanWorkouts.currentValue = 0;

    _completedBadgeCount = 0;
    _totalBadgeCount = 0;
    _totalActiveDays = 0;
    _totalWorkoutsDone = 0;
    //_workoutCountList = [];

    _didRunAtleastOnce = false;
    _isDirty = false;
    notifyListeners();
  }
}
