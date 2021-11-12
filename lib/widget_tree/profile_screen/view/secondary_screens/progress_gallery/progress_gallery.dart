import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';
import 'package:global_strongman/core/view/platform_scaffold_ios_sliver_title.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/gallery_image_card.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/line_graph.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/share_or_add_button.dart';

const galleryList = [
  GalleryImageCard(
    imageUrl: "https://s.hdnux.com/photos/01/17/10/12/20742794/5/1200x0.jpg",
    date: "December 6, 2020",
    bmi: "21.1",
    bodyFat: "16.1",
    bust: "32",
    hip: "33",
    waist: "25",
    weight: "115",
    caption: "🎉🎉 Finally Reached my goal!",
  ),
  GalleryImageCard(
    imageUrl: "https://s.hdnux.com/photos/01/17/10/12/20742794/5/1200x0.jpg",
    date: "December 6, 2020",
    bmi: "21.1",
    bodyFat: "16.1",
    bust: "32",
    hip: "33",
    waist: "25",
    weight: "115",
    caption: "🎉🎉 Finally Reached my goal!",
  ),
  GalleryImageCard(
    imageUrl: "https://s.hdnux.com/photos/01/17/10/12/20742794/5/1200x0.jpg",
    date: "December 6, 2020",
    bmi: "21.1",
    bodyFat: "16.1",
    bust: "32",
    hip: "33",
    waist: "25",
    weight: "115",
    caption: "🎉🎉 Finally Reached my goal!",
  ),
  GalleryImageCard(
    imageUrl: "https://s.hdnux.com/photos/01/17/10/12/20742794/5/1200x0.jpg",
    date: "December 6, 2020",
    bmi: "21.1",
    bodyFat: "16.1",
    bust: "32",
    hip: "33",
    waist: "25",
    weight: "115",
    caption: "🎉🎉 Finally Reached my goal!",
  ),
];

class ProgressGallery extends StatelessWidget {
  const ProgressGallery({
    required this.firebaseUser,
    Key? key,
  }) : super(key: key);

  final FirebaseUser firebaseUser;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffoldIosSliverTitle(
      title: "My Progress",
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: kSpacing,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Platform.isIOS ? 0 : kSpacing,
              ),
              child: const ProgressLineChart(),
            ),
            const SizedBox(
              height: kSpacing,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShareOrAddButton(
                    icon: PlatformIcons(context).share,
                    title: "Share",
                  ),
                  ShareOrAddButton(
                    icon: PlatformIcons(context).add,
                    title: "Add",
                  ),
                ],
              ),
            ),
            const GalleryImageCardContainer(galleryList: galleryList)
          ],
        ),
      ),
      trailingActions: const [],
    );
  }
}
