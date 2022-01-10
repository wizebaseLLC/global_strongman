import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/showPlatformActionSheet.dart';
import 'package:global_strongman/core/model/ProgressGalleryCard.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/profile_image_view.dart';

class GalleryImageCardContainer extends StatelessWidget {
  const GalleryImageCardContainer({
    Key? key,
    required this.firebaseUser,
    required this.galleryList,
  }) : super(key: key);

  final FirebaseUser firebaseUser;
  final List<GalleryImageCard> galleryList;

  /// Delete document on long press.
  Future<void> _deleteDocument({
    required int index,
    required BuildContext context,
  }) async {
    final Query<ProgressGalleryCard> document =
        firebaseUser.getProgressGalleryCollectionReference().where(
              "url",
              isEqualTo: galleryList[index].imageUrl,
            );

    final docs = await document.get();

    for (var doc in docs.docs) {
      final fileName = doc.data().file_name;
      await doc.reference.delete();
      firebaseUser.removeProgressPhotoFromStorage(
          fileName: fileName, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      itemCount: galleryList.length,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) => GestureDetector(
        onLongPress: () async {
          final actionSheetData =
              PlatformActionSheet(title: "Progress Photo", model: [
            ActionSheetModel(
              title: 'Delete',
              iconMaterial: const Icon(Icons.delete),
              onTap: () => _deleteDocument(index: index, context: context),
              textStyle: const TextStyle(color: Colors.redAccent),
            ),
          ]);

          showPlatformActionSheet(
            context: context,
            actionSheetData: actionSheetData,
          );
        },
        child: PlatformWidget(
          cupertino: (context, _) => CupertinoButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ProfileImageView(
                    heroTag: galleryList[index].imageUrl,
                    title: "Progress Photo",
                    imageProvider: CachedNetworkImageProvider(
                      galleryList[index].imageUrl,
                    ),
                  ),
                ),
              );
            },
            padding: EdgeInsets.zero,
            child: galleryList[index],
          ),
          material: (context, _) => InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileImageView(
                    heroTag: galleryList[index].imageUrl,
                    title: "Progress Photo",
                    imageProvider: CachedNetworkImageProvider(
                      galleryList[index].imageUrl,
                    ),
                  ),
                ),
              );
            },
            child: galleryList[index],
          ),
        ),
      ),
    );
  }
}

class GalleryImageCard extends StatelessWidget {
  const GalleryImageCard({
    Key? key,
    required this.imageUrl,
    this.weight,
    this.bust,
    this.bmi,
    this.waist,
    this.hip,
    this.bodyFat,
    required this.date,
    this.caption,
  }) : super(key: key);

  final String imageUrl;
  final String? weight;
  final String? bust;
  final String? bmi;
  final String? waist;
  final String? hip;
  final String? bodyFat;
  final String date;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Platform.isIOS ? 0 : kSpacing,
        vertical: kSpacing,
      ),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: platformThemeData(
          context,
          material: (data) => data.backgroundColor,
          cupertino: (data) => data.barBackgroundColor,
        ),
        child: Container(
          padding: const EdgeInsets.all(kSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Hero(
                  tag: imageUrl,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 340,
                    width: MediaQuery.of(context).size.width * .3,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: kSpacing),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CardStatText(
                                title:
                                    'Weight: ${weight ?? ""} ${weight != null ? "lbs" : ""}',
                              ),
                              CardStatText(
                                title:
                                    'Bust: ${bust ?? ""} ${bust != null ? "in" : ""}',
                              ),
                              CardStatText(
                                title: 'BMI: ${bmi ?? ""}',
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: kSpacing * 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CardStatText(
                                title:
                                    'Waist: ${waist ?? ""}  ${waist != null ? "in" : ""}',
                              ),
                              CardStatText(
                                title:
                                    'Hip: ${hip ?? ""}  ${hip != null ? "in" : ""}',
                              ),
                              CardStatText(
                                title:
                                    'Body Fat: ${bodyFat ?? ""}  ${bodyFat != null ? "%" : ""}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: kSpacing),
                      child: Text(
                        date,
                        style: platformThemeData(
                          context,
                          material: (data) =>
                              data.textTheme.bodyText1?.copyWith(
                            fontSize: 14,
                            color: Colors.red.shade300,
                          ),
                          cupertino: (data) =>
                              data.textTheme.textStyle.copyWith(
                            fontSize: 16,
                            color: Colors.red.shade300,
                          ),
                        ),
                      ),
                    ),
                    if (caption != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kSpacing * 2,
                        ),
                        child: Text(
                          caption!,
                          textAlign: TextAlign.center,
                          style: platformThemeData(
                            context,
                            material: (data) =>
                                data.textTheme.bodyText1?.copyWith(
                              fontSize: 14,
                            ),
                            cupertino: (data) =>
                                data.textTheme.textStyle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardStatText extends StatelessWidget {
  const CardStatText({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpacing / 2),
      child: Text(
        title ?? "-",
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.bodyText1?.copyWith(fontSize: 12),
          cupertino: (data) => data.textTheme.textStyle.copyWith(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
