import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:taluxi_common/src/core/constants/colors.dart';
import 'package:taluxi_common/src/core/widgets/core_widgts.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({super.key, this.message});
  final String? message;

  @override
  _SlashPageState createState() => _SlashPageState();
}

class _SlashPageState extends State<WaitingPage> {
  double spinOpacity = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer(
        const Duration(seconds: 4), () => setState(() => spinOpacity = 1));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: const Color(0xFFF1F1F1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Logo(
              fontSize: 70,
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: spinOpacity,
              child: Column(
                children: [
                  const SpinKitWave(
                    itemCount: 6,
                    size: 37,
                    color: mainLightLessColor,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.message ?? 'Chargement en cours',
                    // textScaleFactor: .95,
                    textScaler: const TextScaler.linear(.95),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
