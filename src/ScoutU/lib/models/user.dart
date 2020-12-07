import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String userType;
  String seeking;
  String photo;
  String classOf;
  String bio;
  String sport;
  GeoPoint location;

  User(
      {this.uid,
      this.name,
      this.userType,
      this.seeking,
      this.photo,
      this.classOf,
      this.location});
}
