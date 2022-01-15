import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/filtered_workout_screen/filtered_workout_screen.dart';

class WorkoutSetCountAvatar extends StatelessWidget {
  const WorkoutSetCountAvatar({
    Key? key,
    required this.activityInterface,
  }) : super(key: key);

  final ActivityInterface activityInterface;

  Query<FirebaseUserWorkoutComplete> _getWorkouts(String? _user) {
    return FirebaseUserWorkoutComplete()
        .getCollectionReference(user: _user)
        .orderBy("created_on", descending: true);
  }

  void _onCategoryPress({
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
          query: _getWorkouts(user),
          key: GlobalKey(),
          previousPageTitle: "Activity",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = context.watch<UserProvider>();
    return PlatformTextButton(
      onPressed: () => _onCategoryPress(
        title: "My Workouts",
        user: _user.authUser?.email,
        context: context,
      ),
      child: CircleAvatar(
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
      ),
    );
  }
}
