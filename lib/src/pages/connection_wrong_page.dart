import 'package:flutter/material.dart';

class ConnectionWrongPage extends StatelessWidget {
  const ConnectionWrongPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      width: deviceSize.width,
      height: deviceSize.height,
      child: SafeArea(
        child: Column(
          children: [
            const Text('Oups!', textScaler: TextScaler.linear(1.5)),
            Container(
              width: deviceSize.width,
              height: deviceSize.height * 0.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/animations/connection_wrong_animation.gif',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Card(
              elevation: 7,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Une erreur est survenue lors de la tentative de '
                  'connexion aux serveurs. Veuillez véfiriez votre '
                  'connexion internet puis réessayez.',
                  textScaler: TextScaler.linear(1.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
