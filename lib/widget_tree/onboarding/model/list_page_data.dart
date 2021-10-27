import 'package:flutter/material.dart';
import 'package:global_strongman/widget_tree/onboarding/model/page_data.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page1/main.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page2/main.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page3/main.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page4/main.dart';
import 'package:introduction_screen/introduction_screen.dart';

const backgroundColor = Color.fromRGBO(19, 19, 20, 1);

List<PageData> pageDataList({required BuildContext context, required GlobalKey<IntroductionScreenState> controller}) => [
      PageData(
        color: backgroundColor,
        imageUrl: "assets/images/strong_chains.jpg",
        title: "Welcome to Global Strongman",
        pageBody: page1Body(
          context: context,
          controller: controller,
          backgroundColor: backgroundColor,
        ),
      ),
      PageData(
        color: backgroundColor,
        imageUrl: "assets/images/flip_tire_lady.jpg",
        title: "Let's get to know you",
        pageBody: page2Body(
          context: context,
          backgroundColor: backgroundColor,
        ),
      ),
      PageData(
        color: backgroundColor,
        imageUrl: "assets/images/shirtless_hit_tire.jpg",
        title: "More about you",
        pageBody: page3Body(
          context: context,
          backgroundColor: backgroundColor,
        ),
      ),
      PageData(
        color: backgroundColor,
        imageUrl: "assets/images/strong_woman_olympic.jpg",
        title: "Your training experience",
        pageBody: page4Body(
          context: context,
          backgroundColor: backgroundColor,
        ),
      ),
    ];
