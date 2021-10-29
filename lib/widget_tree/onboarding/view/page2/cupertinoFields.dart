import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding/model/list_page_data.dart';

class CupertinoFormFields extends StatelessWidget {
  const CupertinoFormFields({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection.insetGrouped(
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(kSpacing),
      children: [
        _buildCupertinoTextField(
          placeholder: "First Name",
          context: context,
          name: 'first_name',
        ),
        _buildCupertinoTextField(
          placeholder: "Last Name",
          context: context,
          name: 'last_name',
          textInputAction: TextInputAction.done,
        ),
        _buildCupertinoPicker(context),
      ],
    );
  }

  CupertinoFormRow _buildCupertinoPicker(BuildContext context) {
    return CupertinoFormRow(
      prefix: Text(
        'Age',
        style: CupertinoTheme.of(context).textTheme.pickerTextStyle.copyWith(
              color: Colors.grey,
            ),
      ),
      child: SizedBox(
        height: 130,
        width: MediaQuery.of(context).size.width * .6,
        child: Center(
          child: FormBuilderField(
              name: 'age',
              initialValue: 18,
              builder: (FormFieldState<dynamic> field) {
                return CupertinoPicker(
                  itemExtent: 30,
                  onSelectedItemChanged: (value) {
                    field.didChange(value + 18);
                  },
                  children: [for (var i = 18; i <= 99; i++) Text(i.toString())],
                );
              }),
        ),
      ),
    );
  }

  CupertinoFormRow _buildCupertinoTextField({
    required String placeholder,
    required String name,
    required BuildContext context,
    TextInputAction? textInputAction,
  }) {
    return CupertinoFormRow(
      child: FormBuilderField(
          name: name,
          builder: (FormFieldState<dynamic> field) {
            return CupertinoTextFormFieldRow(
              placeholder: placeholder,
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.minLength(context, 3),
                  FormBuilderValidators.required(context),
                ],
              ),
              textInputAction: textInputAction ?? TextInputAction.next,
              onChanged: (value) => field.didChange(value),
            );
          }),
    );
  }
}
