import 'package:flutter/material.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/video.dart';

class SliverVideoAppBar extends StatelessWidget {
  const SliverVideoAppBar({required this.workout, Key? key}) : super(key: key);

  final FirebaseProgramWorkouts workout;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      expandedHeight: 250,
      stretch: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
          StretchMode.zoomBackground,
        ],
        background: WorkoutVideo(
          workout: workout,
        ),
      ),
    );
  }
}
