import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/home_screen/view/category_stack_container.dart';

class FilterIcon extends StatelessWidget {
  const FilterIcon({
    required this.context,
    required this.icon,
    required this.backgroundColor,
    required this.name,
    required this.selected,
    this.shouldNotUsePadding,
    this.count,
    this.toggleState,
    Key? key,
  }) : super(key: key);

  final BuildContext context;
  final Widget icon;
  final Color backgroundColor;
  final String name;
  final void Function()? toggleState;
  final bool selected;
  final bool? shouldNotUsePadding;
  final int? count;

  bool get willNotUsePadding =>
      shouldNotUsePadding != null && shouldNotUsePadding == true ? true : false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: willNotUsePadding ? 0 : kSpacing * 2,
            bottom: willNotUsePadding ? 0 : kSpacing,
          ),
          child: PlatformWidgetBuilder(
            cupertino: (_, child, __) => CupertinoButton(
              child: child!,
              onPressed: toggleState,
            ),
            material: (_, child, __) => Ink(
              height: 60,
              width: 60,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: backgroundColor,
                onTap: toggleState,
                child: child,
              ),
            ),
            child: count != null
                ? CategoryStackContainer(
                    count: count!,
                    child: CircleAvatar(
                      minRadius: 30,
                      backgroundColor: selected
                          ? backgroundColor
                          : Platform.isIOS
                              ? CupertinoColors.darkBackgroundGray
                              : Colors.grey.shade900,
                      child: icon,
                    ),
                  )
                : CircleAvatar(
                    minRadius: 30,
                    backgroundColor: selected
                        ? backgroundColor
                        : Platform.isIOS
                            ? CupertinoColors.darkBackgroundGray
                            : Colors.grey.shade900,
                    child: icon,
                  ),
          ),
        ),
        Text(
          name,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.bodyText1,
            cupertino: (data) =>
                data.textTheme.tabLabelTextStyle.copyWith(fontSize: 13),
          ),
        )
      ],
    );
  }
}
