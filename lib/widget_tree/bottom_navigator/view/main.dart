import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/core/providers/activity_interace_provider.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
import 'package:global_strongman/widget_tree/bottom_navigator/model/screen_list.dart';
import 'package:provider/provider.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedTabIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PlatformAppBar? get appBar =>
      screens.map((e) => e.appBar).toList()[_selectedTabIndex];

  List<Widget> get childScreens => screens.map((e) => e.child).toList();

  @override
  Widget build(BuildContext context) {
    final BadgeCurrentValues badgeCurrentValues =
        context.read<BadgeCurrentValues>();

    final ActivityInterfaceProvider activityInterface =
        context.read<ActivityInterfaceProvider>();

    if (badgeCurrentValues.didRunAtleastOnce == false ||
        badgeCurrentValues.isDirty == true) {
      badgeCurrentValues.runSetMetrics();
    }

    if (activityInterface.didRunAtleastOnce == false ||
        activityInterface.isDirty == true) {
      activityInterface.createWorkoutInterface();
    }

    return PlatformScaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: IndexedStack(
          children: childScreens,
          index: _selectedTabIndex,
        ),
      ),
      appBar: appBar,
      bottomNavBar: PlatformNavBar(
        currentIndex: _selectedTabIndex,
        itemChanged: (index) => setState(() {
          _selectedTabIndex = index;
        }),
        material: (_, __) => MaterialNavBarData(
          fixedColor: Colors.blue,
        ),
        cupertino: (_, __) => CupertinoTabBarData(
          activeColor: CupertinoColors.activeBlue,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(PlatformIcons(context).home),
            label: "Home",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(PlatformIcons(context).playCircle),
          //   label: "Watch",
          // ),

          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartLine),
            label: "Activity",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/muscle.svg",
              color: Platform.isIOS
                  ? _selectedTabIndex == 2
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.systemGrey
                  : _selectedTabIndex == 2
                      ? Colors.blue
                      : Colors.grey.withOpacity(.2),
            ),
            label: "Workouts",
          ),
          BottomNavigationBarItem(
            icon: Icon(PlatformIcons(context).person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
