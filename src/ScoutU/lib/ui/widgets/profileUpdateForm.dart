import 'dart:io';
import 'dart:typed_data';

import 'package:ScoutU/bloc/authentication/authentication_bloc.dart';
import 'package:ScoutU/bloc/authentication/authentication_event.dart';
import 'package:ScoutU/bloc/matches/matches_event.dart';
import 'package:ScoutU/bloc/profile/bloc.dart';
import 'package:ScoutU/bloc/search/bloc.dart';
import 'package:ScoutU/models/user.dart';
import 'package:ScoutU/repositories/userRepository.dart';
import 'package:ScoutU/ui/constants.dart';
import 'package:ScoutU/ui/pages/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ScoutU/ui/widgets/tabs.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileUpdateForm extends StatefulWidget {
  final UserRepository _userRepository;

  ProfileUpdateForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState(_userRepository);
}

class _ProfileUpdateState extends State<ProfileUpdateForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final UserRepository _userRepository;
  User user;

  String userType, seeking, sport;
  String classOf;
  File photo;
  String bio;
  GeoPoint location;
  ProfileBloc _profileBloc;

  _ProfileUpdateState(this._userRepository);

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
    return !state.isSubmitting;
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
      Updated(
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
    _profileBloc = ProfileBloc(userRepository: _userRepository);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<User> getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;

    var currentUser = await _userRepository.profileGet(uid);
    return currentUser;
  }

  User currentUser() {
    getCurrentUser().then((value) {
      user = value;
    });
    print(user);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserRepository userRepository;
    user = currentUser();

    return BlocProvider<ProfileBloc>(
      create: (BuildContext context) =>
          ProfileBloc(userRepository: userRepository),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: _profileBloc,
        builder: (context, state) {
          var dropdownValue;
          var dropdownValueUserType;
          var dropdownValueSeeking;
          var dropdownValueSport;
          return Column(children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: backgroundColor,
                width: size.width,
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
                                child: FutureBuilder(
                                    future: displayImage(context),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Container(
                                          width: size.width * 0.5,
                                          height: size.height * 0.4,
                                          child: snapshot.data,
                                        );
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          width: size.width * 0.5,
                                          height: size.height * 0.4,
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return Container();
                                    }))
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
                    textFieldWidget(
                      _nameController,
                      user.name,
                      size,
                    ),
                    textFieldWidget(_bioController, user.bio, size),
                    Text(
                      "What high school class are you?",
                      style: TextStyle(
                          color: textColor, fontSize: size.height * 0.02),
                    ),
                    DropdownButton(
                      hint: Center(
                          child: Text(
                        user.classOf,
                        style: TextStyle(color: textColor),
                      )),
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      style: TextStyle(color: textColor),
                      underline: Container(height: 2, color: blueColor),
                      items: <String>[
                        'I am a Coach',
                        '2021',
                        '2022',
                        '2023',
                        '2024',
                        '2025'
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          classOf = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.02),
                          child: Center(
                              child: Text(
                            "Are you a coach or an athlete?",
                            style: TextStyle(
                                color: textColor, fontSize: size.height * 0.02),
                            textAlign: TextAlign.center,
                          )),
                        ),
                        Center(
                          child: DropdownButton(
                            hint: Center(
                                child: Text(
                              user.userType,
                              style: TextStyle(color: textColor),
                            )),
                            value: dropdownValueUserType,
                            icon: Icon(Icons.arrow_downward),
                            style: TextStyle(color: textColor),
                            underline: Container(height: 2, color: blueColor),
                            items: <String>['Coach', 'Athlete']
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                userType = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.02),
                          child: Center(
                              child: Text(
                            "Who are you trying to meet?",
                            style: TextStyle(
                                color: textColor, fontSize: size.height * 0.02),
                            textAlign: TextAlign.center,
                          )),
                        ),
                        Center(
                          child: DropdownButton(
                            hint: Center(
                                child: Text(
                              user.seeking,
                              style: TextStyle(color: textColor),
                            )),
                            value: dropdownValueSeeking,
                            icon: Icon(Icons.arrow_downward),
                            style: TextStyle(color: textColor),
                            underline: Container(height: 2, color: blueColor),
                            items: <String>['Coach', 'Athlete']
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                seeking = value;
                              });
                            },
                          ),
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
                            hint: Center(
                                child: Text(
                              user.sport,
                              style: TextStyle(color: textColor),
                            )),
                            value: dropdownValueSport,
                            icon: Icon(Icons.arrow_downward),
                            style: TextStyle(color: textColor),
                            underline: Container(height: 2, color: blueColor),
                            items: <String>[
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
                                sport = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * .02),
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
                                    _onSubmitted();
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

Future<Widget> getImage(BuildContext context, String imageName) async {
  Image image;

  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseUser user = await auth.currentUser();
  final uid = user.uid;
  await FireStorageService.loadImage(context, uid).then((value) {
    image = Image.network(value.toString(), fit: BoxFit.cover);
  });
  return image;
}

Future<Widget> displayImage(BuildContext context) async {
  Size size = MediaQuery.of(context).size;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseUser user = await auth.currentUser();
  final uid = user.uid;

  return FutureBuilder(
      future: getImage(context, uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            width: size.width * 0.4,
            height: size.height * 0.4,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: snapshot.data,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: size.width * 0.5,
            height: size.height * 0.4,
            child: CircularProgressIndicator(),
          );
        }

        return Container();
      });
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadImage(BuildContext context, String Image) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(uid)
        .child(uid)
        .getDownloadURL();
  }
}
