import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/login_screen/controller/sign_in_controller.dart';
import 'package:global_strongman/widget_tree/login_screen/view/header_image_and_logo.dart';
import 'package:global_strongman/widget_tree/login_screen/view/textfields.dart';
import 'package:sign_button/sign_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleSignupFromEmail(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      SignInController signupController = SignInController(
        userController: _usernameController,
        passwordController: _passwordController,
      );

      signupController.handleSignupFromEmail(context);
    }
  }

  void _handleSocialLogin(
    ButtonType buttonType,
    BuildContext context,
  ) {
    SignInController().handleSocialLogin(
      buttonType: buttonType,
      context: context,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const HeaderImageAndLogo(
                    image: "assets/images/people.webp",
                  ),
                  _buildSignupTextHeader(context), //Login
                  const SizedBox(
                    height: kSpacing * 2,
                  ),
                  _buildSocialLoginButtons(context),
                  const SizedBox(
                    height: kSpacing,
                  ),
                  _buildRegisterWithEmailText(context),
                  _buildTextFields(),
                  const SizedBox(
                    height: kSpacing * 2,
                  ),
                  _buildSignUpButton(context),

                  const SizedBox(
                    height: kSpacing * 2,
                  ),

                  _buildSignInText(context),
                  const SizedBox(
                    height: kSpacing * 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildSignupTextHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60, left: kSpacing),
      alignment: Alignment.topLeft,
      child: Text(
        "Signup",
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.headline4?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          cupertino: (data) => data.textTheme.navLargeTitleTextStyle,
        ),
      ),
    );
  }

  Column _buildSocialLoginButtons(BuildContext context) {
    return Column(
      children: [
        _buildSignInButton(
          button: ButtonType.facebook,
          onPress: () => _handleSocialLogin(ButtonType.facebook, context),
        ),
        _buildSignInButton(
          button: ButtonType.google,
          onPress: () => _handleSocialLogin(ButtonType.google, context),
        ),
        if (Platform.isIOS)
          _buildSignInButton(
            button: ButtonType.apple,
            onPress: () => _handleSocialLogin(ButtonType.apple, context),
          ),
      ],
    );
  }

  Text _buildRegisterWithEmailText(BuildContext context) {
    return Text(
      'Or, register with email ...',
      style: platformThemeData(
        context,
        material: (data) => data.textTheme.caption?.copyWith(fontSize: 14),
        cupertino: (data) =>
            data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14),
      ),
    );
  }

  Container _buildTextFields() {
    return Container(
      margin: const EdgeInsets.only(
        top: kSpacing,
      ),
      child: LoginTextFields(
        userController: _usernameController,
        passwordController: _passwordController,
      ),
    );
  }

  Container _buildSignUpButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: kSpacing * 2,
        right: kSpacing * 2,
      ),
      child: PlatformButton(
        onPressed: () => _handleSignupFromEmail(context),
        child: PlatformText(
          'Sign Up',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        material: (_, __) => MaterialRaisedButtonData(
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            )),
        cupertino: (_, __) => CupertinoButtonData(),
        color: platformThemeData(
          context,
          material: (data) => data.primaryColor,
          cupertino: (data) => data.primaryColor,
        ),
      ),
    );
  }

  RichText _buildSignInText(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Have an account? ',
            style: platformThemeData(
              context,
              material: (data) =>
                  data.textTheme.caption?.copyWith(fontSize: 14),
              cupertino: (data) =>
                  data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14),
            ),
          ),
          TextSpan(
            text: 'Log in',
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.caption?.copyWith(
                fontSize: 14,
                color: Colors.blue,
              ),
              cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Navigator.pop(
                    context,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton(
      {required ButtonType button, required Function() onPress}) {
    return Container(
      padding: const EdgeInsets.only(
          left: kSpacing * 4, right: kSpacing * 4, bottom: kSpacing),
      child: SignInButton(
        buttonType: button,
        onPressed: onPress,
        width: double.infinity,
      ),
    );
  }
}
