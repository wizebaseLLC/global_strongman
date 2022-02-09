import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program.dart';

class ShadedImage extends StatelessWidget {
  const ShadedImage({
    Key? key,
    this.heroId,
    this.program,
    this.image,
  }) : super(key: key);

  final String? heroId;
  final QueryDocumentSnapshot<FirebaseProgram>? program;
  final Widget? image;

  Widget _buildHeroChild() {
    if (image != null) {
      return image!;
    } else if (program != null && program!.exists) {
      return CachedNetworkImage(
        imageUrl: program!.data().thumbnail_url!,
        fit: BoxFit.cover,
        memCacheWidth: 934,
      );
    }
    return Container();
  }

  Color _scaffoldColor(BuildContext context) => platformThemeData(
        context,
        material: (data) => data.scaffoldBackgroundColor,
        cupertino: (data) => data.scaffoldBackgroundColor,
      );

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [
            _scaffoldColor(context).withOpacity(.7),
            _scaffoldColor(context).withOpacity(.4),
            _scaffoldColor(context).withOpacity(0),
          ],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: heroId != null
          ? Hero(
              tag: heroId!,
              child: _buildHeroChild(),
            )
          : _buildHeroChild(),
    );
  }
}
