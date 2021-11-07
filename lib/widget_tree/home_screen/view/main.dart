import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/main.rs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  // Screens for the bottom tab bars.
  final List<Widget> _screens = [
    const ProfileScreen(),
    const ProfileScreen(),
    const ProfileScreen(),
    const ProfileScreen(),
    const ProfileScreen(),
  ];

  // Display the Appbar or not.
  // TODO: Make this a List<PlatformAppBar>
  final List<bool> _showsScreenAppBar = [
    ProfileScreen.usesAppbar,
    ProfileScreen.usesAppbar,
    ProfileScreen.usesAppbar,
    ProfileScreen.usesAppbar,
    ProfileScreen.usesAppbar,
  ];

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: _screens[_selectedTabIndex],
      ),
      appBar: _showsScreenAppBar[_selectedTabIndex] == true
          ? PlatformAppBar(
              title: const Text("hi"),
            )
          : null,
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
          activeColor: Colors.blue,
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
          BottomNavigationBarItem(
            icon: Icon(PlatformIcons(context).addCircled),
            label: "Add",
          ),
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
