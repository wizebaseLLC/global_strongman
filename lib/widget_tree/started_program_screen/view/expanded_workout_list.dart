import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/view_workout_screen.dart';

class ExpandedWorkoutList extends StatelessWidget {
  const ExpandedWorkoutList({required this.workoutTile, Key? key})
      : super(key: key);

  final FirebaseProgramWorkouts workoutTile;

  static String? getSubtitle({required FirebaseProgramWorkouts workoutTile}) {
    if (workoutTile.reps != null &&
        workoutTile.sets != null &&
        workoutTile.percent != null) {
      return "${workoutTile.sets} ${workoutTile.sets == 1 ? 'set' : 'sets'} of ${workoutTile.reps} reps at ${workoutTile.percent}% of your 1 rep max";
    } else if (workoutTile.reps != null && workoutTile.sets != null) {
      return "${workoutTile.sets} sets of ${workoutTile.reps} reps";
    } else if (workoutTile.reps == null && workoutTile.sets != null) {
      return "${workoutTile.sets} sets";
    } else if (workoutTile.minutes != null) {
      return "${workoutTile.minutes} minutes";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        workoutTile.name!,
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.bodyText1?.copyWith(
            color: Colors.white70,
          ),
          cupertino: (data) => data.textTheme.textStyle.copyWith(
            fontSize: 14,
            color: CupertinoColors.systemGrey3,
          ),
        ),
      ),
      subtitle: Text(
        getSubtitle(workoutTile: workoutTile) ?? "",
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.bodyText1?.copyWith(
            color: Colors.white70,
          ),
          cupertino: (data) => data.textTheme.textStyle.copyWith(
            fontSize: 14,
            color: CupertinoColors.systemGrey3,
          ),
        ),
      ),
      trailing: Icon(
        PlatformIcons(context).rightChevron,
        color: Colors.white60,
      ),
      dense: true,
      onTap: () => Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (_) => ViewWorkoutScreen(workout: workoutTile),
        ),
      ),
    );
  }
}
