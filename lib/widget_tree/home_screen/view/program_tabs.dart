import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';

class ProgramTabs extends StatelessWidget {
  const ProgramTabs({
    Key? key,
    required this.setTab,
    required this.currentTab,
  }) : super(key: key);

  final void Function(int? value) setTab;
  final int currentTab;

  TextStyle cupertinoSegmentTextColor(BuildContext context) =>
      CupertinoTheme.of(context)
          .textTheme
          .actionTextStyle
          .copyWith(color: CupertinoColors.white, fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PlatformWidget(
        cupertino: (_, __) => CupertinoSlidingSegmentedControl(
            groupValue: currentTab,
            thumbColor: kPrimaryColor,
            children: <int, Widget>{
              0: Text(
                "Overview",
                style: cupertinoSegmentTextColor(context),
              ),
              1: Text(
                "Workout list",
                style: cupertinoSegmentTextColor(context),
              ),
              2: Text(
                "Reviews",
                style: cupertinoSegmentTextColor(context),
              )
            },
            onValueChanged: setTab),
        material: (_, __) => DefaultTabController(
            length: 3,
            child: TabBar(
              onTap: setTab,
              indicatorColor: kPrimaryColor,
              tabs: const [
                Tab(
                  text: "Overview",
                ),
                Tab(text: "Workout list"),
                Tab(text: "Reviews"),
              ],
            )),
      ),
    );
  }
}
