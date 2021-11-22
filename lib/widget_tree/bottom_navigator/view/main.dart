import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/widget_tree/bottom_navigator/model/screen_list.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: IndexedStack(
          children: screens.map((e) => e.child).toList(),
          index: _selectedTabIndex,
        ),
      ),
      appBar: screens.map((e) => e.appBar).toList()[_selectedTabIndex],
      bottomNavBar: PlatformNavBar(
        currentIndex: _selectedTabIndex,
        itemChanged: (index) => setState(
          () {
            _selectedTabIndex = index;
          },
        ),
        material: (_, __) => MaterialNavBarData(
          fixedColor: Colors.blue,
        ),
        cupertino: (_, __) => CupertinoTabBarData(
          activeColor: Colors.lightBlueAccent,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(PlatformIcons(context).home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(PlatformIcons(context).playCircle),
            label: "Watch",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(PlatformIcons(context).addCircled),
          //   label: "Add",
          // ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.dumbbell),
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
