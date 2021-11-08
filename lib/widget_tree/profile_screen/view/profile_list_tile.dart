import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.subtitle1,
            cupertino: (data) => data.textTheme.navTitleTextStyle,
          )),
      trailing: Icon(
        PlatformIcons(context).rightChevron,
        color: Colors.grey,
      ),
      tileColor: platformThemeData(
        context,
        material: (data) => data.scaffoldBackgroundColor,
        cupertino: (data) => data.scaffoldBackgroundColor,
      ),
      onTap: onTap,
    );
  }
}
