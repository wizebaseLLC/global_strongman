import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/widget_tree/home_screen/controller/tab_bar_screen.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/main.rs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  // Screens for the bottom tab bars.
  final List<TabBarScreen> _screens = [
    TabBarScreen(child: Container()),
    TabBarScreen(child: Container()),
    TabBarScreen(child: Container()),
    TabBarScreen(child: const ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: IndexedStack(
          children: _screens.map((e) => e.child).toList(),
          index: _selectedTabIndex,
        ),
      ),
      appBar: _screens.map((e) => e.appBar).toList()[_selectedTabIndex],
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
