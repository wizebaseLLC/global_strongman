import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';

class WorkoutHistorySliverListTile extends StatelessWidget {
  const WorkoutHistorySliverListTile({
    required this.workingSet,
    required this.index,
    Key? key,
  }) : super(key: key);
  final WorkoutSetListItem workingSet;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: platformThemeData(
        context,
        material: (data) => data.scaffoldBackgroundColor,
        cupertino: (data) => data.scaffoldBackgroundColor,
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (workingSet.working_weight_lbs != null &&
                workingSet.working_weight_lbs! > 0)
              Text(
                "Weight - ${workingSet.working_weight_lbs?.toInt()} lbs (${workingSet.working_weight_kgs?.toInt()} kg)",
                style: platformThemeData(
                  context,
                  material: (data) => data.textTheme.bodyMedium,
                  cupertino: (data) =>
                      data.textTheme.textStyle.copyWith(fontSize: 14),
                ),
              ),
            if (workingSet.duration != null)
              Padding(
                padding: const EdgeInsets.only(top: kSpacing / 2),
                child: Text(
                  "Duration - ${workingSet.duration} (hh:mm:ss)",
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.bodyMedium,
                    cupertino: (data) =>
                        data.textTheme.textStyle.copyWith(fontSize: 14),
                  ),
                ),
              ),
            if (workingSet.reps != null && workingSet.reps! > 0)
              Padding(
                padding: const EdgeInsets.only(top: kSpacing / 2),
                child: Text(
                  "Reps - ${workingSet.reps}",
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.bodyMedium,
                    cupertino: (data) =>
                        data.textTheme.textStyle.copyWith(fontSize: 14),
                  ),
                ),
              ),
          ],
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: kPrimaryGradient,
          ),
          child: Center(
            child: Text(
              "$index",
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                cupertino: (data) =>
                    data.textTheme.textStyle.copyWith(fontSize: 14).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
