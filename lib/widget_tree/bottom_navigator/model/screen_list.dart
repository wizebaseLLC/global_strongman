import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/main.dart';
import 'package:global_strongman/widget_tree/bottom_navigator/controller/tab_bar_screen.dart';
import 'package:global_strongman/widget_tree/home_screen/view/main.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/main.rs.dart';

final List<TabBarScreen> screens = [
  TabBarScreen(
    child: const HomeScreen(),
    appBar: buildStandardAppbar(title: "Global Strongman"),
  ),
  //#TODO Add a Watch/Add content screen
  TabBarScreen(
    child: const ActivityScreen(),
    appBar: buildStandardAppbar(title: "Activity"),
  ),

  TabBarScreen(
    child: Container(),
    appBar: buildStandardAppbar(title: "Workout Catalog"),
  ),
  TabBarScreen(child: const ProfileScreen()),
];

PlatformAppBar buildStandardAppbar({required String title}) => PlatformAppBar(
      title: Text(title),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset(
          "assets/images/global_strongman_logo.png",
          cacheWidth: 154,
        ),
      ),
    );
