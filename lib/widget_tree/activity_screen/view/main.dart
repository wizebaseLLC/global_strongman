import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/providers/activity_interace_provider.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/activity_calendar/activity_calendar.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/workout_set_count/workout_sets_card.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/workoutsCategories/workoutsCategories.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/description.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
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
      child: RefreshIndicator(
        backgroundColor: kPrimaryColor,
        color: Colors.white,
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          context.read<BadgeCurrentValues>().runSetMetrics();
          context.read<ActivityInterfaceProvider>().createWorkoutInterface();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkoutSetsCard(
                  activityInterface: activityInterface,
                ),
                const SizedBox(
                  height: kSpacing * 4,
                ),
                const WorkoutDescription(
                  title: "Categories",
                  subtitle: "Workouts completed by category",
                ),
                WorkoutsCompletedByCategory(
                  activityInterface: activityInterface,
                ),
                const SizedBox(
                  height: kSpacing * 4,
                ),
                const WorkoutDescription(
                  title: "Workout Calendar",
                  subtitle: "",
                ),
                ActivityCalendar(
                  activityInterface: activityInterface,
                ),
                const SizedBox(
                  height: kSpacing * 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
