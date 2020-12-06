import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends ProfileEvent {
  final String name;

  NameChanged({@required this.name});

  @override
  List<Object> get props => [name];
}

class PhotoChanged extends ProfileEvent {
  final File photo;

  PhotoChanged({@required this.photo});

  @override
  List<Object> get props => [photo];
}

class ClassOfChanged extends ProfileEvent {
  final DateTime classOf;

  ClassOfChanged({@required this.classOf});

  @override
  List<Object> get props => [classOf];
}

class UserTypeChanged extends ProfileEvent {
  final String userType;

  UserTypeChanged({@required this.userType});

  @override
  List<Object> get props => [userType];
}

class SeekingChanged extends ProfileEvent {
  final String seeking;

  SeekingChanged({@required this.seeking});

  @override
  List<Object> get props => [seeking];
}

class LocationChanged extends ProfileEvent {
  final GeoPoint location;

  LocationChanged({@required this.location});

  @override
  List<Object> get props => [location];
}

class BioChanged extends ProfileEvent {
  final String bio;

  BioChanged({@required this.bio});

  @override
  List<Object> get props => [bio];
}

class SportChanged extends ProfileEvent {
  final String sport;

  SportChanged({@required this.sport});

  @override
  List<Object> get props => [sport];
}

class Submitted extends ProfileEvent {
  final String name, userType, seeking, bio, sport;
  final String classOf;
  final GeoPoint location;
  final File photo;

  Submitted(
      {@required this.name,
      @required this.userType,
      @required this.seeking,
      @required this.bio,
      @required this.classOf,
      @required this.location,
      @required this.photo,
      @required this.sport});

  @override
  List<Object> get props =>
      [bio, classOf, location, name, photo, seeking, userType, sport];
}

class Updated extends ProfileEvent {
  final String name, userType, seeking, bio, sport;
  final String classOf;
  final GeoPoint location;
  final File photo;

  Updated({
    this.name,
    this.userType,
    this.seeking,
    this.bio,
    this.sport,
    this.classOf,
    this.location,
    this.photo,
  });

  @override
  List<Object> get props =>
      [bio, classOf, location, name, photo, seeking, userType, sport];
}
