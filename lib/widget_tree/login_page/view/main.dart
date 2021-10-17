import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/login_page/view/header_image_and_logo.dart';
import 'package:global_strongman/widget_tree/login_page/view/signup_page.dart';
import 'package:global_strongman/widget_tree/login_page/view/textfields.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const HeaderImageAndLogo(
                  image: "assets/images/people2.webp",
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60, left: kSpacing),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Login",
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                ), //Login
                Container(
                  margin: const EdgeInsets.only(
                    top: kSpacing,
                  ),
                  child: LoginTextFields(
                    userController: _usernameController,
                    passwordController: _passwordController,
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                TextButton(
                  onPressed: () => print('send'),
                  child: Text(
                    'Forgot Password?',
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.caption?.copyWith(color: data.primaryColor),
                      cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(color: data.primaryColor, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: kSpacing * 2,
                    right: kSpacing * 2,
                  ),
                  child: PlatformButton(
                    onPressed: () => {
                      if (_formKey.currentState!.validate())
                        {
                          print(_usernameController.value.text),
                          print(_passwordController.value.text),
                        }
                    },
                    child: PlatformText('Sign In'),
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
                ),
                const SizedBox(
                  height: kSpacing * 2,
                ),
                Text(
                  'Or, login with ...',
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.caption?.copyWith(fontSize: 14),
                    cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: kSpacing * 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSignInButton(
                      button: ButtonType.facebook,
                      onPress: () {
                        print("login");
                      },
                    ),
                    _buildSignInButton(
                      button: ButtonType.google,
                      onPress: () {
                        print("login");
                      },
                    ),
                    _buildSignInButton(
                      button: ButtonType.apple,
                      onPress: () {
                        print("login");
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: kSpacing * 2,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'New to Global Strongman? ',
                        style: platformThemeData(
                          context,
                          material: (data) => data.textTheme.caption?.copyWith(fontSize: 14),
                          cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14),
                        ),
                      ),
                      TextSpan(
                        text: 'Sign up',
                        style: platformThemeData(
                          context,
                          material: (data) => data.textTheme.caption?.copyWith(fontSize: 14, color: data.primaryColor),
                          cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14, color: data.primaryColor),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupPage()),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kSpacing * 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton({required ButtonType button, required Function() onPress}) {
    return SignInButton.mini(
      buttonType: button,
      padding: kSpacing,
      onPressed: onPress,
    );
  }
}
