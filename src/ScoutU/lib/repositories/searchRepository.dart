import 'package:ScoutU/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRepository {
  final Firestore _firestore;

  SearchRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  Future<User> chooseUser(
      currentUserId, selectedUserId, name, photoUrl, bio, sport) async {
    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('selectedList')
        .document(currentUserId)
        .setData(
            {'name': name, 'photoUrl': photoUrl, 'bio': bio, 'sport': sport});

    return getUser(currentUserId);
  }

  passUser(currentUserId, selectedUserId) async {
    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});
    return getUser(currentUserId);
  }

  Future getUserInterests(userId) async {
    User currentUser = User();

    await _firestore.collection('users').document(userId).get().then((user) {
      currentUser.name = user['name'];
      currentUser.photo = user['photoUrl'];
      currentUser.userType = user['userType'];
      currentUser.seeking = user['seeking'];
      currentUser.bio = user['bio'];
      currentUser.sport = user['sport'];
    });
    return currentUser;
  }

  Future<List> getChosenList(userId) async {
    List<String> chosenList = [];
    await _firestore
        .collection('users')
        .document(userId)
        .collection('chosenList')
        .getDocuments()
        .then((docs) {
      for (var doc in docs.documents) {
        if (docs.documents != null) {
          chosenList.add(doc.documentID);
        }
      }
    });
    return chosenList;
  }

  Future<User> getUser(userId) async {
    User _user = User();
    List<String> chosenList = await getChosenList(userId);
    User currentUser = await getUserInterests(userId);

    await _firestore.collection('users').getDocuments().then((users) {
      for (var user in users.documents) {
        if ((!chosenList.contains(user.documentID)) &&
            (user.documentID != userId) &&
            (currentUser.seeking == user['userType']) &&
            (user['seeking'] == currentUser.userType) &&
            (user['sport'] == currentUser.sport)) {
          _user.uid = user.documentID;
          _user.name = user['name'];
          _user.bio = user['bio'];
          _user.photo = user['photoUrl'];
          _user.classOf = user['classOf'];
          _user.location = user['location'];
          _user.userType = user['userType'];
          _user.seeking = user['seeking'];
          _user.sport = user['sport'];
          break;
        }
      }
    });

    return _user;
  }
}
