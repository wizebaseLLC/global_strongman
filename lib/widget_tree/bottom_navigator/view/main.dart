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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 1;
  PlatformTabController tabController = PlatformTabController(initialIndex: 1);

  List<PlatformAppBar?> get appBar => screens.map((e) => e.appBar).toList();

  final List<Widget> childScreens = screens.map((e) => e.child).toList();

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

    return PlatformTabScaffold(
      tabController: tabController,
      key: _scaffoldKey,
      bodyBuilder: (context, index) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: IndexedStack(
          children: childScreens,
          index: index,
        ),
      ),
      appBarBuilder: (_, index) => appBar[index],
      itemChanged: (index) => setState(() {
        _selectedTabIndex = index;
      }),
      iosContentPadding: true,
      iosContentBottomPadding: true,
      cupertino: (context, platform) => CupertinoTabScaffoldData(),
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
    );
  }
}
