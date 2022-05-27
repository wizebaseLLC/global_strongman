import 'package:flutter/material.dart';

class PremiumChip extends StatelessWidget {
  const PremiumChip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.yellowAccent.shade700,
      visualDensity: VisualDensity.compact,
      label: const Text(
        "Premium",
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
