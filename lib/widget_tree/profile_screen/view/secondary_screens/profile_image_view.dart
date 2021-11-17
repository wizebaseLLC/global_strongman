import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:photo_view/photo_view.dart';

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({
    required this.imageProvider,
    this.heroTag,
    this.title,
    Key? key,
  }) : super(key: key);

  final String? heroTag;
  final String? title;

  final ImageProvider imageProvider;
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(title ?? "Profile Image"),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: PhotoView(
          heroAttributes: PhotoViewHeroAttributes(
            transitionOnUserGestures: true,
            tag: heroTag ?? "profile_gallery_avatar",
          ),
          imageProvider: imageProvider,
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
