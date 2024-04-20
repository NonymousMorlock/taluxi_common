import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taluxi_common/src/core/utils/form_fields_validators.dart';
import 'package:taluxi_common/src/core/widgets/core_widgts.dart';
import 'package:taluxi_common/src/pages/auth_page/auth_page_widgets/forms/commons_form_widgets.dart';
import 'package:user_manager/user_manager.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({required this.onLoginRequest, super.key});
  final void Function() onLoginRequest;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  bool waitDialogIsShown = false;
  late AuthenticationProvider authProvider;
  Timer? facebookSignInSuggestionTimer;

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthenticationProvider>();
    facebookSignInSuggestionTimer = Timer(
      const Duration(milliseconds: 1100),
      _showFacebookSignInSuggestion,
    );
  }

  @override
  void dispose() {
    facebookSignInSuggestionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    authProvider = Provider.of<AuthenticationProvider>(context);
    if (authProvider.authState == AuthState.registering) {
      Future.delayed(Duration.zero, () async {
        waitDialogIsShown = true;
        showWaitDialog('Inscription en cours', context);
      });
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: height * .14),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(4),
            child: const Text(
              'Inscription ',
              textScaler: TextScaler.linear(1.7),
            ),
          ),
          const SizedBox(height: 30),
          _form(),
          const SizedBox(
            height: 15,
          ),
          FormValidatorButton(
            onClick: () async {
              if (_formKey.currentState!.validate()) {
                await authProvider
                    .registerUser(
                      email: email,
                      password: password,
                      firstName: firstName,
                      lastName: lastName,
                    )
                    .then(
                      (_) => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                    )
                    .catchError(_onSignUpError);
              }
            },
          ),
          _formLoginLink(),
        ],
      ),
    );
  }

  Future<void> _onSignUpError(dynamic error) async {
    if (waitDialogIsShown) {
      Navigator.of(context).pop();
      waitDialogIsShown = false;
    }
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Echec de la connexion'),
          content: Text(error.message),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fermer'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomTextField(
            onChange: (value) => lastName = value,
            prefixIcon: const Icon(Icons.person),
            maxLength: 30,
            title: 'Nom',
            validator: namesValidator,
          ),
          CustomTextField(
            onChange: (value) => firstName = value,
            prefixIcon: const Icon(Icons.person_outline),
            maxLength: 30,
            title: 'Prénom',
            validator: namesValidator,
          ),
          CustomTextField(
            onChange: (value) => email = value,
            title: 'Email',
            prefixIcon: const Icon(Icons.email_rounded),
            fieldType: TextInputType.emailAddress,
            validator: emailFieldValidator,
          ),
          const SizedBox(
            height: 16,
          ),
          PasswordField(
            onChanged: (value) => password = value,
          ),
        ],
      ),
    );
  }

  Future<void> _showFacebookSignInSuggestion() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Recommendation'),
          content: const Text(
            "Cher utilisateur, si vous avez un compte Facebook il n'est pas nécessaire de créer un compte Taluxi, vous pouvez vous connecter à Taluxi à l'aide de votre compte Facebook. C'est plus facile et plus rapide,\nMerci de votre compréhension.",
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await authProvider
                      .signInWithFacebook()
                      .then(
                        (_) => Navigator.of(context)
                            .popUntil((route) => route.isFirst),
                      )
                      .catchError(_onSignUpError);
                },
                child: const Text("Me connecter à l'aide de Facebook"),
              ),
            ),
            Center(
              child: ElevatedButton(
                child: const Text('Créer un nouveau compte'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _formLoginLink() {
    return Container(
      margin: const EdgeInsets.only(top: 35),
      padding: const EdgeInsets.symmetric(vertical: 7),
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: widget.onLoginRequest,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 27,
            ),
            Text(
              'Déjà inscrit ?  ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              'Cliquez ici pour vous connecter',
              style: TextStyle(
                color: Color(0xfff79c4f),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
