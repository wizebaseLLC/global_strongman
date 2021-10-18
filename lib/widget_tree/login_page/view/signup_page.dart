import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
                  image: "assets/images/people.webp",
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60, left: kSpacing),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Signup",
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                ), //Login
                const SizedBox(
                  height: kSpacing * 2,
                ),
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
                ), //Login Buttons
                const SizedBox(
                  height: kSpacing,
                ),
                Text(
                  'Or, register with email ...',
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.caption?.copyWith(fontSize: 14),
                    cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14),
                  ),
                ),
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
                  height: kSpacing * 2,
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
                    child: PlatformText('Sign Up'),
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

                RichText(
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
                          material: (data) => data.textTheme.caption?.copyWith(fontSize: 14, color: data.primaryColor),
                          cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(fontSize: 14, color: data.primaryColor),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pop(
                                context,
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
