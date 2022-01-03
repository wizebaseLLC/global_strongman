import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class WorkoutSetsListTile extends StatelessWidget {
  const WorkoutSetsListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(
        title,
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.bodyText1?.copyWith(fontSize: 14),
          cupertino: (data) => data.textTheme.textStyle.copyWith(fontSize: 14),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          subtitle,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.bodyText2?.copyWith(
              fontSize: 12,
              color: Colors.white70,
            ),
            cupertino: (data) => data.textTheme.textStyle.copyWith(
              fontSize: 12,
              color: CupertinoColors.systemGrey3,
            ),
          ),
        ),
      ),
      leading: icon,
    );
  }
}
