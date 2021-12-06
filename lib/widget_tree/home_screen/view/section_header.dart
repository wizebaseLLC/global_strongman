import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Row(
        children: [
          Text(
            text,
            style: platformThemeData(context,
                material: (data) =>
                    data.textTheme.subtitle1?.copyWith(color: Colors.white),
                cupertino: (data) => data.textTheme.navTitleTextStyle
                    .copyWith(color: CupertinoColors.systemGrey4)),
          )
        ],
      ),
    );
  }
}
