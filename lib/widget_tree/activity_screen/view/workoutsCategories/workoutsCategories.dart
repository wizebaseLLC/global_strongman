import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/filtered_workout_screen/filtered_workout_screen.dart';
import 'package:global_strongman/widget_tree/home_screen/view/filter_icon.dart';

class WorkoutsCompletedByCategory extends StatelessWidget {
  const WorkoutsCompletedByCategory({
    required this.activityInterface,
    Key? key,
  }) : super(key: key);
  final ActivityInterface activityInterface;

  WorkoutCategoryCount _buildWorkoutCategoryCount() => WorkoutCategoryCount(
        cardio: _filterCategoryCount("cardio"),
        rehab: _filterCategoryCount("rehab"),
        strength: _filterCategoryCount("strength"),
        strongman: _filterCategoryCount("strongman"),
      );

  int _filterCategoryCount(String category) =>
      activityInterface.completedWorkouts
          .where((element) => element.categories!.contains(category))
          .length;

  Query<FirebaseUserWorkoutComplete> _getFilteredWorkouts(
    String category,
    String? _user,
  ) {
    return FirebaseUserWorkoutComplete()
        .getCollectionReference(user: _user)
        .where("categories", arrayContains: category)
        .orderBy("created_on", descending: true);
  }

  void _onCategoryPress({
    required String category,
    required String title,
    required String? user,
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (_) => FilteredWorkoutScreen(
          title: title,
          query: _getFilteredWorkouts(category, user),
          previousPageTitle: "Activity",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFilterIconRow(context);
  }

  Widget _buildFilterIconRow(BuildContext context) {
    final UserProvider _user = context.watch<UserProvider>();
    final WorkoutCategoryCount _workoutCategoryCount =
        _buildWorkoutCategoryCount();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FilterIcon(
            count: _workoutCategoryCount.cardio,
            context: context,
            shouldNotUsePadding: Platform.isIOS,
            name: "Cardio",
            selected: true,
            backgroundColor: Colors.redAccent.shade200.withOpacity(.3),
            icon: SvgPicture.asset(
              "assets/images/pulse.svg",
              color: Colors.red.shade700,
            ),
            toggleState: () => _onCategoryPress(
              title: "Cardio",
              category: "cardio",
              user: _user.authUser?.email,
              context: context,
            ),
          ),
        ),
        Expanded(
          child: FilterIcon(
            count: _workoutCategoryCount.strength,
            context: context,
            shouldNotUsePadding: Platform.isIOS,
            name: "Strength",
            selected: true,
            backgroundColor: Colors.purpleAccent.shade200.withOpacity(.3),
            icon: SvgPicture.asset(
              "assets/images/muscle.svg",
              color: Colors.purpleAccent.shade700,
            ),
            toggleState: () => _onCategoryPress(
              category: "strength",
              title: "Strength",
              user: _user.authUser?.email,
              context: context,
            ),
          ),
        ),
        Expanded(
          child: FilterIcon(
            count: _workoutCategoryCount.rehab,
            context: context,
            shouldNotUsePadding: Platform.isIOS,
            backgroundColor: Colors.tealAccent.shade200.withOpacity(.3),
            selected: true,
            name: "Rehab",
            icon: SvgPicture.asset(
              "assets/images/pulse 2.svg",
              color: Colors.tealAccent.shade700,
            ),
            toggleState: () => _onCategoryPress(
              category: "rehab",
              title: "Rehab",
              user: _user.authUser?.email,
              context: context,
            ),
          ),
        ),
        Expanded(
          child: FilterIcon(
            count: _workoutCategoryCount.strongman,
            shouldNotUsePadding: Platform.isIOS,
            backgroundColor: Colors.blueAccent.shade200.withOpacity(.3),
            context: context,
            name: "Strongman",
            selected: true,
            icon: SvgPicture.asset(
              "assets/images/weightlifting.svg",
              color: Colors.blueAccent.shade700,
            ),
            toggleState: () => _onCategoryPress(
              category: "strongman",
              title: "Strongman",
              user: _user.authUser?.email,
              context: context,
            ),
          ),
        ),
      ],
    );
  }
}

class WorkoutCategoryCount {
  final int cardio;
  final int strength;
  final int rehab;
  final int strongman;

  WorkoutCategoryCount(
      {required this.cardio,
      required this.strength,
      required this.rehab,
      required this.strongman});
}
