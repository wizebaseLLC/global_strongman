import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformScaffoldIosSliverTitle extends StatelessWidget {
  const PlatformScaffoldIosSliverTitle({
    Key? key,
    required this.title,
    required this.trailingActions,
    required this.body,
  }) : super(key: key);

  final String title;
  final List<Widget> trailingActions;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      cupertino: (_, __) => CupertinoPageScaffoldData(
        body: NestedScrollView(
          headerSliverBuilder: (context, isInnerBoxScrolled) => [
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                title,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: trailingActions,
              ),
            ),
          ],
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: body,
          ),
        ),
      ),
      material: (_, __) => MaterialScaffoldData(
        appBar: AppBar(
          title: Text(title),
          actions: trailingActions,
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: body,
        ),
      ),
    );
  }
}
