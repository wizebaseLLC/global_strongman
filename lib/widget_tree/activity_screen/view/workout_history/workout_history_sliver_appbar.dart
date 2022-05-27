import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/home_screen/view/shaded_image.dart';

class WorkoutHistorySliverAppBar extends StatelessWidget {
  const WorkoutHistorySliverAppBar({
    Key? key,
    required this.workout,
  }) : super(key: key);

  final FirebaseProgramWorkouts workout;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      expandedHeight: 200,
      stretch: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "${workout.name}",
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.subtitle1?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            cupertino: (data) => data.textTheme.navTitleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
          StretchMode.zoomBackground,
        ],
        background: ShadedImage(
          image: CachedNetworkImage(
            imageUrl: workout.thumbnail!,
            memCacheHeight: 741,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
