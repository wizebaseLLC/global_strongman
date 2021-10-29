import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/login_page/view/header_image_and_logo.dart';
import 'package:global_strongman/widget_tree/login_page/view/textfields.dart';
import 'package:sign_button/sign_button.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleSignupFromEmail() {
    if (_formKey.currentState!.validate()) {
      print(_usernameController.value.text);
      print(_passwordController.value.text);
    }
  }

  void _handleSocialLogin(ButtonType buttonType) {
    print(buttonType.toString());
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
                  _buildSocialLoginButtons(),
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

  Column _buildSocialLoginButtons() {
    return Column(
      children: [
        _buildSignInButton(
          button: ButtonType.facebook,
          onPress: () => _handleSocialLogin(ButtonType.facebook),
        ),
        _buildSignInButton(
          button: ButtonType.google,
          onPress: () => _handleSocialLogin(ButtonType.google),
        ),
        _buildSignInButton(
          button: ButtonType.apple,
          onPress: () => _handleSocialLogin(ButtonType.apple),
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
        cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14),
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
        onPressed: _handleSignupFromEmail,
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
              material: (data) => data.textTheme.caption?.copyWith(fontSize: 14),
              cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14),
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

  Widget _buildSignInButton({required ButtonType button, required Function() onPress}) {
    return Container(
      padding: const EdgeInsets.only(left: kSpacing * 4, right: kSpacing * 4, bottom: kSpacing),
      child: SignInButton(
        buttonType: button,
        onPressed: onPress,
        width: double.infinity,
      ),
    );
  }
}
