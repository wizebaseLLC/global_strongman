import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user != null) {
          WidgetsBinding.instance?.addPostFrameCallback(
            (_) {
              Provider.of<ActivityInterfaceProvider>(context, listen: false)
                  .createWorkoutInterface();
              Provider.of<BadgeCurrentValues>(context, listen: false)
                  .runSetMetrics();
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          // BottomNavigationBarItem(
          //   icon: Icon(PlatformIcons(context).addCircled),
          //   label: "Add",
          // ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartLine),
            label: "Activity",
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
