import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/ProgressGalleryCard.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/gallery_image_card.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/line_graph.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/share_or_add_button.dart';

class GalleryStream extends StatelessWidget {
  const GalleryStream({
    required this.firebaseUser,
    required this.snapshot,
    Key? key,
  }) : super(key: key);

  final FirebaseUser firebaseUser;
  final FirestoreQueryBuilderSnapshot<ProgressGalleryCard> snapshot;
  Future<QuerySnapshot<ProgressGalleryCard>>
      _firebaseUserProgressGalleryStream() {
    final User authenticatedUser = FirebaseUser.getSignedInUserFromFireStore()!;
    return FirebaseUser(email: authenticatedUser.email!)
        .getProgressGalleryCollectionReference()
        .orderBy('date', descending: true)
        .limit(10)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseUserProgressGalleryStream(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<ProgressGalleryCard>> snapshot,
      ) {
        final List<QueryDocumentSnapshot<ProgressGalleryCard>>?
            streamedGallery = snapshot.data?.docs;

        return SliverList(
          delegate: SliverChildListDelegate(
            [
              Material(
                color: platformThemeData(
                  context,
                  material: (data) => data.scaffoldBackgroundColor,
                  cupertino: (data) => data.scaffoldBackgroundColor,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: kSpacing * 2,
                    ),
                    if (streamedGallery != null && streamedGallery.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Platform.isIOS ? 0 : kSpacing,
                        ),
                        child: ProgressLineChart(
                          streamedGallery: streamedGallery,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ShareOrAddButton(
                            icon: PlatformIcons(context).add,
                            title: "Add",
                            firebaseUser: firebaseUser,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GallerySliverList extends StatelessWidget {
  const GallerySliverList({
    Key? key,
    required this.firebaseUser,
    required this.streamedGallery,
    required this.snapshot,
  }) : super(key: key);

  final FirebaseUser firebaseUser;
  final List<QueryDocumentSnapshot<ProgressGalleryCard>> streamedGallery;
  final FirestoreQueryBuilderSnapshot<ProgressGalleryCard> snapshot;
  @override
  Widget build(BuildContext context) {
    return GalleryImageCardContainer(
      firebaseUser: firebaseUser,
      snapshot: snapshot,
      galleryList: streamedGallery.map(
        (data) {
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
        },
      ).toList(),
    );
  }
}
