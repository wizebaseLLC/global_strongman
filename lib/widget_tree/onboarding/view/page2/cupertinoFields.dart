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
        CupertinoFormRow(
          child: CupertinoTextFormFieldRow(
            placeholder: "First Name",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //TODO controller: userController,
            textInputAction: TextInputAction.next,
            //TODO validator: _validateEmail,
          ),
        ),
        CupertinoFormRow(
          child: CupertinoTextFormFieldRow(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //TODO controller: passwordController,
            textInputAction: TextInputAction.done,
            placeholder: "Last Name",
            //TODO validator: _validatePassword,
          ),
        ),
        CupertinoFormRow(
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
                children: [for (var i = 18; i <= 99; i++) Text(i.toString())],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
