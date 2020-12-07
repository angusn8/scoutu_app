import 'package:scoutu_app/bloc/profile/bloc.dart';
import 'package:scoutu_app/repositories/userRepository.dart';
import 'package:scoutu_app/ui/constants.dart';
import 'package:scoutu_app/ui/widgets/profileForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoutu_app/ui/widgets/profileUpdateForm.dart';

class ProfileUpdate extends StatelessWidget {
  final _userRepository;
  final userId;

  ProfileUpdate({@required UserRepository userRepository, String userId})
      : assert(userRepository != null),
        _userRepository = userRepository,
        userId = userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Update",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
        backgroundColor: blueColor,
        elevation: 0,
      ),
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(userRepository: _userRepository),
        child: ProfileForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}
