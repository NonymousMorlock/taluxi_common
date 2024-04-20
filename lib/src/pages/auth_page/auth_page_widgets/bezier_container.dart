import 'dart:math';

import 'package:flutter/material.dart';

import 'package:taluxi_common/src/core/constants/colors.dart';

class BezierContainer extends StatelessWidget {
  const BezierContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: -pi / 3.5,
        child: ClipPath(
          clipper: ClipPainter(),
          child: Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(gradient: mainLinearGradient),
          ),
        ),
      ),
    );
  }
}

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final height = size.height;
    final width = size.width;
    final path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, height);
    path.lineTo(size.width, 0);

    /// [Top Left corner]
    const secondControlPoint = Offset(0, 0);
    final secondEndPoint = Offset(width * .2, height * .3);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    /// [Left Middle]
    final fifthControlPoint = Offset(width * .3, height * .5);
    final fifthEndpoint = Offset(width * .23, height * .6);
    path.quadraticBezierTo(
      fifthControlPoint.dx,
      fifthControlPoint.dy,
      fifthEndpoint.dx,
      fifthEndpoint.dy,
    );

    /// [Bottom Left corner]
    final thirdControlPoint = Offset(0, height);
    final thirdEndPoint = Offset(width, height);
    path.quadraticBezierTo(
      thirdControlPoint.dx,
      thirdControlPoint.dy,
      thirdEndPoint.dx,
      thirdEndPoint.dy,
    );

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
