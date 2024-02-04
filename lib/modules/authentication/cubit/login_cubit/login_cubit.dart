import 'dart:developer';
import 'dart:io';

import 'package:coaching_app/modules/authentication/models/login_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../models/auth_response.dart';
import '../../repo/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepo) : super(LoginState.initial());

  final AuthRepository _authenticationRepo;


  void toggleShowPassword() => emit(state.copyWith(
        isPasswordVisible: !state.isPasswordHidden,
        loginStatus: LoginStatus.none,
      ));

  void enableAutoValidateMode() => emit(state.copyWith(
        isAutoValidate: true,
        loginStatus: LoginStatus.none,
      ));

  Future login(LoginInput input) async {

    emit(state.copyWith(loginStatus: LoginStatus.submitting));
    try {
      /*if (Platform.isIOS) {
        loginInput.iosFcmToken = await sl<CloudMessagingService>().getFcmToken();
      } else {
        loginInput.androidFcmToken = await sl<CloudMessagingService>().getFcmToken();
        log('Fcm token is :: ${loginInput.androidFcmToken}');
      }*/
      AuthResponse authResponse = await _authenticationRepo.login(input);
      if (authResponse.result == ApiResult.success) {
        emit(state.copyWith(loginStatus: LoginStatus.success));
      } else {
        emit(state.copyWith(loginStatus: LoginStatus.failure, failure: HighPriorityException(authResponse.message)));
      }
    } on BaseFailure catch (exception) {
      emit(state.copyWith(loginStatus: LoginStatus.failure, failure: HighPriorityException(exception.message)));
    } catch (_) {}

  }
}
