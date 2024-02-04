part of 'reset_password_cubit.dart';


enum ResetPasswordStatus {
  none,
  loading,
  success,
  failure,
}

class ResetPasswordState {
  final ResetPasswordStatus resetPasswordStatus;
  final BaseFailure exception;

  ResetPasswordState({
    required this.resetPasswordStatus,
    required this.exception,
  });

  factory ResetPasswordState.initial() {
    return ResetPasswordState(
      resetPasswordStatus: ResetPasswordStatus.none,
      exception: const BaseFailure(),
    );
  }

  ResetPasswordState copyWith({
    ResetPasswordStatus? resetPasswordStatus,
    BaseFailure? exception,
  }) {
    return ResetPasswordState(
      resetPasswordStatus: resetPasswordStatus ?? this.resetPasswordStatus,
      exception: exception ?? this.exception,
    );
  }
}

