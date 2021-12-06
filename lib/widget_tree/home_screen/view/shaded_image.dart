import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/core/model/firebase_program.dart';

class ShadedImage extends StatelessWidget {
  const ShadedImage({
    Key? key,
    required this.heroId,
    required this.program,
  }) : super(key: key);

  final String heroId;
  final QueryDocumentSnapshot<FirebaseProgram> program;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(.9),
            Colors.black.withOpacity(.7),
            Colors.black.withOpacity(.1),
          ],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: Hero(
        tag: heroId,
        child: Material(
          child: CachedNetworkImage(
            imageUrl: program.data().thumbnail_url!,
            fit: BoxFit.cover,
            memCacheWidth: 934,
          ),
        ),
      ),
    );
  }
}
