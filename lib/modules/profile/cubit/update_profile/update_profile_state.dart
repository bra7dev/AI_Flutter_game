part of 'update_profile_cubit.dart';

enum UpdateProfileStatus {
  none,
  loading,
  success,
  failure,
}

class UpdateProfileState {
  final UpdateProfileStatus updateProfileStatus;
  final BaseFailure exception;

  UpdateProfileState({
    required this.updateProfileStatus,
    required this.exception,
  });

  factory UpdateProfileState.initial() {
    return UpdateProfileState(
      updateProfileStatus: UpdateProfileStatus.none,
      exception: const BaseFailure(),
    );
  }

  UpdateProfileState copyWith({
    UpdateProfileStatus? updateProfileStatus,
    BaseFailure? exception,
  }) {
    return UpdateProfileState(
      updateProfileStatus: updateProfileStatus ?? this.updateProfileStatus,
      exception: exception ?? this.exception,
    );
  }
}


