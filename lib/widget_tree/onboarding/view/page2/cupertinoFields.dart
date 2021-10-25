import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';

class CupertinoFormFields extends StatelessWidget {
  const CupertinoFormFields({
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection.insetGrouped(
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(kSpacing),
      children: [
        _buildCupertinoTextField(placeholder: "First Name"),
        _buildCupertinoTextField(placeholder: "Last Name", textInputAction: TextInputAction.done),
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
          child: CupertinoPicker(
            itemExtent: 30,
            onSelectedItemChanged: (value) {
              print(value + 18);
            },
            selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: backgroundColor.withOpacity(.5),
            ),
            children: [for (var i = 18; i <= 99; i++) Text(i.toString())],
          ),
        ),
      ),
    );
  }

  CupertinoFormRow _buildCupertinoTextField({
    required String placeholder,
    TextInputAction? textInputAction,
  }) {
    return CupertinoFormRow(
      child: CupertinoTextFormFieldRow(
        placeholder: placeholder,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //TODO controller: userController,
        textInputAction: textInputAction ?? TextInputAction.next,
        //TODO validator: _validateEmail,
      ),
    );
  }
}
