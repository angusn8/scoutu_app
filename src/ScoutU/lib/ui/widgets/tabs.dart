import 'package:ScoutU/bloc/authentication/authentication_bloc.dart';
import 'package:ScoutU/bloc/authentication/authentication_event.dart';
import 'package:ScoutU/repositories/userRepository.dart';
import 'package:ScoutU/ui/pages/matches.dart';
import 'package:ScoutU/ui/pages/messages.dart';
import 'package:ScoutU/ui/pages/profile.dart';
import 'package:ScoutU/ui/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ScoutU/ui/pages/settings.dart';

import '../constants.dart';

class Tabs extends StatelessWidget {
  final userId;
  final UserRepository userRepository;

  const Tabs({this.userId, this.userRepository});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Search(
        userId: userId,
      ),
      Matches(
        userId: userId,
      ),
      Messages(
        userId: userId,
      ),
      Settings(
        userRepository: userRepository,
      ),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: backgroundColor,
        accentColor: Colors.white,
      ),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Image(
              image: AssetImage('assets/logoTransparent.png'),
              height: 100,
              width: 100,
              fit: BoxFit.fill,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("Log Out",
                                style: TextStyle(color: textColor)),
                            content: Text(
                              "Are you sure you want to log out?",
                              style: TextStyle(color: textColor),
                            ),
                            backgroundColor: blueColor,
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: textColor),
                                  )),
                              FlatButton(
                                  onPressed: () {
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .add(LoggedOut());
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Log Out",
                                      style: TextStyle(color: textColor)))
                            ],
                          ));
                },
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TabBar(
                      tabs: <Widget>[
                        Tab(icon: Icon(Icons.search)),
                        Tab(icon: Icon(Icons.people)),
                        Tab(icon: Icon(Icons.message)),
                        Tab(
                          icon: Icon(Icons.settings),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}
