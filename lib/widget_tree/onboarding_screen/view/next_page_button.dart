import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';

/// The button on the bottom right
class NextPageButton extends StatelessWidget {
  const NextPageButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
        color: kSecondaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Center(
            child: Icon(
              Icons.chevron_right,
              color: Colors.black,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
