import 'package:flutter/material.dart';
import 'package:global_strongman/widget_tree/onboarding/model/page_data.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page_1_body.dart';

List<PageData> pageDataList = [
  PageData(
    color: const Color(0XFFE1E886),
    imageUrl: "assets/images/fitness_man.png",
    pageBody: page1Body(),
  ),
  PageData(
    color: const Color(0XFFF5D8E8),
    imageUrl: "assets/images/fitness_girl_with_barbell.png",
    pageBody: page1Body(),
  ),
  PageData(
    color: const Color(0XFF9EE3F2),
    imageUrl: "assets/images/man_riding_stationary_bike.png",
    pageBody: page1Body(),
  ),
  PageData(
    color: const Color.fromRGBO(124, 176, 206, 1),
    imageUrl: "assets/images/man_jogging_at_night.png",
    pageBody: page1Body(),
  ),
];
