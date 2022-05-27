import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_list_tile.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({
    Key? key,
    required this.header,
    required this.listTiles,
  }) : super(key: key);

  final String header;
  final List<ProfileListTile> listTiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: kSpacing),
            child: Text(
              header,
              style: platformThemeData(
                context,
                material: (data) =>
                    data.textTheme.headline6?.copyWith(color: Colors.grey),
                cupertino: (data) =>
                    data.textTheme.tabLabelTextStyle.copyWith(fontSize: 20),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: kSpacing,
        ),
        Material(
          color: platformThemeData(
            context,
            material: (data) => data.scaffoldBackgroundColor,
            cupertino: (data) => data.scaffoldBackgroundColor,
          ),
          child: SizedBox(
            height: 58.toDouble() * listTiles.length,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: listTiles,
            ),
          ),
        )
      ],
    );
  }
}
