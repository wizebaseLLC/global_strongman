import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_routine.dart';
import 'package:global_strongman/core/view/platform_sliver_scaffold_ios_title_appbar.dart';
import 'package:global_strongman/widget_tree/routines/create_routine/name_description_tile.dart';
import 'package:global_strongman/widget_tree/routines/model/name_description_model.dart';

class CreateRoutineScreen extends StatefulWidget {
  const CreateRoutineScreen({
    this.previousPageTitle,
    Key? key,
  }) : super(key: key);

  final String? previousPageTitle;

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  FirebaseRoutine routine = FirebaseRoutine();
  @override
  Widget build(BuildContext context) {
    return PlatformSliverScaffold(
      title: "Create Routine",
      trailingActions: [
        PlatformTextButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: Text(
            "Submit",
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyMedium,
              cupertino: (data) => data.textTheme.actionTextStyle,
            ),
          ),
        )
      ],
      previousPageTitle: widget.previousPageTitle,
      sliverChildren: [
        SliverPadding(
          padding: const EdgeInsets.only(
            top: kSpacing * 2,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  color: platformThemeData(
                    context,
                    material: (data) => data.cardColor,
                    cupertino: (data) => data.barBackgroundColor,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: NameDescriptionTile(
                    nameDescriptionValue: routine,
                    onSubmit: (NameDescriptionModel value) {
                      setState(
                        () {
                          routine.name = value.name;
                          routine.description = value.description;
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: kSpacing * 2,
                ),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  color: platformThemeData(
                    context,
                    material: (data) => data.cardColor,
                    cupertino: (data) => data.barBackgroundColor,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Column(children: [
                    Text(
                      "Name",
                      style: platformThemeData(
                        context,
                        material: (data) => data.textTheme.headline6?.copyWith(
                          fontSize: 24,
                        ),
                        cupertino: (data) =>
                            data.textTheme.navTitleTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
