import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/providers/activity_interace_provider.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/activity_body.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/activity_calendar/workout_list_by_day.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  DateTime selectedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final ActivityInterfaceProvider activityInterfaceProvider =
        context.watch<ActivityInterfaceProvider>();

    final ActivityInterface activityInterface = ActivityInterface(
      totalWorkouts: activityInterfaceProvider.totalWorkouts,
      activeDays: activityInterfaceProvider.activeDays,
      programsComplete: activityInterfaceProvider.programsComplete,
      trophiesEarned: activityInterfaceProvider.trophiesEarned,
      completedWorkouts: activityInterfaceProvider.completedWorkouts,
    );
    return SafeArea(
      child: PlatformWidgetBuilder(
        cupertino: (_, child, __) => child,
        material: (_, child, __) => RefreshIndicator(
          backgroundColor: kPrimaryColor,
          color: Colors.white,
          child: child!,
          onRefresh: () async {
            HapticFeedback.mediumImpact();
            context.read<BadgeCurrentValues>().runSetMetrics();
            context.read<ActivityInterfaceProvider>().createWorkoutInterface();
          },
        ),
        child: CustomScrollView(
          slivers: [
            if (Platform.isIOS)
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  HapticFeedback.mediumImpact();
                  context.read<BadgeCurrentValues>().runSetMetrics();
                  context
                      .read<ActivityInterfaceProvider>()
                      .createWorkoutInterface();
                },
              ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ActivityBody(
                    activityInterface: activityInterface,
                    selectedDay: selectedDay,
                    setState: (pickedDate) => setState(
                      () {
                        selectedDay = pickedDate;
                      },
                    ),
                  ),
                ],
              ),
            ),
            WorkoutListByDay(
              selectedDate: selectedDay,
            ),
          ],
        ),
      ),
    );
  }
}
