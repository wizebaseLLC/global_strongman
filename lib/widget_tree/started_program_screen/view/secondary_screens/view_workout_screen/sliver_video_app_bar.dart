import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/home_screen/view/shaded_image.dart';
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
          StretchMode.fadeTitle,
          StretchMode.zoomBackground,
        ],
        background: workout.short_video_url != null
            ? WorkoutVideo(
                workout: workout,
              )
            : ShadedImage(
                heroId: "${workout.name}_vault",
                image: CachedNetworkImage(
                  imageUrl: workout.thumbnail!,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
