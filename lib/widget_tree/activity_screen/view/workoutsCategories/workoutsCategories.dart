import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
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

  @override
  Widget build(BuildContext context) {
    return _buildFilterIconRow(context);
  }

  Widget _buildFilterIconRow(BuildContext context) {
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
            icon: Icon(
              PlatformIcons(context).heartSolid,
              color: Colors.red.shade700,
              size: 25,
            ),
            toggleState: null,
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
            icon: FaIcon(
              FontAwesomeIcons.dumbbell,
              color: Colors.purpleAccent.shade700,
              size: 25,
            ),
            toggleState: null,
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
            icon: Icon(
              PlatformIcons(context).clockSolid,
              color: Colors.tealAccent.shade700,
              size: 25,
            ),
            toggleState: null,
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
            icon: Icon(
              PlatformIcons(context).heartSolid,
              color: Colors.blueAccent.shade700,
              size: 25,
            ),
            toggleState: null,
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
