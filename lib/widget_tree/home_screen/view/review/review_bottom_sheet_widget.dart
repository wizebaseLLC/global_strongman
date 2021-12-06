import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_reviews.dart';

class ReviewBottomSheetWidget extends StatefulWidget {
  const ReviewBottomSheetWidget({
    required this.program,
    Key? key,
    this.currentReview,
    this.currentRating,
  }) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;
  final num? currentRating;
  final String? currentReview;

  @override
  State<ReviewBottomSheetWidget> createState() =>
      _ReviewBottomSheetWidgetState();
}

class _ReviewBottomSheetWidgetState extends State<ReviewBottomSheetWidget> {
  late final TextEditingController _controller;
  late num _rating;

  TextStyle? _subtitleStyle(BuildContext context) => platformThemeData(
        context,
        material: (data) => data.textTheme.subtitle1?.copyWith(
          fontSize: 22,
          color: Colors.white70,
        ),
        cupertino: (data) => data.textTheme.textStyle.copyWith(
          fontSize: 22,
          color: CupertinoColors.systemGrey2,
        ),
      );

  Future<void> onSubmit() async {
    try {
      widget.program.reference.collection("reviews").add(FirebaseProgramRating(
            uid: FirebaseAuth.instance.currentUser!.email,
            review: _controller.text,
            rating: _rating,
            created_on: DateTime.now(),
          ).toJson());
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  void initState() {
    _controller = TextEditingController(
      text: widget.currentReview,
    );

    _rating = widget.currentRating ?? 5;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(kSpacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.currentReview == null
                      ? "Create review"
                      : "Edit review",
                  style: platformThemeData(
                    context,
                    material: (data) =>
                        data.textTheme.headline6?.copyWith(fontSize: 26),
                    cupertino: (data) =>
                        data.textTheme.navTitleTextStyle.copyWith(fontSize: 26),
                  ),
                ),
                Expanded(child: Container()),
                PlatformTextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.bodyText1?.copyWith(
                        color: Colors.blueAccent,
                      ),
                      cupertino: (data) => data.textTheme.textStyle.copyWith(
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: kSpacing * 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Overall rating",
                  style: _subtitleStyle(context),
                ),
                const SizedBox(height: kSpacing),
                RatingBar.builder(
                  initialRating: _rating.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemSize: 30,
                  itemCount: 5,
                  // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.yellowAccent.shade700,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                const SizedBox(height: kSpacing * 4),
                Text(
                  "Add a written review",
                  style: _subtitleStyle(context),
                ),
                const SizedBox(height: kSpacing),
                PlatformWidgetBuilder(
                  cupertino: (_, child, __) => child,
                  material: (_, child, __) => Material(
                    borderRadius: BorderRadius.circular(8),
                    child: child,
                  ),
                  child: PlatformTextField(
                    controller: _controller,
                    minLines: 5,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    hintText: "What did you like or dislike?",
                    cupertino: (_, __) => CupertinoTextFieldData(),
                    material: (_, __) => MaterialTextFieldData(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(kSpacing),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: kSpacing * 4),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kSpacing * 2,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: PlatformElevatedButton(
                      material: (_, __) => MaterialElevatedButtonData(
                        style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                      ),
                      cupertino: (_, __) => CupertinoElevatedButtonData(
                        color: kPrimaryColor,
                      ),
                      onPressed: () async {
                        await onSubmit();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Submit Review",
                        style: platformThemeData(
                          context,
                          material: (data) =>
                              data.textTheme.bodyText1?.copyWith(
                            color: Colors.white,
                          ),
                          cupertino: (data) =>
                              data.textTheme.textStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
