import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:global_strongman/constants.dart';

class MaterialFormFields extends StatelessWidget {
  const MaterialFormFields({
    Key? key,
  }) : super(key: key);

  List<String> _getHeightList() {
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
    return combined;
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
          _buildMaterialField(
            hint: "Height",
            name: 'height',
            list: _getHeightList(),
            context: context,
          ),
          const SizedBox(
            height: kSpacing,
          ),
          _buildMaterialField(
            hint: "Weight",
            name: "weight",
            list: [for (var i = 60; i <= 600; i++) i.toString()],
            context: context,
          ),
          const SizedBox(
            height: kSpacing,
          ),
          _buildMaterialField(
            hint: "Gender",
            name: "gender",
            list: kGenders,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialField({
    required String hint,
    required String name,
    required BuildContext context,
    required List<String> list,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: FormBuilderDropdown<String>(
        name: name,
        validator: FormBuilderValidators.required(context),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(left: 12, right: 9),
          label: Text(hint),
        ),
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
      ),
    );
  }
}
