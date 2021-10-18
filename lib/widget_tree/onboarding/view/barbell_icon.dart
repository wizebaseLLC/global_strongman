import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:sprung/sprung.dart';

///Returns a [Positioned] widget which creates a randomly angled barbel icon.
///
/// This is placed in the top portion behind the image.
class BarbellIcon extends StatelessWidget {
  const BarbellIcon({
    Key? key,
    this.top,
    this.left,
    this.right,
    this.bottom,
  }) : super(key: key);

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: TweenAnimationBuilder(
        duration: const Duration(seconds: 2),
        tween: Tween<double>(begin: 0, end: Random().nextInt(5).toDouble()),
        curve: Sprung(),
        builder: (_, double angle, __) => Transform.rotate(
          angle: angle,
          child: Opacity(
            opacity: .3,
            child: Image.asset(
              "assets/images/barbell_icon.png",
              height: 120,
            ),
          ),
        ),
      ),
    );
  }
}
