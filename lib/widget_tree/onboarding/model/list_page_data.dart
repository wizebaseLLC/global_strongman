import 'package:flutter/material.dart';
import 'package:global_strongman/widget_tree/onboarding/model/page_data.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page1/main.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page2/main.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page3/main.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page4/main.dart';
import 'package:introduction_screen/introduction_screen.dart';

List<PageData> pageDataList({required BuildContext context, required GlobalKey<IntroductionScreenState> controller}) => [
      PageData(
        color: const Color(0XFFE1E886),
        imageUrl: "assets/images/fitness_man.png",
        title: "Welcome to Global Strongman",
        pageBody: page1Body(
          context: context,
          controller: controller,
          backgroundColor: const Color(0XFFE1E886),
        ),
      ),
      PageData(
        color: const Color(0XFFF5D8E8),
        imageUrl: "assets/images/fitness_girl_with_barbell.png",
        title: "Let's get to know you",
        pageBody: page2Body(
          context: context,
          backgroundColor: const Color(0XFFF5D8E8),
        ),
      ),
      PageData(
        color: const Color(0XFF9EE3F2),
        imageUrl: "assets/images/man_riding_stationary_bike.png",
        title: "More about you",
        pageBody: page3Body(
          context: context,
          backgroundColor: const Color(0XFF9EE3F2),
        ),
      ),
      PageData(
        color: const Color.fromRGBO(124, 176, 206, 1),
        imageUrl: "assets/images/man_jogging_at_night.png",
        title: "Your Training experience",
        pageBody: page4Body(
          context: context,
          backgroundColor: const Color.fromRGBO(124, 176, 206, 1),
        ),
      ),
    ];
