import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final FirebaseApp _firebaseApp;
  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;

  UserRepository(
      {FirebaseApp firebaseApp, FirebaseAuth firebaseAuth, Firestore firestore})
      : _firebaseApp = firebaseApp ?? FirebaseApp.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? Firestore.instance;

  Future<void> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> isFirstTime(String userId) async {
    bool exist;
    await Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((user) {
      exist = user.exists;
    });

    return exist;
  }

  Future<void> signUpWithEmail(String email, String password) async {
    print(_firebaseAuth);
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  //profile setup
  Future<void> profileSetup(
      File photo,
      String userType,
      String name,
      String userId,
      String classOf,
      String bio,
      String seeking,
      GeoPoint location,
      String sport) async {
    StorageUploadTask storageUploadTask;
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userId)
        .child(userId)
        .putFile(photo);

    return await storageUploadTask.onComplete.then((ref) async {
      await ref.ref.getDownloadURL().then((url) async {
        await _firestore.collection('users').document(userId).setData({
          'uid': userId,
          'photoUrl': url,
          'name': name,
          "location": location,
          'userType': userType,
          'seeking': seeking,
          'classOf': classOf,
          'bio': bio,
          'sport': sport,
        });
      });
    });
  }

  Future<void> profileUpdate(
      File photo,
      String userType,
      String name,
      String userId,
      String classOf,
      String bio,
      String seeking,
      GeoPoint location,
      String sport) async {
    StorageUploadTask storageUploadTask;
    String currentUser = Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .toString();
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(currentUser)
        .child(userId)
        .putFile(photo);

    return await storageUploadTask.onComplete.then((ref) async {
      await ref.ref.getDownloadURL().then((url) async {
        await _firestore.collection('users').document(currentUser).setData({
          'uid': userId,
          'photoUrl': url,
          'name': name,
          "location": location,
          'userType': userType,
          'seeking': seeking,
          'classOf': classOf,
          'bio': bio,
          'sport': sport,
        });
      });
    });
  }
}
