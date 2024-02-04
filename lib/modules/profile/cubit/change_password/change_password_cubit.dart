import 'package:bloc/bloc.dart';
import 'package:coaching_app/modules/profile/repo/change_password_repo.dart';
import 'package:dio/dio.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._repository) : super(ChangePasswordState.initial());

  ChangePasswordRepository _repository;


  Future<void> changePassword(ChangePasswordInput changePasswordInput) async {
    try {
      emit(state.copyWith(changePasswordStatus: ChangePasswordStatus.loading));

      bool result = await _repository.changePasswordApi(changePasswordInput);

      if (result) {
        emit(state.copyWith(changePasswordStatus: ChangePasswordStatus.success));
      } else {
        emit(state.copyWith(
            changePasswordStatus: ChangePasswordStatus.failure,
            failure: HighPriorityException()));
      }
    } on BaseFailure catch (exception) {
      emit(state.copyWith(
          changePasswordStatus: ChangePasswordStatus.failure, failure: HighPriorityException(exception.message)));
    } catch (err) {
      emit(state.copyWith(
          changePasswordStatus: ChangePasswordStatus.failure, failure: HighPriorityException(err.toString())));
    }
  }

}

class ChangePasswordInput {
  final String oldPassword;
  final String newPassword;

  ChangePasswordInput({required this.newPassword, required this.oldPassword,});

  Map<String, dynamic> toJson() => {
    "new_password": newPassword,
    "old_password": oldPassword,
  };

  FormData toFormData() => FormData.fromMap({
    "new_password": newPassword,
    "old_password": oldPassword,
  });
}
