import '../../../../core/failures/base_failures/base_failure.dart';

enum ChangePasswordStatus {
  none,
  loading,
  success,
  failure,
}

class ChangePasswordState {
  final ChangePasswordStatus changePasswordStatus;
  final BaseFailure failure;

  ChangePasswordState({
    required this.changePasswordStatus,
    required this.failure,
  });

  factory ChangePasswordState.initial() {
    return ChangePasswordState(
      changePasswordStatus: ChangePasswordStatus.none,
      failure: const BaseFailure(),
    );
  }

  ChangePasswordState copyWith({
    ChangePasswordStatus? changePasswordStatus,
    BaseFailure? failure,
  }) {
    return ChangePasswordState(
      changePasswordStatus: changePasswordStatus ?? this.changePasswordStatus,
      failure: failure ?? this.failure,
    );
  }
}
