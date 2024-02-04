import 'package:bloc/bloc.dart';
import 'package:coaching_app/modules/goal/repo/add_goal_repo.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/failures/high_priority_failure.dart';

part 'add_goal_state.dart';

class AddGoalCubit extends Cubit<AddGoalState> {
  AddGoalCubit(this._repository) : super(AddGoalState.initial());

  AddGoalRepository _repository;

  Future addNewGoal(AddGoalInput input) async {
    emit(state.copyWith(addGoalStatus: AddGoalStatus.loading));

    try {
      bool res = await _repository.createGoal(input.toFormData());

      if (res) {
        emit(state.copyWith(
          addGoalStatus: AddGoalStatus.success,
        ));
      } else {
        emit(state.copyWith(
            addGoalStatus: AddGoalStatus.failure,
            failure: HighPriorityException('Something went Wrong, try again')));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          addGoalStatus: AddGoalStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}

class AddGoalInput {
  final int goalType;
  final String description;


  AddGoalInput({
    required this.goalType,
    required this.description,

  });

  Map<String, dynamic> toJson() => {
    "goal_type": goalType,
    "description": description,
  };

  FormData toFormData() => FormData.fromMap({
    "goal_type": goalType,
    "description": description,
  });
}
