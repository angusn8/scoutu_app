import 'package:ScoutU/models/user.dart';
import 'package:ScoutU/ui/pages/profile.dart';
import 'package:meta/meta.dart';

@immutable
class ProfileState {
  final bool isPhotoEmpty;
  final bool isNameEmpty;
  final bool isClassOfEmpty;
  final bool isUserTypeEmpty;
  final bool isSeekingEmpty;
  final bool isLocationEmpty;
  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isBioEmpty;
  final bool isSportEmpty;
  final User user;

  bool get isFormValid =>
      isPhotoEmpty &&
      isNameEmpty &&
      isClassOfEmpty &&
      isBioEmpty &&
      isSportEmpty &&
      isUserTypeEmpty &&
      isSeekingEmpty;

  ProfileState({
    this.user,
    @required this.isPhotoEmpty,
    @required this.isNameEmpty,
    @required this.isClassOfEmpty,
    @required this.isUserTypeEmpty,
    @required this.isSeekingEmpty,
    @required this.isLocationEmpty,
    @required this.isFailure,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isBioEmpty,
    @required this.isSportEmpty,
  });

  factory ProfileState.empty() {
    return ProfileState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isNameEmpty: false,
      isClassOfEmpty: false,
      isUserTypeEmpty: false,
      isSeekingEmpty: false,
      isLocationEmpty: false,
      isBioEmpty: false,
      isSportEmpty: false,
    );
  }

  factory ProfileState.loading() {
    return ProfileState(
        isPhotoEmpty: false,
        isFailure: false,
        isSuccess: false,
        isSubmitting: true,
        isNameEmpty: false,
        isClassOfEmpty: false,
        isUserTypeEmpty: false,
        isSeekingEmpty: false,
        isLocationEmpty: false,
        isBioEmpty: false,
        isSportEmpty: false);
  }

  factory ProfileState.failure() {
    return ProfileState(
      isPhotoEmpty: false,
      isFailure: true,
      isSuccess: false,
      isSubmitting: false,
      isNameEmpty: false,
      isClassOfEmpty: false,
      isUserTypeEmpty: false,
      isSeekingEmpty: false,
      isLocationEmpty: false,
      isBioEmpty: false,
      isSportEmpty: false,
    );
  }

  factory ProfileState.success() {
    return ProfileState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: true,
      isSubmitting: false,
      isNameEmpty: false,
      isClassOfEmpty: false,
      isUserTypeEmpty: false,
      isSeekingEmpty: false,
      isLocationEmpty: false,
      isBioEmpty: false,
      isSportEmpty: false,
    );
  }

  ProfileState update({
    bool isPhotoEmpty,
    bool isNameEmpty,
    bool isClassOfEmpty,
    bool isUserTypeEmpty,
    bool isSeekingEmpty,
    bool isLocationEmpty,
    bool isBioEmpty,
    bool isSportEmpty,
  }) {
    return copyWith(
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isPhotoEmpty: isPhotoEmpty,
      isNameEmpty: isNameEmpty,
      isClassOfEmpty: isClassOfEmpty,
      isUserTypeEmpty: isUserTypeEmpty,
      isSeekingEmpty: isSeekingEmpty,
      isLocationEmpty: isLocationEmpty,
      isBioEmpty: isBioEmpty,
      isSportEmpty: isSportEmpty,
    );
  }

  ProfileState copyWith(
      {bool isPhotoEmpty,
      bool isNameEmpty,
      bool isClassOfEmpty,
      bool isUserTypeEmpty,
      bool isSeekingEmpty,
      bool isLocationEmpty,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure,
      bool isBioEmpty,
      bool isSportEmpty}) {
    return ProfileState(
      isPhotoEmpty: isPhotoEmpty ?? this.isPhotoEmpty,
      isNameEmpty: isNameEmpty ?? this.isNameEmpty,
      isLocationEmpty: isLocationEmpty ?? this.isLocationEmpty,
      isSeekingEmpty: isSeekingEmpty ?? this.isSeekingEmpty,
      isUserTypeEmpty: isUserTypeEmpty ?? this.isUserTypeEmpty,
      isClassOfEmpty: isClassOfEmpty ?? this.isClassOfEmpty,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isBioEmpty: isBioEmpty ?? this.isBioEmpty,
      isSportEmpty: isSportEmpty ?? this.isSportEmpty,
    );
  }

  factory ProfileState.getUser() {
    return ProfileState(
        isPhotoEmpty: null,
        isNameEmpty: null,
        isClassOfEmpty: null,
        isUserTypeEmpty: null,
        isSeekingEmpty: null,
        isLocationEmpty: null,
        isFailure: null,
        isSubmitting: null,
        isSuccess: null,
        isBioEmpty: null,
        isSportEmpty: null);
  }
}

class GetUserState extends ProfileState {
  final User user;

  GetUserState(this.user);

  @override
  List<Object> get props => [user];
}
