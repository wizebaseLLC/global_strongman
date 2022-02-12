import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_routine.dart';
import 'package:global_strongman/widget_tree/routines/create_routine/name_description_form_entry_screen.dart';
import 'package:global_strongman/widget_tree/routines/model/name_description_model.dart';

class NameDescriptionTile extends StatelessWidget {
  const NameDescriptionTile({
    required this.onSubmit,
    required this.nameDescriptionValue,
    Key? key,
  }) : super(key: key);

  final void Function(NameDescriptionModel value) onSubmit;
  final FirebaseRoutine nameDescriptionValue;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // tileColor: platformThemeData(
      //   context,
      //   material: (data) => data.cardColor,
      //   cupertino: (data) => data.barBackgroundColor,
      // ),
      title: Text(
        nameDescriptionValue.name ?? "Name",
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.headline6?.copyWith(
            fontSize: 24,
          ),
          cupertino: (data) => data.textTheme.navTitleTextStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: kSpacing),
        child: Text(
          (nameDescriptionValue.description == null ||
                  (nameDescriptionValue.description != null &&
                      nameDescriptionValue.description!.isEmpty))
              ? "Description"
              : nameDescriptionValue.description!,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.bodyText1?.copyWith(
              fontSize: 14,
              color: Colors.white70,
            ),
            cupertino: (data) => data.textTheme.textStyle.copyWith(
              fontSize: 14,
              color: CupertinoColors.systemGrey2,
            ),
          ),
        ),
      ),
      trailing: Icon(
        PlatformIcons(context).rightChevron,
        color: Colors.white,
      ),
      onTap: () async {
        final NameDescriptionModel? result = await Navigator.push(
          context,
          platformPageRoute(
            context: context,
            fullscreenDialog: true,
            builder: (_) => NameDescriptionFormEntryScreen(
              nameDescriptionValue: nameDescriptionValue,
            ),
          ),
        );

        if (result != null) {
          onSubmit(result);
        }
      },
    );
  }
}
