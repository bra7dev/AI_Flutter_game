import 'dart:developer';
import 'dart:io';

import 'package:coaching_app/modules/authentication/models/register_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../models/auth_response.dart';
import '../../repo/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authenticationRepo) : super(RegisterState.initial());

  final AuthRepository _authenticationRepo;


  void toggleShowPassword() => emit(state.copyWith(
        isPasswordVisible: !state.isPasswordHidden,
    registerStatus: RegisterStatus.none,
      ));

  void enableAutoValidateMode() => emit(state.copyWith(
        isAutoValidate: true,
    registerStatus: RegisterStatus.none,
      ));

  Future register(RegisterInput input) async {
    emit(state.copyWith(registerStatus: RegisterStatus.submitting));
    try {

      AuthResponse authResponse = await _authenticationRepo.register(input.toFormData());
      if (authResponse.result == ApiResult.success) {
        emit(state.copyWith(registerStatus: RegisterStatus.success));
      } else {
        emit(state.copyWith(registerStatus: RegisterStatus.failure, failure: HighPriorityException(authResponse.message)));
      }
    } on BaseFailure catch (exception) {
      emit(state.copyWith(registerStatus: RegisterStatus.failure, failure: HighPriorityException(exception.message)));
    } catch (_) {}
  }
}
