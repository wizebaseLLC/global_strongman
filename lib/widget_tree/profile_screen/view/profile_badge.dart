import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';

class ProfileBadge extends StatelessWidget {
  const ProfileBadge({
    Key? key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final Widget icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: PlatformIconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: icon,
          ),
        ),
        const SizedBox(
          height: kSpacing,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.headline6,
            cupertino: (data) => data.textTheme.navTitleTextStyle.copyWith(fontSize: 20),
          ),
        ),
        const SizedBox(
          height: kSpacing,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.bodyText2?.copyWith(
              color: Colors.grey,
            ),
            cupertino: (data) => data.textTheme.navTitleTextStyle.copyWith(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
