import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/model/list_page_data.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/model/multi_select_string_chip.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CupertinoFormFields extends StatefulWidget {
  const CupertinoFormFields({
    Key? key,
  }) : super(key: key);

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
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(kSpacing),
      children: [
        _buildCupertinoFormRow(
          context: context,
          list: kExperience,
          title: "Experience",
          name: "experience",
          initialValue: "Beginner",
        ),
        _buildMultiSelectFormRow(
          context: context,
          list: kGoals,
          name: "goals",
          buttonText: "What are your goals?",
          initialState: goals,
          prefix: "Goals",
        ),
        _buildMultiSelectFormRow(
          context: context,
          list: kInjuries,
          name: "injuries",
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
    required String name,
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
        child: FormBuilderField(
            name: name,
            builder: (FormFieldState<dynamic> field) {
              return MultiSelectDialogField(
                backgroundColor: CupertinoTheme.of(context).barBackgroundColor.withOpacity(1),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                selectedColor: kPrimaryColor,
                selectedItemsTextStyle: const TextStyle(color: Colors.white),
                confirmText: const Text(
                  "Ok",
                  style: TextStyle(color: Colors.blue),
                ),
                cancelText: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.blue),
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
                  field.didChange(values);
                },
              );
            }),
      ),
    );
  }

  CupertinoFormRow _buildCupertinoFormRow({
    required BuildContext context,
    required List<String> list,
    required String title,
    required String name,
    required String initialValue,
  }) {
    return CupertinoFormRow(
      prefix: Text(
        title,
        style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
      ),
      child: SizedBox(
        height: 120,
        width: MediaQuery.of(context).size.width * .6,
        child: FormBuilderField(
            name: name,
            initialValue: initialValue,
            builder: (FormFieldState<dynamic> field) {
              return CupertinoPicker(
                itemExtent: 22,
                onSelectedItemChanged: (value) {
                  field.didChange(list[value]);
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
              );
            }),
      ),
    );
  }
}
