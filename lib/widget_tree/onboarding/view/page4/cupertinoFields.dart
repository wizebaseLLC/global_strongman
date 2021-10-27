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
        style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: MultiSelectDialogField(
          backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
          chipDisplay: MultiSelectChipDisplay(
            chipColor: kPrimaryColor,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          initialValue: initialState,
          buttonIcon: Icon(
            PlatformIcons(context).rightChevron,
            size: 16,
            color: Colors.grey.shade700,
          ),
          items: list
              .map((e) => MultiSelectStringChip(name: e))
              .toList()
              .map((e) => MultiSelectItem(
                    e.name,
                    e.name,
                  ))
              .toList(),
          listType: MultiSelectListType.CHIP,
          title: Text(prefix,
              style: const TextStyle(
                color: Colors.white,
              )),
          buttonText: Text(
            buttonText,
            style: CupertinoTheme.of(context).textTheme.pickerTextStyle.copyWith(
                  color: Colors.white60,
                  fontSize: 16,
                ),
          ),
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
        style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
      ),
      child: SizedBox(
        height: 120,
        width: MediaQuery.of(context).size.width * .6,
        child: CupertinoPicker(
          itemExtent: 22,
          onSelectedItemChanged: (value) {
            print(value);
          },
          children: list
              .map((x) => Center(
                    child: Text(
                      x,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
