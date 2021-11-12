import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';

class GalleryImageCardContainer extends StatelessWidget {
  const GalleryImageCardContainer({
    Key? key,
    required this.galleryList,
  }) : super(key: key);

  final List<GalleryImageCard> galleryList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: galleryList.length,
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => PlatformWidget(
        cupertino: (context, _) => CupertinoButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          child: galleryList[index],
        ),
        material: (context, _) => InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: kPrimaryColor,
          onTap: () {},
          child: galleryList[index],
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.fill,
                  memCacheHeight: 300,
                  width: MediaQuery.of(context).size.width * .4,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                title: 'Weight: $weight lbs',
                              ),
                              CardStatText(
                                title: 'Bust: $bust in',
                              ),
                              CardStatText(
                                title: 'BMI: $bmi',
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
                                title: 'Waist: $waist in',
                              ),
                              CardStatText(
                                title: 'Hip: $hip in',
                              ),
                              CardStatText(
                                title: 'Body Fat: $bodyFat %',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: kSpacing / 2),
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
                    Text(
                      caption ?? "",
                      style: platformThemeData(
                        context,
                        material: (data) => data.textTheme.bodyText1?.copyWith(
                          fontSize: 14,
                        ),
                        cupertino: (data) => data.textTheme.textStyle.copyWith(
                          fontSize: 16,
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