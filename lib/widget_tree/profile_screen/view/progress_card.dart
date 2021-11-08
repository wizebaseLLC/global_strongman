import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: kSpacing),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      color: platformThemeData(context, material: (data) => data.backgroundColor, cupertino: (data) => data.barBackgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.shade400,
              child: const Text(
                "4",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            title: Text(
              'Almost there, keep it up!',
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.subtitle1,
                cupertino: (data) => data.textTheme.navTitleTextStyle,
              ),
            ),
            subtitle: Text(
              '3500/4500 pts to reach level 5',
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.caption,
                cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
