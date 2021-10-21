import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/list_icon_cupertino.dart';

/// Platform aware text-fields.
class LoginTextFields extends StatelessWidget {
  const LoginTextFields({
    required this.userController,
    required this.passwordController,
    Key? key,
  }) : super(key: key);

  final TextEditingController userController;
  final TextEditingController passwordController;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);

    if (!emailValid) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    if (value.length < 6) {
      return 'Please enter at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (_, __) => Container(
        margin: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          children: [
            TextFormField(
              controller: userController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person),
              ),
              validator: _validateEmail,
            ),
            TextFormField(
              controller: passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.done,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
              validator: _validatePassword,
            ),
          ],
        ),
      ),
      cupertino: (_, __) => CupertinoFormSection.insetGrouped(
        margin: const EdgeInsets.all(kSpacing),
        children: [
          CupertinoFormRow(
            prefix: const ListIconCupertino(
              icon: CupertinoIcons.person_alt,
              gradient: kPrimaryGradient,
            ),
            child: CupertinoTextFormFieldRow(
              placeholder: "Username",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: userController,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
            ),
          ),
          CupertinoFormRow(
            prefix: const ListIconCupertino(
              icon: CupertinoIcons.lock_fill,
              gradient: kPrimaryGradient,
            ),
            child: CupertinoTextFormFieldRow(
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: passwordController,
              textInputAction: TextInputAction.done,
              placeholder: "Password",
              validator: _validatePassword,
            ),
          ),
        ],
      ),
    );
  }
}
