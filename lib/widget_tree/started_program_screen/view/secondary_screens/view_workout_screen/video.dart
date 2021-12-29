import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:video_player/video_player.dart';

class WorkoutVideo extends StatefulWidget {
  const WorkoutVideo({required this.workout, Key? key}) : super(key: key);

  final FirebaseProgramWorkouts workout;

  @override
  State<WorkoutVideo> createState() => _WorkoutVideoState();
}

class _WorkoutVideoState extends State<WorkoutVideo> {
  late VideoPlayerController _controller;

  Color get _shaderMaskColor => platformThemeData(
        context,
        material: (data) => data.scaffoldBackgroundColor,
        cupertino: (data) => data.scaffoldBackgroundColor,
      );

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.workout.short_video_url!)
      ..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return GestureDetector(
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
      );
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }
}
