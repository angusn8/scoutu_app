import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Contact Us",
            style: TextStyle(color: textColor),
          ),
          centerTitle: true,
          backgroundColor: blueColor,
          elevation: 0,
        ),
        body: Center(
            child: Text(
          "Contact us at scoutuapp@gmail.com",
          style: TextStyle(color: textColor, fontSize: size.height * 0.02),
        )));
  }
}
