import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding/constants.dart';

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
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: kSpacing,
        bottom: kSpacing,
      ),
      child: Column(
        children: [
          _buildMaterialField(
              hint: "Height",
              list: _getHeightList(),
              onChanged: (value) {
                print(value);
              }),
          const SizedBox(
            height: kSpacing,
          ),
          _buildMaterialField(
              hint: "Weight",
              list: [for (var i = 60; i <= 600; i++) i.toString()],
              onChanged: (value) {
                print(value);
              }),
          const SizedBox(
            height: kSpacing,
          ),
          _buildMaterialField(
              hint: "Gender",
              list: kGenders,
              onChanged: (value) {
                print(value);
              }),
        ],
      ),
    );
  }

  Widget _buildMaterialField({
    required String hint,
    required List<String> list,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: DropdownButton<String>(
        underline: kMaterialDivider,
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: Text(hint),
        isExpanded: true,
        onChanged: onChanged,
      ),
    );
  }
}
