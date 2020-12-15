import 'dart:io';

import 'package:ScoutU/bloc/authentication/authentication_bloc.dart';
import 'package:ScoutU/bloc/authentication/authentication_event.dart';
import 'package:ScoutU/bloc/profile/bloc.dart';
import 'package:ScoutU/repositories/userRepository.dart';
import 'package:ScoutU/ui/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ScoutU/ui/widgets/tabs.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileForm extends StatefulWidget {
  final UserRepository _userRepository;

  ProfileForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String userType, seeking, sport;
  String classOf;
  File photo;
  String bio;
  GeoPoint location;
  ProfileBloc _profileBloc;

  //UserRepository get _userRepository => widget._userRepository;

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
      _bioController.text.isNotEmpty &&
      userType != null &&
      seeking != null &&
      photo != null &&
      sport != null &&
      classOf != null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      location = GeoPoint(position.latitude, position.longitude);
    }
  }

  _onSubmitted() async {
    await _getLocation();
    _profileBloc.add(
      Submitted(
          name: _nameController.text,
          bio: _bioController.text,
          classOf: classOf,
          location: location,
          userType: userType,
          seeking: seeking,
          photo: photo,
          sport: sport),
    );
  }

  @override
  void initState() {
    _getLocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String dropdownValue = '';
  String dropdownValueSport = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ProfileBloc, ProfileState>(
      //bloc: _profileBloc,
      listener: (context, state) {
        if (state.isFailure) {
          print("Failed");
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Profile Creation Unsuccesful'),
                    Icon(Icons.error)
                  ],
                ),
              ),
            );
        }
        if (state.isSubmitting) {
          print("Submitting");
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Submitting'),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          print("Success!");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Column(children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: backgroundColor,
                width: size.width,
                height: size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: size.width,
                      margin: EdgeInsets.only(top: size.height * 0.02),
                      child: CircleAvatar(
                        radius: size.width * 0.3,
                        backgroundColor: Colors.transparent,
                        child: photo == null
                            ? GestureDetector(
                                onTap: () async {
                                  if (await Permission.photos
                                      .request()
                                      .isGranted) {
                                    File getPic = await FilePicker.getFile(
                                        type: FileType.image);
                                    if (getPic != null) {
                                      setState(() {
                                        photo = getPic;
                                      });
                                    }
                                  } else {}
                                },
                                child: Image.asset('assets/profilephoto.png'),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  if (await Permission.photos
                                      .request()
                                      .isGranted) {
                                    File getPic = await FilePicker.getFile(
                                        type: FileType.image);

                                    if (getPic != null) {
                                      setState(() {
                                        photo = getPic;
                                      });
                                    } else {}
                                  }
                                },
                                child: CircleAvatar(
                                  radius: size.width * 0.3,
                                  backgroundImage: FileImage(photo),
                                ),
                              ),
                      ),
                    ),
                    Text(
                      "Click Image to Add Profile Picture",
                      style: TextStyle(
                          color: textColor, fontSize: size.height * 0.02),
                    ),
                    textFieldWidget(
                      _nameController,
                      "Name",
                      size,
                    ),
                    textFieldWidget(
                        _bioController, "Enter a bio with relevant info", size),
                    Text(
                      "What high school class are you?",
                      style: TextStyle(
                          color: textColor, fontSize: size.height * 0.02),
                    ),
                    DropdownButton<String>(
                      hint: Text(dropdownValue),
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      style: TextStyle(color: textColor),
                      underline: Container(height: 2, color: blueColor),
                      onChanged: (String value) {
                        setState(() {
                          classOf = value;
                          dropdownValue = value;
                          if (value != 'I am a Coach') {
                            userType = 'Athlete';
                            seeking = "Coach";
                          } else {
                            userType = "Coach";
                            seeking = "Athlete";
                          }
                        });
                      },
                      items: <String>[
                        '',
                        'I am a Coach',
                        'College Transfer',
                        '2021',
                        '2022',
                        '2023',
                        '2024',
                        '2025'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                    Center(
                        child: Text(
                      'What sport do you play/coach?',
                      style: TextStyle(
                          color: textColor, fontSize: size.height * 0.02),
                      textAlign: TextAlign.center,
                    )),
                    Center(
                      child: DropdownButton(
                        value: dropdownValueSport,
                        icon: Icon(Icons.arrow_downward),
                        style: TextStyle(color: textColor),
                        underline: Container(height: 2, color: blueColor),
                        items: <String>[
                          '',
                          'Football',
                          'Baseball',
                          'Softball',
                          "Men's Basketball",
                          "Women's Basketball",
                          "Men's Soccer",
                          "Women's Soccer"
                        ].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dropdownValueSport = value;
                            sport = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * .02),
                        child: Center(
                          child: SizedBox(
                            width: size.width * 0.8,
                            child: RaisedButton(
                              color: isButtonEnabled(state)
                                  ? textColor
                                  : blueColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      size.height * 0.05)),
                              onPressed: () {
                                if (isButtonEnabled(state)) {
                                  _onSubmitted();
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text(
                                              "Incomplete Profile",
                                              style:
                                                  TextStyle(color: textColor),
                                            ),
                                            content: Text(
                                              "Please fill out your entire profile, including the picture. A complete profile will help you grow your network!",
                                              style:
                                                  TextStyle(color: textColor),
                                            ),
                                            backgroundColor: blueColor,
                                            actions: [
                                              FlatButton(
                                                  color: greenColor,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Ok",
                                                    style: TextStyle(
                                                        color: textColor),
                                                  ))
                                            ],
                                          ));
                                }
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: isButtonEnabled(state)
                                        ? blueColor
                                        : textColor),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ))
          ]);
        },
      ),
    );
  }
}

Widget textFieldWidget(controller, text, size) {
  return Padding(
    padding: EdgeInsets.all(size.height * 0.02),
    child: TextField(
      maxLength: 110,
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(color: textColor, fontSize: size.height * 0.02),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor, width: 1.0),
        ),
      ),
    ),
  );
}
