part of 'register_cubit.dart';

enum RegisterStatus {
  none,
  submitting,
  success,
  failure,
}

class RegisterState {
  final RegisterStatus registerStatus;
  final bool isPasswordHidden;
  final bool isAutoValidate;
  final BaseFailure failure;


  RegisterState({
    required this.registerStatus,
    required this.isPasswordHidden,
    required this.isAutoValidate,
    required this.failure,
  });

  factory RegisterState.initial() {
    return RegisterState(
      registerStatus: RegisterStatus.none,
      isPasswordHidden: true,
      isAutoValidate: false,
      failure: BaseFailure(),

    );
  }

  RegisterState copyWith({
    RegisterStatus? registerStatus,
    bool? isPasswordVisible,
    bool? isAutoValidate,
    BaseFailure? failure,

  }) {
    return RegisterState(
      registerStatus: registerStatus ?? this.registerStatus,
      isPasswordHidden: isPasswordVisible ?? isPasswordHidden,
      isAutoValidate: isAutoValidate ?? this.isAutoValidate,
      failure: failure ?? this.failure,
    );
  }
}
