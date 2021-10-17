import 'package:flutter/material.dart';

class ListIconCupertino extends StatelessWidget {
  const ListIconCupertino({
    required this.icon,
    required this.gradient,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}
