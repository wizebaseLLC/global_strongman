import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/home_screen/view/shaded_image.dart';

class FilteredVaultAppBar extends StatelessWidget {
  const FilteredVaultAppBar({
    Key? key,
    required this.title,
    required this.heroId,
    required this.image,
  }) : super(key: key);

  final String title;
  final String heroId;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: platformThemeData(
        context,
        material: (data) => data.appBarTheme.backgroundColor,
        cupertino: (data) => data.barBackgroundColor,
      ),
      floating: true,
      expandedHeight: 200,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.subtitle1?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            cupertino: (data) => data.textTheme.navTitleTextStyle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
          StretchMode.zoomBackground,
        ],
        background: ShadedImage(
          heroId: heroId,
          image: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
