import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';

class VaultGridItem extends StatelessWidget {
  const VaultGridItem({
    Key? key,
    required this.workout,
  }) : super(key: key);

  final FirebaseProgramWorkouts workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            workout.thumbnail!,
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Text(
        workout.name!,
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.subtitle1?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
          cupertino: (data) => data.textTheme.navTitleTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
