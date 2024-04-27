import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:taluxi_common/src/core/utils/form_fields_validators.dart';
import 'package:taluxi_common/src/core/widgets/core_widgts.dart';
import 'package:taluxi_common/src/pages/auth_page/auth_page_widgets/forms/commons_form_widgets.dart';
import 'package:user_manager/user_manager.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({required this.onSignUpRequest, super.key});
  final void Function() onSignUpRequest;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String password = '';
  String email = '';
  final _formKey = GlobalKey<FormState>();
  bool waitDialogIsShown = false;
  late AuthenticationProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthenticationProvider>();
    authProvider.addListener(() {
      if (authProvider.authState == AuthState.authenticating) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration.zero, () {
            print('Login form');
            waitDialogIsShown = true;
            showWaitDialog('Connexion en cours', context);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    authProvider.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: height * .27),
          const Text(
            'Connexion',
            textScaleFactor: 1.88,
          ),
          SizedBox(height: height * .09),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
          ),
          const SizedBox(
            height: 25,
          ),
          FormValidatorButton(
            onClick: () async {
              if (_formKey.currentState!.validate()) {
                await authProvider
                    .signInWithEmailAndPassword(
                        email: email, password: password)
                    .then(
                      (_) => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                    )
                    .catchError(_onSignInError);
              }
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            margin: const EdgeInsets.only(right: 7, top: 10),
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              child: const Text(
                'Mot de passe oublié ?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: height * .055),
          _signUpFormLink(),
        ],
      ),
    );
  }

  Future<void> _onSignInError(exception) async {
    if (waitDialogIsShown) {
      Navigator.of(context).pop();
      waitDialogIsShown = false;
    }
    if(exception is AuthenticationException) debugPrint(exception.message);
    else debugPrint(exception.toString());
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Echec de la connexion'),
          content: Text(exception.message),
          actions: [
            if (exception.exceptionType ==
                AuthenticationExceptionType
                    .accountExistsWithDifferentCredential)
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await authProvider
                        .signInWithFacebook()
                        .then(
                          (_) => Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                        )
                        .catchError(_onSignInError);
                  },
                  child: const Text('Se connecter avec Facebook'),
                ),
              )
            else
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

  Widget _signUpFormLink() {
    return InkWell(
      onTap: widget.onSignUpRequest,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pas encore inscrit ?  ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              'Cliquez ici pour le faire',
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
