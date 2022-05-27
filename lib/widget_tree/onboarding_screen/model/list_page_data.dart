import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/model/page_data.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page1/main.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page2/main.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page3/main.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page4/main.dart';
import 'package:introduction_screen/introduction_screen.dart';

const backgroundColor = Color.fromRGBO(19, 19, 20, 1);

List<PageData> pageDataList({
  required BuildContext context,
  required GlobalKey<IntroductionScreenState> controller,
  required GlobalKey<FormBuilderState> formKey,
}) =>
    [
      PageData(
        imageUrl: "assets/images/strong_chains.jpg",
        title: "Welcome to Global Strongman",
        pageBody: page1Body(
          context: context,
          controller: controller,
        ),
      ),
      PageData(
        imageUrl: "assets/images/flip_tire_lady.jpg",
        title: "Let's get to know you",
        pageBody: page2Body(
          context: context,
        ),
      ),
      PageData(
        imageUrl: "assets/images/shirtless_hit_tire.jpg",
        title: "More about you",
        pageBody: page3Body(
          context: context,
        ),
      ),
      PageData(
        imageUrl: "assets/images/strong_woman_olympic.jpg",
        title: "Your training experience",
        pageBody: page4Body(
          context: context,
        ),
      ),
    ];
