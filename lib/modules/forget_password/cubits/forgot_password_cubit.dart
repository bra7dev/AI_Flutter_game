import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../repo/forget_pass_repo.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._repository) : super(ForgotPasswordState.initial());

  final ForgetPasswordRepository _repository;

  void sendOtpToEmail(String email) async {
    emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.loading));

    try {
      String otp = await _repository.sendOtp(email);

      emit(state.copyWith(
        forgotPasswordStatus: ForgotPasswordStatus.success,
        otp: otp,
      ));

    } on BaseFailure catch (e) {
      emit(state.copyWith(
          forgotPasswordStatus: ForgotPasswordStatus.failure,
          exception: HighPriorityException(e.message)));
    } catch (e) {
      emit(state.copyWith(
          forgotPasswordStatus: ForgotPasswordStatus.failure,
          exception: HighPriorityException(e.toString())));
    }
  }
  void resendOtpToEmail(String email) async {
    emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.resendLoading));

    try {
      String otp = await _repository.sendOtp(email);

      emit(state.copyWith(
        forgotPasswordStatus: ForgotPasswordStatus.resent,
        otp: otp,
      ));

    } on BaseFailure catch (e) {
      emit(state.copyWith(
          forgotPasswordStatus: ForgotPasswordStatus.failure,
          exception: HighPriorityException(e.message)));
    } catch (e) {
      emit(state.copyWith(
          forgotPasswordStatus: ForgotPasswordStatus.failure,
          exception: HighPriorityException(e.toString())));
    }
  }
}