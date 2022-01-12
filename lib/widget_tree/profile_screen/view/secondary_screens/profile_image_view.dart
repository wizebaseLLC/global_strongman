import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:photo_view/photo_view.dart';

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({
    required this.url,
    this.heroTag,
    this.title,
    this.enableRotation,
    this.usesFileProvider,
    this.file,
    Key? key,
  }) : super(key: key);

  final String? heroTag;
  final String? title;
  final String url;
  final bool? enableRotation;
  final bool? usesFileProvider;
  final File? file;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(title ?? "Profile Image"),
        backgroundColor: Colors.transparent,
        material: (context, platform) => MaterialAppBarData(
          elevation: 0,
          backgroundColor: Colors.black,
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: PhotoView(
          enableRotation: enableRotation ?? false,
          heroAttributes: PhotoViewHeroAttributes(
            transitionOnUserGestures: true,
            tag: heroTag ?? "profile_gallery_avatar",
          ),
          imageProvider: usesFileProvider != null &&
                  usesFileProvider == true &&
                  file != null
              ? FileImage(file!)
              : CachedNetworkImageProvider(
                  url,
                ) as ImageProvider,
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 100.0,
              height: 100.0,
              child: CircularProgressIndicator.adaptive(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
