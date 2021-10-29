import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding/model/multi_select_string_chip.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MaterialFormFields extends StatefulWidget {
  const MaterialFormFields({
    Key? key,
  }) : super(key: key);

  @override
  State<MaterialFormFields> createState() => _MaterialFormFieldsState();
}

class _MaterialFormFieldsState extends State<MaterialFormFields> {
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
    return Container(
      padding: const EdgeInsets.only(
        top: kSpacing,
        bottom: kSpacing,
      ),
      child: Column(
        children: [
          _buildExperienceSelect(
            context: context,
            name: "experience",
          ),
          const SizedBox(
            height: kSpacing,
          ),
          _buildMultiSelectFormRow(
            context: context,
            name: "goals",
            list: kGoals,
            buttonText: "What are your goals?",
            initialState: goals,
            prefix: "Goals",
          ),
          const SizedBox(
            height: kSpacing,
          ),
          _buildMultiSelectFormRow(
            context: context,
            name: "injuries",
            list: kInjuries,
            buttonText: "Do you have injuries?",
            initialState: injuries,
            prefix: "Injuries",
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSelect({
    required BuildContext context,
    required String name,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: FormBuilderDropdown<String>(
        name: name,
        validator: FormBuilderValidators.required(context),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.only(left: 12),
          label: Text("Your experience level"),
        ),
        icon: Container(
          padding: const EdgeInsets.only(
            right: 10,
          ),
          child: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey.shade700,
          ),
        ),
        items: kExperience.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
      ),
    );
  }

  Widget _buildMultiSelectFormRow({
    required BuildContext context,
    required String prefix,
    required String name,
    required List<String> list,
    required String buttonText,
    required List<Object?> initialState,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: FormBuilderField(
          name: name,
          builder: (FormFieldState<dynamic> field) {
            return MultiSelectDialogField(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade600,
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
                chipColor: const Color.fromRGBO(37, 81, 108, 1),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              initialValue: initialState,
              buttonIcon: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey.shade700,
              ),
              items: list.map((e) => MultiSelectStringChip(name: e)).toList().map((e) => MultiSelectItem(e.name, e.name)).toList(),
              listType: MultiSelectListType.CHIP,
              buttonText: Text(
                buttonText,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
              ),
              onConfirm: (values) {
                field.didChange(values);
              },
            );
          }),
    );
  }
}
