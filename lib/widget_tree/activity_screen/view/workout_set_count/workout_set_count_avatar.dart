import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';

class WorkoutSetCountAvatar extends StatelessWidget {
  const WorkoutSetCountAvatar({
    Key? key,
    required this.activityInterface,
  }) : super(key: key);

  final ActivityInterface activityInterface;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color(0XFFFE7762),
      radius: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${activityInterface.totalWorkouts}",
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
              cupertino: (data) => data.textTheme.navTitleTextStyle
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 36),
            ),
          ),
          Text(
            "Total workouts",
            style: platformThemeData(
              context,
              material: (data) =>
                  data.textTheme.bodyText1?.copyWith(fontSize: 14),
              cupertino: (data) =>
                  data.textTheme.textStyle.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
