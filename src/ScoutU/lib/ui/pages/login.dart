import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ScoutU/bloc/login/login_bloc.dart';
import 'package:ScoutU/repositories/userRepository.dart';
import 'package:ScoutU/ui/widgets/loginForm.dart';

import '../constants.dart';

class Login extends StatelessWidget {
  final UserRepository _userRepository;

  Login({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          userRepository: _userRepository,
        ),
        child: LoginForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}
