import 'package:flutter/material.dart';

/// The button on the bottom right
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
      height: 50,
      width: 50,
      decoration: BoxDecoration(color: activeColor, shape: BoxShape.circle),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 25, maxWidth: 25),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Center(
            child: Icon(
              Icons.chevron_right,
              color: Colors.black,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}
