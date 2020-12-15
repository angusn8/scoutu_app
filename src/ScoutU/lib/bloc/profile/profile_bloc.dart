import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ScoutU/repositories/userRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository _userRepository;

  ProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super();

  @override
  ProfileState get initialState => ProfileState.empty();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is ClassOfChanged) {
      yield* _mapClassOfChangedToState(event.classOf);
    } else if (event is BioChanged) {
      yield* _mapBioChangedToState(event.bio);
    } else if (event is UserTypeChanged) {
      yield* _mapUserTypeChangedToState(event.userType);
    } else if (event is SeekingChanged) {
      yield* _mapSeekingChangedToState(event.seeking);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is SportChanged) {
      yield* _mapSportChangedToState(event.sport);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is Submitted) {
      final uid = await _userRepository.getUser();
      yield* _mapSubmittedToState(
          photo: event.photo,
          name: event.name,
          userType: event.userType,
          userId: uid,
          classOf: event.classOf,
          location: event.location,
          bio: event.bio,
          seeking: event.seeking,
          sport: event.sport);
    } else if (event is Updated) {
      final uid = await _userRepository.getUser();
      yield* _mapUpdatedToState(
          photo: event.photo,
          name: event.name,
          userType: event.userType,
          userId: uid,
          classOf: event.classOf,
          location: event.location,
          bio: event.bio,
          seeking: event.seeking,
          sport: event.sport);
    } else if (event is Get) {
      final uid = await _userRepository.getUser();
      yield* _mapLoadUserToState(userId: uid);
    }
  }

  Stream<ProfileState> _mapNameChangedToState(String name) async* {
    yield state.update(
      isNameEmpty: name == null,
    );
  }

  Stream<ProfileState> _mapPhotoChangedToState(File photo) async* {
    yield state.update(
      isPhotoEmpty: photo == null,
    );
  }

  Stream<ProfileState> _mapClassOfChangedToState(DateTime classOf) async* {
    yield state.update(
      isClassOfEmpty: classOf == null,
    );
  }

  Stream<ProfileState> _mapUserTypeChangedToState(String userType) async* {
    yield state.update(
      isUserTypeEmpty: userType == null,
    );
  }

  Stream<ProfileState> _mapSeekingChangedToState(String seeking) async* {
    yield state.update(
      isSeekingEmpty: seeking == null,
    );
  }

  Stream<ProfileState> _mapLocationChangedToState(GeoPoint location) async* {
    yield state.update(
      isLocationEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapBioChangedToState(String bio) async* {
    yield state.update(isBioEmpty: bio == null);
  }

  Stream<ProfileState> _mapSportChangedToState(String sport) async* {
    yield state.update(isSportEmpty: sport == null);
  }

  Stream<ProfileState> _mapSubmittedToState({
    File photo,
    String userType,
    String name,
    String userId,
    String classOf,
    String bio,
    String seeking,
    GeoPoint location,
    String sport,
  }) async* {
    yield ProfileState.loading();
    try {
      await _userRepository.profileSetup(photo, userType, name, userId, classOf,
          bio, seeking, location, sport);
      yield ProfileState.success();
    } catch (_) {
      yield ProfileState.failure();
    }
  }

  Stream<ProfileState> _mapUpdatedToState({
    File photo,
    String userType,
    String name,
    String userId,
    String classOf,
    String bio,
    String seeking,
    GeoPoint location,
    String sport,
  }) async* {
    yield ProfileState.loading();
    try {
      await _userRepository.profileUpdate(photo, userType, name, userId,
          classOf, bio, seeking, location, sport);
      yield ProfileState.success();
    } catch (_) {
      yield ProfileState.failure();
    }
  }

  Stream<ProfileState> _mapLoadUserToState({
    String userType,
    String name,
    String userId,
    String classOf,
    String bio,
    String seeking,
    GeoPoint location,
    String sport,
  }) async* {
    try {
      await _userRepository.profileGet(userId);
      yield ProfileState.getUser();
    } catch (_) {
      yield ProfileState.failure();
    }
  }
}
