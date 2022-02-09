import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:focused_menu/modals.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/filtered_workout_screen/filtered_workout_screen.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/view_workout_screen.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:provider/provider.dart';

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

  void _onHistoryPress({
    required String title,
    required String? user,
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (_) => FilteredWorkoutScreen(
          title: title,
          query: FirebaseUserWorkoutComplete()
              .getCollectionReference(user: user)
              .where("workout_id", isEqualTo: workoutId)
              .orderBy("created_on", descending: true),
          key: GlobalKey(),
          previousPageTitle: "Workouts",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidgetBuilder(
      cupertino: (context, child, __) => CupertinoContextMenu(
        actions: <Widget>[
          CupertinoContextMenuAction(
            child: const Text('Review'),
            trailingIcon: CupertinoIcons.airplane,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          CupertinoContextMenuAction(
            child: const Text('Schedule'),
            trailingIcon: CupertinoIcons.airplane,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          CupertinoContextMenuAction(
            child: const Text('Build Routine'),
            trailingIcon: CupertinoIcons.airplane,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          CupertinoContextMenuAction(
            child: const Text('View History'),
            trailingIcon: CupertinoIcons.clock,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              _onHistoryPress(
                context: context,
                title: "History",
                user: context.read<UserProvider>().authUser?.email,
              );
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
      material: (context, child, __) => FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width * 0.50,
        blurSize: 5.0,
        menuItemExtent: 45,
        menuBoxDecoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: const Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Colors.black54,
        openWithTap: false,
        menuOffset: 10.0,
        bottomOffsetHeight: 10.0,
        menuItems: [
          FocusedMenuItem(
            backgroundColor: Theme.of(context).cardColor,
            title: const Text("Review"),
            trailingIcon: const Icon(Icons.rate_review),
            onPressed: () {},
          ),
          FocusedMenuItem(
            backgroundColor: Theme.of(context).cardColor,
            title: const Text("Schedule"),
            trailingIcon: const Icon(Icons.calendar_today),
            onPressed: () {},
          ),
          FocusedMenuItem(
            backgroundColor: Theme.of(context).cardColor,
            title: const Text(
              "Build Routine",
            ),
            trailingIcon: const Icon(
              Icons.emoji_people,
            ),
            onPressed: () {},
          ),
          FocusedMenuItem(
            backgroundColor: Theme.of(context).cardColor,
            title: const Text(
              "View History",
            ),
            trailingIcon: Icon(
              PlatformIcons(context).clockSolid,
            ),
            onPressed: () => _onHistoryPress(
              context: context,
              title: "History",
              user: context.read<UserProvider>().authUser?.email,
            ),
          ),
        ],
        onPressed: () => _onTap(context),
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
