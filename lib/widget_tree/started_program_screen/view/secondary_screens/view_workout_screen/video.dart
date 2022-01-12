import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class WorkoutVideo extends StatefulWidget {
  const WorkoutVideo({required this.workout, Key? key}) : super(key: key);

  final FirebaseProgramWorkouts workout;

  @override
  State<WorkoutVideo> createState() => _WorkoutVideoState();
}

class _WorkoutVideoState extends State<WorkoutVideo> {
  late VideoPlayerController _controller;
  late bool isMuted;

  Color get _shaderMaskColor => platformThemeData(
        context,
        material: (data) => data.scaffoldBackgroundColor,
        cupertino: (data) => data.scaffoldBackgroundColor,
      );

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      final bool? foundIsMuted = prefs.getBool("is_muted");
      if (foundIsMuted != null && foundIsMuted == true) {
        setState(() {
          isMuted = true;
        });
      } else {
        setState(() {
          isMuted = false;
        });
      }
    }).catchError((e) => print(e));

    _controller = VideoPlayerController.network(
      widget.workout.short_video_url!,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    )..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return Stack(
        children: [
          GestureDetector(
            onTap: () => _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play(),
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    _shaderMaskColor,
                    Colors.transparent,
                  ],
                ).createShader(Rect.fromLTRB(
                  0,
                  0,
                  rect.width,
                  rect.height,
                ));
              },
              blendMode: BlendMode.dstIn,
              child: VideoPlayer(_controller),
            ),
          ),
          Positioned(
            bottom: 0,
            right: kSpacing,
            child: PlatformIconButton(
              cupertino: (context, platform) => CupertinoIconButtonData(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(kSpacing * 2),
              color: Colors.grey.shade900.withOpacity(.6),
              onPressed: () async {
                try {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  final bool isMutedNewValue = !isMuted;

                  prefs.setBool("is_muted", isMutedNewValue);

                  final double volume = isMutedNewValue ? 0.0 : 1.0;

                  setState(() {
                    isMuted = isMutedNewValue;
                    _controller.setVolume(volume);
                  });
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(
                isMuted
                    ? PlatformIcons(context).volumeMute
                    : PlatformIcons(context).volumeUp,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }
}
