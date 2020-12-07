import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoutu_app/bloc/profile/profile_bloc.dart';
import 'package:scoutu_app/repositories/userRepository.dart';
import 'package:scoutu_app/ui/pages/privacyPolicy.dart';
import 'package:scoutu_app/ui/pages/profile.dart';
import 'package:scoutu_app/ui/pages/profileUpdate.dart';
import 'package:scoutu_app/ui/widgets/profileUpdateForm.dart';

import '../constants.dart';
import 'contact.dart';

class Settings extends StatefulWidget {
  final UserRepository userRepository;

  const Settings({Key key, this.userRepository}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  UserRepository _userRepository = UserRepository();
  ProfileBloc _profileBloc;

  @override
  void initState() {
    _profileBloc = ProfileBloc(userRepository: _userRepository);
    super.initState();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(userRepository: _userRepository),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * .02),
                  child: Center(
                    child: RaisedButton(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.05)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileUpdate(
                                    userRepository: _userRepository)));
                      },
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  child: Center(
                    child: RaisedButton(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.05)),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicy())),
                      child: Text("Privacy Policy"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  child: Center(
                    child: RaisedButton(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.05)),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ContactUs())),
                      child: Text("Contact Us"),
                    ),
                  ),
                ),
              ],
            )));
  }
}
