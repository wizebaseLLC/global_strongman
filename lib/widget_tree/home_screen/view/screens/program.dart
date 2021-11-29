import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program.dart';

class ProgramScreen extends StatelessWidget {
  const ProgramScreen({required this.program, Key? key}) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: DefaultTabController(
          length: 3,
          child: SafeArea(
            top: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: platformThemeData(
                    context,
                    material: (data) => data.appBarTheme.backgroundColor,
                    cupertino: (data) => data.barBackgroundColor,
                  ),
                  floating: false,
                  //snap: true,
                  // pinned: true,
                  //    forceElevated: true,
                  expandedHeight: 250,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.blurBackground,
                      StretchMode.fadeTitle,
                      StretchMode.zoomBackground,
                    ],
                    background: ShaderMask(
                      shaderCallback: (rect) {
                        return RadialGradient(
                          // begin: Alignment.center,
                          // end: Alignment.bottomCenter,
                          colors: [
                            Colors.black,
                            Colors.grey,
                            Colors.black.withOpacity(.4),
                          ],
                        ).createShader(Rect.fromLTRB(
                          0,
                          0,
                          rect.width,
                          rect.height,
                        ));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Hero(
                        tag: program.id,
                        child: Material(
                          child: CachedNetworkImage(
                            imageUrl: program.data().thumbnail_url!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Fifishfesh",
                        style: platformThemeData(context,
                            material: (data) => data.textTheme.headline6,
                            cupertino: (data) =>
                                data.textTheme.navLargeTitleTextStyle),
                      ),
                    ],
                  )
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// TabBarView(
// children: [
// Container(),
// Container(),
// Container(),
// ],
// ),

// const TabBar(
// tabs: [
// Tab(icon: Icon(Icons.map), text: "tab 1"),
// Tab(icon: Icon(Icons.map), text: "tab 2"),
// Tab(icon: Icon(Icons.map), text: "tab 3"),
// ],
// )

// Text(
// "Fifishfesh",
// style: platformThemeData(context,
// material: (data) => data.textTheme.headline6,
// cupertino: (data) =>
// data.textTheme.navLargeTitleTextStyle),
// ),
