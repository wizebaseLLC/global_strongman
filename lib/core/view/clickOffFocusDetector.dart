import 'package:flutter/material.dart';

class ClickOffFocusDetector extends StatelessWidget {
  const ClickOffFocusDetector({required this.child, Key? key})
      : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
