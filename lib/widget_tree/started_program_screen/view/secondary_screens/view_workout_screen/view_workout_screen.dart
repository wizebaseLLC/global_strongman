import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/description.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/sliver_video_app_bar.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/workout_title.dart';

class ViewWorkoutScreen extends StatelessWidget {
  const ViewWorkoutScreen({required this.workout, Key? key}) : super(key: key);

  final FirebaseProgramWorkouts workout;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverVideoAppBar(workout: workout),
            SliverList(
              delegate: SliverChildListDelegate([
                WorkoutTitle(workout: workout),
                const SizedBox(height: kSpacing * 6),
                WorkoutDescription(
                  title: "Training Description",
                  subtitle: workout.description!,
                ),
                const SizedBox(height: kSpacing * 4),
                if (workout.weekly_increment != null)
                  WorkoutDescription(
                    title: "Progression",
                    subtitle:
                        "Increase the weight by ${workout.weekly_increment!}lbs (${(workout.weekly_increment! / 2.2046).toStringAsFixed(1)}kg) weekly",
                  ),
              ]),
            )
            //  WorkoutVideo(workout: workout),
          ],
        ),
      ),
    );
  }
}
