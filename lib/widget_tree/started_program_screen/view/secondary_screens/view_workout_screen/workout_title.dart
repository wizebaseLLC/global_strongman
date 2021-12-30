import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/expanded_workout_list.dart';

class WorkoutTitle extends StatelessWidget {
  const WorkoutTitle({required this.workout, Key? key}) : super(key: key);

  final FirebaseProgramWorkouts workout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          workout.name!,
          style: platformThemeData(
            context,
            material: (data) =>
                data.textTheme.headline6?.copyWith(fontSize: 24),
            cupertino: (data) =>
                data.textTheme.navTitleTextStyle.copyWith(fontSize: 24),
          ),
        ),
        Text(
          ExpandedWorkoutList.getSubtitle(workoutTile: workout)!,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.bodyText1?.copyWith(
              fontSize: 14,
              color: Colors.white70,
            ),
            cupertino: (data) => data.textTheme.textStyle.copyWith(
              fontSize: 14,
              color: CupertinoColors.systemGrey3,
            ),
          ),
        ),
      ],
    );
  }
}
