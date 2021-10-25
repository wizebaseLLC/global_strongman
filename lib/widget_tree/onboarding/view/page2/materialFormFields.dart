import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';

class MaterialFormFields extends StatelessWidget {
  const MaterialFormFields({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: kSpacing,
        bottom: kSpacing,
        left: kSpacing,
        right: kSpacing,
      ),
      child: Column(
        children: [
          _buildTextFormField(labelText: "First Name"),
          const SizedBox(
            height: kSpacing,
          ),
          _buildTextFormField(labelText: "Last Name"),
          const SizedBox(
            height: kSpacing,
          ),
          _buildMaterialField(
              hint: "Age",
              list: [for (var i = 18; i <= 99; i++) i.toString()],
              onChanged: (value) {
                print(value);
              }),
        ],
      ),
    );
  }

  Widget _buildTextFormField({required String labelText}) {
    return TextFormField(
      // Todo  controller: userController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.done,

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 12, right: 12),
        labelText: labelText,
      ),
      // Todo  validator: _validateEmail,
    );
  }

  Widget _buildMaterialField({
    required String hint,
    required List<String> list,
    required Function(String?) onChanged,
  }) {
    return DropdownButton<String>(
      underline: Divider(
        height: 1,
        thickness: .75,
        color: Colors.grey.shade500,
      ),
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Container(
        margin: const EdgeInsets.only(
          left: 12,
          bottom: 12,
        ),
        child: Text(hint),
      ),
      isExpanded: true,
      onChanged: onChanged,
    );
  }
}
