import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding/model/multi_select_string_chip.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CupertinoFormFields extends StatefulWidget {
  const CupertinoFormFields({
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);
  final Color backgroundColor;

  @override
  State<CupertinoFormFields> createState() => _CupertinoFormFieldsState();
}

class _CupertinoFormFieldsState extends State<CupertinoFormFields> {
  late List<Object?> goals;
  late List<Object?> injuries;

  @override
  void initState() {
    super.initState();
    goals = [];
    injuries = [];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection.insetGrouped(
      backgroundColor: widget.backgroundColor,
      margin: const EdgeInsets.all(kSpacing),
      children: [
        _buildCupertinoFormRow(
          context: context,
          list: kExperience,
          title: "Experience",
        ),
        _buildMultiSelectFormRow(
          context: context,
          list: kGoals,
          buttonText: "What are your goals?",
          initialState: goals,
          prefix: "Goals",
        ),
        _buildMultiSelectFormRow(
          context: context,
          list: kInjuries,
          buttonText: "Do you have injuries?",
          initialState: injuries,
          prefix: "Injuries",
        ),
      ],
    );
  }

  CupertinoFormRow _buildMultiSelectFormRow({
    required BuildContext context,
    required String prefix,
    required List<String> list,
    required String buttonText,
    required List<Object?> initialState,
  }) {
    return CupertinoFormRow(
      prefix: Text(
        prefix,
        style: CupertinoTheme.of(context).textTheme.pickerTextStyle.copyWith(
              color: Colors.grey,
            ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: MultiSelectDialogField(
          chipDisplay: MultiSelectChipDisplay(
            chipColor: const Color.fromRGBO(37, 81, 108, 1),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          initialValue: initialState,
          buttonIcon: Icon(
            PlatformIcons(context).rightChevron,
            size: 16,
          ),
          items: list.map((e) => MultiSelectStringChip(name: e)).toList().map((e) => MultiSelectItem(e.name, e.name)).toList(),
          listType: MultiSelectListType.CHIP,
          title: Text(prefix),
          buttonText: Text(buttonText),
          onConfirm: (values) {
            setState(() {
              initialState = values;
            });
          },
        ),
      ),
    );
  }

  CupertinoFormRow _buildCupertinoFormRow({
    required BuildContext context,
    required List<String> list,
    required String title,
  }) {
    return CupertinoFormRow(
      prefix: Text(
        title,
        style: CupertinoTheme.of(context).textTheme.pickerTextStyle.copyWith(
              color: Colors.grey,
            ),
      ),
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width * .6,
        child: CupertinoPicker(
          itemExtent: 18,
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            background: widget.backgroundColor.withOpacity(.3),
          ),
          onSelectedItemChanged: (value) {
            print(value);
          },
          children: list
              .map((x) => Text(
                    x,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
