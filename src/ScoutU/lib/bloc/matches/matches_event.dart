import 'package:equatable/equatable.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object> get props => [];
}

class LoadListsEvent extends MatchesEvent {
  final String userId;

  LoadListsEvent({this.userId});

  @override
  List<Object> get props => [userId];
}

class AcceptUserEvent extends MatchesEvent {
  final String currentUser,
      selectedUser,
      selectedUserName,
      selectedUserPhotoUrl,
      selectedUserBio,
      selectedUserSport,
      currentUserName,
      currentUserBio,
      currentUserPhotoUrl,
      currentUserSport;

  AcceptUserEvent({
    this.currentUser,
    this.selectedUser,
    this.selectedUserName,
    this.selectedUserPhotoUrl,
    this.selectedUserBio,
    this.selectedUserSport,
    this.currentUserName,
    this.currentUserBio,
    this.currentUserPhotoUrl,
    this.currentUserSport,
  });

  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
        selectedUserName,
        selectedUserPhotoUrl,
        selectedUserBio,
        currentUserName,
        currentUserPhotoUrl
      ];
}

class DeleteUserEvent extends MatchesEvent {
  final String currentUser, selectedUser;

  DeleteUserEvent({this.currentUser, this.selectedUser});

  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
      ];
}

class OpenChatEvent extends MatchesEvent {
  final String currentUser, selectedUser;

  OpenChatEvent({this.currentUser, this.selectedUser});

  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
      ];
}
