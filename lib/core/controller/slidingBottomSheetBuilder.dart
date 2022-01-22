import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SlidingBottomSheetBuilder {
  SlidingBottomSheetBuilder({
    required this.context,
    required this.child,
    this.expand = false,
  });

  final BuildContext context;
  final Widget child;
  final bool? expand;

  Future<T?> showAsBottomSheet<T>() async {
    final T? result = Platform.isIOS
        ? await showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => child,
            backgroundColor: CupertinoColors.darkBackgroundGray,
            bounce: true,
            expand: expand ?? false,
            useRootNavigator: true,
          )
        : await showMaterialModalBottomSheet(
            context: context,
            builder: (context) => child,
            expand: expand ?? false,
            backgroundColor: Theme.of(context).cardColor,
            bounce: true,
            useRootNavigator: true,
          );

    return result;
  }
}
