part of 'forgot_password_cubit.dart';

enum ForgotPasswordStatus {
  none,
  loading,
  resendLoading,
  resent,
  success,
  failure,
}

class ForgotPasswordState {
  final ForgotPasswordStatus forgotPasswordStatus;
  final BaseFailure exception;
  final String? otp;

  ForgotPasswordState({
    required this.forgotPasswordStatus,
    required this.exception,
    required this.otp,
  });

  factory ForgotPasswordState.initial() {
    return ForgotPasswordState(
      forgotPasswordStatus: ForgotPasswordStatus.none,
      exception: const BaseFailure(),
      otp: null,
    );
  }

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? forgotPasswordStatus,
    BaseFailure? exception,
    String? otp,
  }) {
    return ForgotPasswordState(
      forgotPasswordStatus: forgotPasswordStatus ?? this.forgotPasswordStatus,
      exception: exception ?? this.exception,
      otp: otp ?? this.otp,
    );
  }
}
