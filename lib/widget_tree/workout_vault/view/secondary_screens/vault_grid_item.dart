import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:focused_menu/modals.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/view_workout_screen.dart';
import 'package:focused_menu/focused_menu.dart';

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
        fullscreenDialog: true,
        builder: (context) => ViewWorkoutScreen(
          workout: workout,
          workout_id: workoutId,
        ),
      ));

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        border: Border.all(width: 2),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            workout.thumbnail!,
            maxWidth: 642,
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
      cupertino: (_, child, __) => CupertinoContextMenu(
        actions: <Widget>[
          CupertinoContextMenuAction(
            child: const Text('Review'),
            trailingIcon: CupertinoIcons.airplane,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoContextMenuAction(
            child: const Text('Schedule'),
            trailingIcon: CupertinoIcons.airplane,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoContextMenuAction(
            child: const Text('Build Routine'),
            trailingIcon: CupertinoIcons.airplane,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        child: CupertinoButton(
          child: Hero(
            tag: "${workout.name}_vault",
            child: child!,
          ),
          padding: EdgeInsets.zero,
          onPressed: () => _onTap(context),
        ),
      ),
      material: (_, child, __) => FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width * 0.50,
        blurSize: 5.0,
        menuItemExtent: 45,
        menuBoxDecoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: const Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Colors.black54,
        openWithTap: true, // Open Focused-Menu on Tap rather than Long Press
        menuOffset:
            10.0, // Offset value to show menuItem from the selected item
        bottomOffsetHeight:
            80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
        menuItems: [
          // Add Each FocusedMenuItem  for Menu Options
          FocusedMenuItem(
              backgroundColor: Theme.of(context).cardColor,
              title: const Text("View"),
              trailingIcon: const Icon(Icons.open_in_new),
              onPressed: () => _onTap(context)),
          FocusedMenuItem(
              backgroundColor: Theme.of(context).cardColor,
              title: const Text("Review"),
              trailingIcon: const Icon(Icons.rate_review),
              onPressed: () {}),
          FocusedMenuItem(
              backgroundColor: Theme.of(context).cardColor,
              title: const Text("Schedule"),
              trailingIcon: const Icon(Icons.calendar_today),
              onPressed: () {}),
          FocusedMenuItem(
              backgroundColor: Theme.of(context).cardColor,
              title: const Text(
                "Build Routine",
              ),
              trailingIcon: const Icon(
                Icons.emoji_people,
              ),
              onPressed: () {}),
        ],
        onPressed: () {},
        child: Hero(
          tag: "${workout.name}_vault",
          child: Container(
            decoration: _buildBoxDecoration(),
            child: child,
          ),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: Platform.isIOS ? _buildBoxDecoration() : null,
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: Text(
          workout.name!,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.subtitle1?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
            cupertino: (data) => data.textTheme.navTitleTextStyle.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
