import 'package:flutter/material.dart';
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
          combined.add("$ft'$inc");
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
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: DropdownButton<String>(
              items: _getHeightList().map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text("Height"),
              isExpanded: true,
              onChanged: (value) {
                print(value);
              },
            ),
          ),
          const SizedBox(
            height: kSpacing,
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: DropdownButton<String>(
              items: [for (var i = 60; i <= 600; i++) i.toString()].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text("Weight"),
              isExpanded: true,
              onChanged: (value) {
                print(value);
              },
            ),
          ),
          const SizedBox(
            height: kSpacing,
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: DropdownButton<String>(
              items: kGenders.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text("Gender"),
              isExpanded: true,
              onChanged: (value) {
                print(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
