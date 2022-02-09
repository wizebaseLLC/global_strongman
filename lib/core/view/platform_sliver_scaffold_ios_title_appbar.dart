import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformSliverScaffold extends StatelessWidget {
  const PlatformSliverScaffold({
    Key? key,
    required this.title,
    required this.trailingActions,
    required this.sliverChildren,
    this.previousPageTitle,
  }) : super(key: key);

  final String title;
  final List<Widget> trailingActions;
  final String? previousPageTitle;
  final List<Widget> sliverChildren;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: true,
      slivers: [
        PlatformWidget(
          material: (context, _) => SliverAppBar(
            pinned: false,
            floating: true,
            stretch: false,
            snap: true,
            actions: trailingActions,
            title: Text(title),
          ),
          cupertino: (context, _) => CupertinoSliverNavigationBar(
            largeTitle: Text(title),
            previousPageTitle: previousPageTitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: trailingActions,
            ),
          ),
        ),
        ...sliverChildren,
      ],
    );
  }
}
