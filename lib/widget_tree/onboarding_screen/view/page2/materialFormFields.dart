import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_user.dart';

class MaterialFormFields extends StatelessWidget {
  const MaterialFormFields({
    this.firebaseUser,
    Key? key,
  }) : super(key: key);
  final FirebaseUser? firebaseUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: kSpacing,
        bottom: kSpacing,
        left: 12,
        right: 12,
      ),
      child: Column(
        children: [
          _buildTextFormField(
              labelText: "First Name",
              name: "first_name",
              textInputAction: TextInputAction.next,
              context: context),
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
            context: context,
            firebaseUser: firebaseUser,
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
    required BuildContext context,
    required List<String> list,
    required FirebaseUser? firebaseUser,
  }) {
    return FormBuilderDropdown<String>(
      name: "age",
      initialValue: firebaseUser?.age?.toString(),
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
    );
  }
}
