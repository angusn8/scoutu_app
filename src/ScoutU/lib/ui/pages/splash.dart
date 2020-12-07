import 'package:flutter/material.dart';

import '../constants.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        width: size.width,
        child: Center(
          child: Image(
            image: AssetImage('assets/logoTransparent.png'),
            height: 250,
            width: 300,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
