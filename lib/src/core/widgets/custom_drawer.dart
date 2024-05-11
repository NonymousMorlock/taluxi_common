import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:taluxi_common/src/core/constants/colors.dart';
import 'package:taluxi_common/src/core/widgets/core_widgts.dart';
import 'package:user_manager/user_manager.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late User _user;
  final menuTextStyle =
      const TextStyle(color: Color(0xFF373737), fontSize: 16.5);

  @override
  void initState() {
    super.initState();
    _user = AuthenticationProvider.instance.user!;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            children: [
              DrawerHeader(
                decoration: _user.photoUrl == null || _user.photoUrl!.isEmpty
                    ? const BoxDecoration(gradient: mainLinearGradient)
                    : BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(_user.photoUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    color: Colors.black26,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _userAdditionalDataWidget(
                          'Total des trajets',
                          '${_user.rideCount}',
                        ),
                        const VerticalDivider(color: Colors.white),
                        _userAdditionalDataWidget(
                          'Note moyenne',
                          '${_user.rideCount}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Voir l'historique de vos trajets",
                  style: menuTextStyle,
                ),
                trailing: const Icon(
                  Icons.history,
                  color: Colors.black38,
                ),
                onTap: () => _showScrollableDialog(
                  ListView(
                    children: _buildHistoryListTiles(),
                  ),
                  'Historique de trajets',
                ),
              ),
              ListTile(
                title: Text(
                  'Voir vos médailles',
                  style: menuTextStyle,
                ),
                trailing: SvgPicture.asset(
                  'assets/images/medal.svg',
                  width: 24,
                  height: 24,
                  // color: Colors.black54,
                ),
                onTap: () => _showScrollableDialog(
                  GridView.count(
                    crossAxisCount: 2,
                    children: _buildTrophiesList(),
                  ),
                  'Médailles',
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              tileColor: const Color(0xFFF1F1F1),
              onTap: () async {
                showWaitDialog('Déconnexion en cours', context);
                await context
                    .read<AuthenticationProvider>()
                    .signOut()
                    .then(
                      (_) => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                    )
                    .catchError((e) => _onSignOutFailed(e, context));
              },
              title: const Text('Se déconnecter'),
              trailing: const Icon(
                Icons.logout,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userAdditionalDataWidget(String title, String count) {
    const textStyle = TextStyle(color: Colors.white);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          title,
          style: textStyle,
        ),
        Text(
          count,
          textScaler: const TextScaler.linear(1.2),
          style: textStyle,
        ),
      ],
    );
  }

  Future<void> _onSignOutFailed(exception, BuildContext context) async {
    Navigator.of(context).pop();
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Une erreur est survenue lors de la déconnexion'),
          content: Text(exception.message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  List<ListTile> _buildHistoryListTiles() {
    final menuItems = <ListTile>[];
    _user.rideCountHistory?.forEach((historyDate, rideCount) {
      menuItems.add(
        ListTile(
          title: Text(historyDate),
          trailing: Text('$rideCount'),
        ),
      );
    });
    return menuItems;
  }

  Future<void> _showScrollableDialog(Widget child, String title) async {
    final screenSize = MediaQuery.of(context).size;
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: screenSize.width * .9,
          height: screenSize.height * .4,
          child: child,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fermer'),
          ),
        ],
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        titlePadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  List<Trophy> _buildTrophiesList() {
    final trophiesList = <Trophy>[];
    UserDataRepository.trophiesList.forEach((trophyLevel, trophy) {
      trophiesList.add(
        Trophy(
          level: trophyLevel,
          active: _user.trophies?.contains(trophyLevel) ?? false,
        ),
      );
    });
    return trophiesList;
  }
}
