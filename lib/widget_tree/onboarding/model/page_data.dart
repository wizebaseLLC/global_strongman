import 'package:flutter/material.dart';

/// The reusable data used by each on-boarding page.
class PageData {
  final Color color;
  final String imageUrl;
  final String title;
  final List<Widget> pageBody;
  const PageData({
    required this.color,
    required this.imageUrl,
    required this.pageBody,
    required this.title,
  });
}
