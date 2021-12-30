import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_user_started_program.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/main.dart';
import 'package:video_player/video_player.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({
    required this.program,
    Key? key,
  }) : super(key: key);
  final QueryDocumentSnapshot<FirebaseProgram> program;

  @override
  State<OverviewTab> createState() => _OverviewTabState();

  static Future<void> handleGetStarted({
    required String programId,
    required String userId,
    required QueryDocumentSnapshot<FirebaseProgram> program,
    required BuildContext context,
  }) async {
    final FirebaseUserStartedProgram startedProgram =
        FirebaseUserStartedProgram();

    final QuerySnapshot<FirebaseUserStartedProgram> existingProgram =
        await startedProgram
            .getCollectionReference(userId: userId)
            .where("program_id", isEqualTo: programId)
            .get();

    if (existingProgram.docs.isEmpty) {
      await startedProgram.createStartedPrograms(
          programId: programId, userId: userId);
    }

    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (_) => StartedProgramScreen(
          program: program,
        ),
      ),
    );
  }
}

class _OverviewTabState extends State<OverviewTab> {
  FirebaseProgram get programData => widget.program.data();

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  Future<void> initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.network(programData.long_video_url!);
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      aspectRatio: 16 / 9,
      autoInitialize: true,
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            programData.long_description!.replaceAll("\\n", "\n"),
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1,
              cupertino: (data) =>
                  data.textTheme.textStyle.copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(
            height: kSpacing * 4,
          ),
          Text(
            "Learn more",
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
              cupertino: (data) => data.textTheme.navTitleTextStyle
                  .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: kSpacing * 2,
          ),
          _chewieController != null
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                )
              : const Center(child: CircularProgressIndicator.adaptive()),
          const SizedBox(
            height: kSpacing * 2,
          ),
          Padding(
            padding: const EdgeInsets.all(kSpacing * 2),
            child: SizedBox(
              width: double.infinity,
              child: PlatformElevatedButton(
                material: (_, __) => MaterialElevatedButtonData(
                    style: ElevatedButton.styleFrom(primary: kPrimaryColor)),
                onPressed: () => OverviewTab.handleGetStarted(
                  programId: widget.program.id,
                  userId: FirebaseAuth.instance.currentUser!.email!,
                  context: context,
                  program: widget.program,
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: kSpacing * 2,
          ),
        ],
      ),
    );
  }
}
