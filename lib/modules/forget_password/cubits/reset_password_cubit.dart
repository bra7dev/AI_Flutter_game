import 'package:bloc/bloc.dart';

import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/failures/high_priority_failure.dart';
import '../repo/forget_pass_repo.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._repository) : super(ResetPasswordState.initial());

  final ForgetPasswordRepository _repository;


  void resetUserPassword(ResetPasswordInput input) async {
    emit(state.copyWith(resetPasswordStatus: ResetPasswordStatus.loading));

    try {
      bool res = await _repository.resetPassword(input);

      if (res) {
        emit(state.copyWith(
          resetPasswordStatus: ResetPasswordStatus.success,
        ));
      } else {
        emit(state.copyWith(
            resetPasswordStatus: ResetPasswordStatus.failure,
            exception: const HighPriorityException(
                "Something went wrong, Please try again")));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          resetPasswordStatus: ResetPasswordStatus.failure,
          exception: HighPriorityException(e.message)));
    } catch (e) {
      emit(state.copyWith(
          resetPasswordStatus: ResetPasswordStatus.failure,
          exception: HighPriorityException(e.toString())));
    }
  }
}

class ResetPasswordInput {
  final String otp;
  final String email;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordInput({
    required this.otp,
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        "token": otp,
        "email": email,
        "password": newPassword,
        "password_confirmation": confirmPassword,
      };
}
