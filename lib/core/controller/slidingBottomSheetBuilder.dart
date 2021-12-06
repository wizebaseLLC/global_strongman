import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class SlidingBottomSheetBuilder {
  SlidingBottomSheetBuilder({
    required this.context,
    required this.child,
    this.snappings = const [0.4, 0.7, 1.0],
    this.initialSnap = .7,
  });

  final BuildContext context;
  final Widget child;
  final List<double> snappings;
  final double initialSnap;

  Future<T?> showAsBottomSheet<T>() async {
    final T? result = await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        avoidStatusBar: true,
        duration: const Duration(milliseconds: 500),
        color: platformThemeData(
          context,
          material: (data) => data.cardColor,
          cupertino: (data) => data.barBackgroundColor.withOpacity(1),
        ),
        snapSpec: SnapSpec(
          snap: true,
          initialSnap: initialSnap,
          snappings: snappings,
        ),
        builder: (context, state) {
          return child;
        },
      );
    });

    return result;
  }
}
