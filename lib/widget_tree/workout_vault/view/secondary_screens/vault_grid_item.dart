import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/showPlatformActionSheet.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/view_workout_screen.dart';

class VaultGridItem extends StatelessWidget {
  const VaultGridItem({
    Key? key,
    required this.workout,
    required this.workoutId,
  }) : super(key: key);

  final String workoutId;
  final FirebaseProgramWorkouts workout;

  void _onTap(BuildContext context) => Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => ViewWorkoutScreen(
          workout: workout,
          workout_id: workoutId,
        ),
      ));

  void _onLongTap(BuildContext context) => showPlatformActionSheet(
        context: context,
        actionSheetData: PlatformActionSheet(
          title: "Add Progress Photo",
          model: [
            ActionSheetModel(
              title: "Add to Calendar",
              textStyle: TextStyle(
                color:
                    Platform.isIOS ? CupertinoColors.activeBlue : Colors.blue,
              ),
              onTap: () {},
              iconMaterial: const Icon(
                Icons.calendar_today,
              ),
            ),
            ActionSheetModel(
              title: "Add to Routine",
              textStyle: TextStyle(
                color:
                    Platform.isIOS ? CupertinoColors.activeBlue : Colors.blue,
              ),
              onTap: () {},
              iconMaterial: const Icon(
                Icons.emoji_people,
              ),
            ),
          ],
        ),
      );

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
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
      );
  @override
  Widget build(BuildContext context) {
    return PlatformWidgetBuilder(
      cupertino: (_, child, __) => GestureDetector(
        onLongPress: () => _onLongTap(context),
        child: CupertinoButton(
          child: child!,
          padding: EdgeInsets.zero,
          onPressed: () => _onTap(context),
        ),
      ),
      material: (_, child, __) => Material(
        child: Ink(
          decoration: _buildBoxDecoration(),
          child: InkWell(
            splashColor: kPrimaryColor.withOpacity(.5),
            onTap: () => _onTap(context),
            onLongPress: () => _onLongTap(context),
            child: child,
          ),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: Platform.isIOS ? _buildBoxDecoration() : null,
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
      ),
    );
  }
}
