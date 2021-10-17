import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NextPageButton extends StatelessWidget {
  const NextPageButton({
    Key? key,
    required this.activeColor,
  }) : super(key: key);

  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 70,
      width: 70,
      decoration: BoxDecoration(color: activeColor, shape: BoxShape.circle),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Icon(
              PlatformIcons(context).rightChevron,
              color: Colors.black,
              size: 14,
            ),
          ),
        ),
      ),
    );
  }
}
