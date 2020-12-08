import 'package:flutter/services.dart';
import 'package:ScoutU/bloc/profile/bloc.dart';
import 'package:ScoutU/repositories/userRepository.dart';
import 'package:ScoutU/ui/constants.dart';
import 'package:ScoutU/ui/widgets/profileForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String _textFromFile = "";

  _PrivacyPolicyState() {
    getFileData().then((val) => setState(() {
          _textFromFile = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
        backgroundColor: blueColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: backgroundColor,
          width: size.width,
          child: Text(
            _textFromFile,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }

  Future<String> getFileData() async {
    var string = await rootBundle.loadString("text/privacypolicy.txt");
    print(string);
    return string;
  }
}
