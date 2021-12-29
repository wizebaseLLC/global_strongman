import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';

class WorkoutDescription extends StatelessWidget {
  const WorkoutDescription(
      {required this.title, required this.subtitle, Key? key})
      : super(key: key);

  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: platformThemeData(
              context,
              material: (data) =>
                  data.textTheme.headline6?.copyWith(fontSize: 20),
              cupertino: (data) =>
                  data.textTheme.navTitleTextStyle.copyWith(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: kSpacing,
          ),
          Text(
            subtitle,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1?.copyWith(
                fontSize: 14,
                color: Colors.white70,
              ),
              cupertino: (data) => data.textTheme.textStyle.copyWith(
                fontSize: 14,
                color: CupertinoColors.systemGrey3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
