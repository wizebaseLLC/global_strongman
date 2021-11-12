import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ShareOrAddButton extends StatelessWidget {
  const ShareOrAddButton({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.bodyText1?.copyWith(
              color: Colors.grey,
            ),
            cupertino: (data) => data.textTheme.textStyle.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
        PlatformIconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            icon,
            color: Colors.yellow.shade600,
            size: 25,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
