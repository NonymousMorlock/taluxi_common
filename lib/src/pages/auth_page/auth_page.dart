import 'package:flutter/material.dart';

import 'package:taluxi_common/src/pages/auth_page/auth_page_widgets/bezier_container.dart';
import 'package:taluxi_common/src/pages/auth_page/auth_page_widgets/forms/login_form.dart';
import 'package:taluxi_common/src/pages/auth_page/auth_page_widgets/forms/signup_form.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({required this.authType, super.key});
  final AuthType authType;

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState(authType);
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  _AuthenticationPageState(this.authType);
  AuthType authType;

  @override
  Widget build(BuildContext context) {
    final Widget form = authType == AuthType.login
        ? LoginForm(
            onSignUpRequest: () => setState(() => authType = AuthType.signUp),
          )
        : SignUpForm(
            onLoginRequest: () => setState(() => authType = AuthType.login),
          );

    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: screenSize.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -screenSize.height * .11,
                right: -screenSize.width * .38,
                child: const BezierContainer(),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: form,
                ),
              ),
              SafeArea(
                child: BackButton(
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AuthType { login, signUp }
