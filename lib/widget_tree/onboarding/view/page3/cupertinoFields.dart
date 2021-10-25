import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';

class CupertinoFormFields extends StatelessWidget {
  const CupertinoFormFields({
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);
  final Color backgroundColor;

  List<Widget> _getHeightList() {
    List<int> feet = [for (var i = 4; i <= 8; i++) i];
    List<int> inches = [for (var i = 1; i <= 11; i++) i];
    List<String> combined = [];
    for (var ft in feet) {
      {
        for (var inc in inches) {
          combined.add("$ft' $inc");
        }
      }
    }

    return combined.map((e) => Text(e)).toList();
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
          onChanged: (value) {
            print(value + 1);
          },
        ),
        _buildCupertinoFormRow(
          context: context,
          list: [for (var i = 60; i <= 600; i++) Text(i.toString())],
          prefix: "Weight",
          onChanged: (value) {
            print(value + 1);
          },
        ),
        _buildCupertinoFormRow(
          context: context,
          list: kGenders.map((gender) => Text(gender)).toList(),
          prefix: "Gender",
          onChanged: (value) {
            print(value + 1);
          },
        ),
      ],
    );
  }

  CupertinoFormRow _buildCupertinoFormRow({
    required BuildContext context,
    required String prefix,
    required List<Widget> list,
    required Function(int) onChanged,
  }) {
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
        child: CupertinoPicker(
          itemExtent: 30,
          onSelectedItemChanged: onChanged,
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            background: backgroundColor.withOpacity(.4),
          ),
          children: list,
        ),
      ),
    );
  }
}
