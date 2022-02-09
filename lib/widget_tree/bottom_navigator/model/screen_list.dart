import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/main.dart';
import 'package:global_strongman/widget_tree/bottom_navigator/controller/tab_bar_screen.dart';
import 'package:global_strongman/widget_tree/home_screen/view/main.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/main.rs.dart';
import 'package:global_strongman/widget_tree/workout_vault/main.dart';

List<TabBarScreen> screens({required BuildContext context}) => [
      TabBarScreen(
        child: const HomeScreen(),
        appBar: buildStandardAppbar(
          title: "Global Strongman",
          context: context,
        ),
      ),
      TabBarScreen(
        child: const ActivityScreen(),
        appBar: buildStandardAppbar(
          title: "Activity",
          context: context,
        ),
      ),
      // TabBarScreen(
      //   child: Container(),
      // ),
      TabBarScreen(
        child: const WorkoutVaultScreen(),
        appBar: buildStandardAppbar(
          title: "Workout Vault",
          context: context,
        ),
      ),
      TabBarScreen(child: const ProfileScreen()),
    ];

PlatformAppBar buildStandardAppbar({
  required String title,
  required BuildContext context,
}) =>
    PlatformAppBar(
      title: Text(title),
      leading: Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset(
            "assets/images/global_strongman_logo.png",
            cacheWidth: 154,
          ),
        ),
      ),
      trailingActions: [
        PlatformIconButton(
          icon: Icon(
            PlatformIcons(context).addCircledOutline,
            size: 28,
          ),
          padding: EdgeInsets.zero,
          onPressed: () => FullScreenMenu.show(
            context,
            backgroundColor: platformThemeData(
              context,
              material: (data) => data.scaffoldBackgroundColor,
              cupertino: (data) => data.scaffoldBackgroundColor,
            ),
            items: [
              FSMenuItem(
                icon: const Icon(Icons.ac_unit, color: Colors.white),
                text: Text(
                  'Post',
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.subtitle1,
                    cupertino: (data) => data.textTheme.textStyle,
                  ),
                ),
                gradient: orangeGradient,
                onTap: () {
                  FullScreenMenu.hide();
                },
              ),
              FSMenuItem(
                icon: const Icon(Icons.wb_sunny, color: Colors.white),
                text: Text(
                  "Routine",
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.subtitle1,
                    cupertino: (data) => data.textTheme.textStyle,
                  ),
                ),
                gradient: blueGradient,
                onTap: () {
                  FullScreenMenu.hide();
                },
              ),
              FSMenuItem(
                icon: const Icon(Icons.wb_sunny, color: Colors.white),
                text: Text(
                  "Schedule",
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.subtitle1,
                    cupertino: (data) => data.textTheme.textStyle,
                  ),
                ),
                gradient: greenGradient,
                onTap: () {
                  FullScreenMenu.hide();
                },
              ),
              FSMenuItem(
                icon: const Icon(Icons.wb_sunny, color: Colors.white),
                text: Text(
                  "Progress Gallery",
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.subtitle1,
                    cupertino: (data) => data.textTheme.textStyle,
                  ),
                ),
                gradient: redGradient,
                onTap: () {
                  FullScreenMenu.hide();
                },
              ),
            ],
          ),
        )
      ],
    );
