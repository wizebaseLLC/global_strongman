import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/activity_calendar/activity_calendar.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/workout_set_count/workout_sets_card.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/workoutsCategories/workoutsCategories.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/description.dart';

class ActivityBody extends StatelessWidget {
  const ActivityBody({
    Key? key,
    required this.activityInterface,
    required this.selectedDay,
    required this.setState,
  }) : super(key: key);
  final ActivityInterface activityInterface;
  final DateTime selectedDay;
  final Function(DateTime pickedDate) setState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          Column(
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
                selectedDay: selectedDay,
                setActivityScreenState: setState,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
