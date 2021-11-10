import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/model/list_page_data.dart';

class CupertinoFormFields extends StatelessWidget {
  const CupertinoFormFields({
    this.firebaseUser,
    Key? key,
  }) : super(key: key);
  final FirebaseUser? firebaseUser;
  List<String> _getHeightList() {
    List<int> feet = [for (var i = 5; i <= 8; i++) i];
    List<int> inches = [for (var i = 1; i <= 11; i++) i];
    List<String> combined = [];
    for (var ft in feet) {
      {
        for (var inc in inches) {
          combined.add("$ft' $inc");
        }
      }
    }

    return combined;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection.insetGrouped(
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(kSpacing),
      children: [
        _buildCupertinoFormRow(
          context: context,
          list: _getHeightList(),
          prefix: "Height",
          name: "height",
          initialValue: "5' 0",
          firebaseUser: firebaseUser,
        ),
        _buildCupertinoFormRow(
          context: context,
          list: [for (var i = 80; i <= 600; i++) i.toString()],
          prefix: "Weight",
          name: "weight",
          initialValue: "80",
          firebaseUser: firebaseUser,
        ),
        _buildCupertinoFormRow(
          context: context,
          list: kGenders,
          prefix: "Gender",
          name: "gender",
          initialValue: "Male",
          firebaseUser: firebaseUser,
        ),
      ],
    );
  }

  CupertinoFormRow _buildCupertinoFormRow({
    required BuildContext context,
    required String name,
    required String prefix,
    required dynamic initialValue,
    required List<String> list,
    required FirebaseUser? firebaseUser,
  }) {
    Map<String, dynamic>? user = firebaseUser?.toJson();
    return CupertinoFormRow(
      prefix: Text(
        prefix,
        style: CupertinoTheme.of(context).textTheme.pickerTextStyle.copyWith(
              color: Colors.grey,
            ),
      ),
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width * .6,
        child: FormBuilderField(
            name: name,
            initialValue: user?[name] != null ? user![name] : initialValue,
            builder: (FormFieldState<dynamic> field) {
              return CupertinoPicker(
                itemExtent: 30,
                scrollController: user?[name] != null
                    ? FixedExtentScrollController(
                        initialItem: list.indexOf(user![name]))
                    : null,
                onSelectedItemChanged: (value) {
                  field.didChange(list[value]);
                },
                children: list.map((e) => Text(e)).toList(),
              );
            }),
      ),
    );
  }
}
