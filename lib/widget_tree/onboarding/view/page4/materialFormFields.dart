import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding/constants.dart';
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
          _buildExperienceSelect(context),
          const SizedBox(
            height: kSpacing,
          ),
          _buildMultiSelectFormRow(
            context: context,
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
            list: kInjuries,
            buttonText: "Do you have injuries?",
            initialState: injuries,
            prefix: "Injuries",
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSelect(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: DropdownButton<String>(
        underline: kMaterialDivider,
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
        hint: Container(
          padding: const EdgeInsets.only(
            bottom: kSpacing,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: kSpacing,
            ),
            child: Text(
              "Your experience level",
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
            ),
          ),
        ),
        isExpanded: true,
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }

  Widget _buildMultiSelectFormRow({
    required BuildContext context,
    required String prefix,
    required List<String> list,
    required String buttonText,
    required List<Object?> initialState,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: MultiSelectDialogField(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade800,
            ),
          ),
        ),
        confirmText: const Text("Ok"),
        cancelText: const Text("Cancel"),
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
          setState(() {
            initialState = values;
          });
        },
      ),
    );
  }
}
