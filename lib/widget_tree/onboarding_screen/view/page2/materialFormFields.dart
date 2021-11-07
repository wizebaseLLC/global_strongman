import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:global_strongman/constants.dart';

class MaterialFormFields extends StatelessWidget {
  const MaterialFormFields({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: kSpacing,
        bottom: kSpacing,
        left: kSpacing,
        right: kSpacing,
      ),
      child: Column(
        children: [
          _buildTextFormField(labelText: "First Name", name: "first_name", textInputAction: TextInputAction.next, context: context),
          const SizedBox(
            height: kSpacing,
          ),
          _buildTextFormField(
            labelText: "Last Name",
            name: "last_name",
            context: context,
          ),
          const SizedBox(
            height: 12,
          ),
          _buildMaterialField(
            hint: "Age",
            list: [for (var i = 18; i <= 99; i++) i.toString()],
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    TextInputAction? textInputAction,
    required String name,
    required BuildContext context,
  }) {
    return FormBuilderTextField(
      name: name,
      // Todo  controller: userController,
      textInputAction: textInputAction ?? TextInputAction.done,
      validator: FormBuilderValidators.compose(
        [
          FormBuilderValidators.minLength(context, 3),
          FormBuilderValidators.required(context),
        ],
      ),
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
  }) {
    return FormBuilderDropdown<String>(
      name: "age",
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.only(left: 12),
        label: Text(hint),
      ),
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      isExpanded: true,
    );
  }
}
