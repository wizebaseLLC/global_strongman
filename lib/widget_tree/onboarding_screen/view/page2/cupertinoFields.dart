import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/model/list_page_data.dart';

class CupertinoFormFields extends StatelessWidget {
  const CupertinoFormFields({
    this.firebaseUser,
    Key? key,
  }) : super(key: key);

  final FirebaseUser? firebaseUser;
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
          firebaseUser: firebaseUser,
        ),
        _buildCupertinoTextField(
          placeholder: "Last Name",
          context: context,
          name: 'last_name',
          textInputAction: TextInputAction.done,
          firebaseUser: firebaseUser,
        ),
        _buildCupertinoPicker(
          context,
          firebaseUser,
        ),
      ],
    );
  }

  CupertinoFormRow _buildCupertinoPicker(
    BuildContext context,
    FirebaseUser? firebaseUser,
  ) {
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
              initialValue: firebaseUser?.age ?? 18,
              builder: (FormFieldState<dynamic> field) {
                return CupertinoPicker(
                  itemExtent: 30,
                  scrollController: firebaseUser?.age != null
                      ? FixedExtentScrollController(
                          initialItem: firebaseUser!.age! - 18)
                      : null,
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
    FirebaseUser? firebaseUser,
  }) {
    return CupertinoFormRow(
      child: FormBuilderField(
          name: name,
          builder: (FormFieldState<dynamic> field) {
            Map<String, dynamic>? user = firebaseUser?.toJson();
            return CupertinoTextFormFieldRow(
              initialValue: user != null ? user[name] : null,
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
