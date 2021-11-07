import 'package:flutter/material.dart';

/// The reusable data used by each on-boarding page.
class PageData {
  final String imageUrl;
  final String title;
  final List<Widget> pageBody;
  const PageData({
    required this.imageUrl,
    required this.pageBody,
    required this.title,
  });
}
