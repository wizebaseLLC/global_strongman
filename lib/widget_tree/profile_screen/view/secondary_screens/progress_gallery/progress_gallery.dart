import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';
import 'package:global_strongman/core/model/ProgressGalleryCard.dart';
import 'package:global_strongman/core/view/platform_scaffold_ios_sliver_title.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/gallery_image_card.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/line_graph.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/share_or_add_button.dart';

class ProgressGallery extends StatelessWidget {
  const ProgressGallery({
    required this.firebaseUser,
    Key? key,
  }) : super(key: key);

  final FirebaseUser firebaseUser;

  Stream<QuerySnapshot<ProgressGalleryCard>>
      _firebaseUserProgressGalleryStream() {
    final User authenticatedUser = FirebaseUser.getSignedInUserFromFireStore()!;
    return FirebaseUser(email: authenticatedUser.email!)
        .getProgressGalleryCollectionReference()
        .snapshots();
  }

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
                    firebaseUser: firebaseUser,
                  ),
                  ShareOrAddButton(
                    icon: PlatformIcons(context).add,
                    title: "Add",
                    firebaseUser: firebaseUser,
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: _firebaseUserProgressGalleryStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<ProgressGalleryCard>> snapshot) {
                final List<QueryDocumentSnapshot<ProgressGalleryCard>>?
                    streamedGallery = snapshot.data?.docs;

                streamedGallery?.sort(
                  (a, b) => b.data().date.compareTo(a.data().date),
                );

                if (streamedGallery != null && streamedGallery.isNotEmpty) {
                  return GalleryImageCardContainer(
                    galleryList: streamedGallery.map((data) {
                      final galleryData = data.data();
                      return GalleryImageCard(
                        imageUrl: galleryData.url,
                        date: galleryData.date.toString().substring(0, 10),
                        bmi: galleryData.bmi,
                        bodyFat: galleryData.bodyFat,
                        bust: galleryData.bust,
                        hip: galleryData.hip,
                        waist: galleryData.waist,
                        weight: galleryData.weight,
                        caption: galleryData.description,
                      );
                    }).toList(),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: kSpacing * 4),
                    child: Text(
                      "Press Add to upload your first progress photo!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      trailingActions: const [],
    );
  }
}
