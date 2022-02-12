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
            "Save",
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
                NameDescriptionTile(
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
                const SizedBox(
                  height: kSpacing,
                ),
                const Divider(
                  height: 2,
                  color: Colors.grey,
                  indent: kSpacing * 2,
                  endIndent: kSpacing * 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
