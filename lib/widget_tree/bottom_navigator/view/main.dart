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
  int _selectedTabIndex = 0;
  PlatformTabController tabController = PlatformTabController(initialIndex: 0);

  List<PlatformAppBar?> appBar({required BuildContext context}) =>
      screens(context: context).map((e) => e.appBar).toList();

  List<Widget> childScreens({required BuildContext context}) =>
      screens(context: context).map((e) => e.child).toList();

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
          children: childScreens(context: context),
          index: index,
        ),
      ),
      appBarBuilder: (_, index) => appBar(context: context)[index],
      itemChanged: (index) {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      cupertino: (context, platform) => CupertinoTabScaffoldData(),
      material: (context, platform) => MaterialTabScaffoldData(),
      materialTabs: (context, platform) => MaterialNavBarData(
        fixedColor: Colors.blue,
      ),
      items: [
        BottomNavigationBarItem(
          backgroundColor: Platform.isAndroid ? Colors.grey.shade900 : null,
          icon: Icon(
            PlatformIcons(context).home,
            color: _getIconColor(0),
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          backgroundColor: Platform.isAndroid ? Colors.grey.shade900 : null,
          icon: FaIcon(
            FontAwesomeIcons.chartLine,
            color: _getIconColor(1),
          ),
          label: "Activity",
        ),
        BottomNavigationBarItem(
          backgroundColor: Platform.isAndroid ? Colors.grey.shade900 : null,
          icon: SvgPicture.asset("assets/images/muscle.svg",
              color: _getIconColor(2)),
          label: "Workouts",
        ),
        BottomNavigationBarItem(
          backgroundColor: Platform.isAndroid ? Colors.grey.shade900 : null,
          icon: Icon(
            PlatformIcons(context).person,
            color: _getIconColor(3),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  Color _getIconColor(int index) => Platform.isIOS
      ? _selectedTabIndex == index
          ? CupertinoColors.activeBlue
          : CupertinoColors.systemGrey
      : _selectedTabIndex == index
          ? Colors.blue
          : Colors.grey.withOpacity(.2);
}
