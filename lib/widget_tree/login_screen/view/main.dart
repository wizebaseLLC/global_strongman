import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/bottom_navigator/view/main.dart';
import 'package:global_strongman/widget_tree/login_screen/controller/sign_in_controller.dart';
import 'package:global_strongman/widget_tree/login_screen/view/header_image_and_logo.dart';
import 'package:global_strongman/widget_tree/login_screen/view/signup_page.dart';
import 'package:global_strongman/widget_tree/login_screen/view/textfields.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLoginWithEmail(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      SignInController signupController = SignInController(
        userController: _usernameController,
        passwordController: _passwordController,
      );

      signupController.handleSignInFromEmail(context);
    }
  }

  void _handleSocialLogin(
    ButtonType buttonType,
    BuildContext context,
  ) {
    SignInController()
        .handleSocialLogin(buttonType: buttonType, context: context);
  }

  @override
  void initState() {
    SignInController().getSignedInUserFromFireStore().then((bool userExist) => {
          if (userExist)
            {
              Navigator.pushReplacement(
                context,
                platformPageRoute(
                  context: context,
                  builder: (context) => const BottomNavigator(),
                ),
              ),
            }
        });

    super.initState();
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
                    image: "assets/images/people2.webp",
                  ),
                  _buildLoginTextHeader(context), //Login
                  _buildLoginTextFields(),
                  const SizedBox(
                    height: kSpacing,
                  ),
                  _buildForgotPasswordButton(context),
                  const SizedBox(
                    height: kSpacing,
                  ),
                  _buildSignInButtonWidget(context),
                  const SizedBox(
                    height: kSpacing * 2,
                  ),
                  _buildOrLoginWithText(context),
                  const SizedBox(
                    height: kSpacing * 2,
                  ),
                  _buildSocialLoginButtons(context),
                  const SizedBox(
                    height: kSpacing * 2,
                  ),
                  _buildSignupText(context),
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

  Container _buildLoginTextHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60, left: kSpacing),
      alignment: Alignment.topLeft,
      child: Text(
        "Login",
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

  Container _buildLoginTextFields() {
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

  TextButton _buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () => SignInController().handleForgotPassword(context),
      child: Text(
        'Forgot Password?',
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.caption?.copyWith(
            color: Colors.blue,
          ),
          cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(
            color: Colors.blue,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Container _buildSignInButtonWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: kSpacing * 2,
        right: kSpacing * 2,
      ),
      child: PlatformElevatedButton(
        onPressed: () => _handleLoginWithEmail(context),
        child: PlatformText(
          'Sign In',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        material: (_, __) => MaterialElevatedButtonData(
          style: ElevatedButton.styleFrom(
            primary: kPrimaryColor,
          ),
        ),
        cupertino: (_, __) => CupertinoElevatedButtonData(
          color: kPrimaryColor,
          originalStyle: true,
        ),
      ),
    );
  }

  Text _buildOrLoginWithText(BuildContext context) {
    return Text(
      'Or, login with ...',
      style: platformThemeData(
        context,
        material: (data) => data.textTheme.caption?.copyWith(fontSize: 14),
        cupertino: (data) =>
            data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14),
      ),
    );
  }

  Row _buildSocialLoginButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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

  RichText _buildSignupText(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'New to Global Strongman? ',
            style: platformThemeData(
              context,
              material: (data) =>
                  data.textTheme.caption?.copyWith(fontSize: 14),
              cupertino: (data) =>
                  data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14),
            ),
          ),
          TextSpan(
            text: 'Sign up',
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
              ..onTap = () => Navigator.push(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (context) => const SignupPage(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton(
      {required ButtonType button, required Function() onPress}) {
    return InkWell(
      onTap: onPress,
      child: SignInButton.mini(
        buttonType: button,
        padding: kSpacing,
        onPressed: onPress,
      ),
    );
  }
}
