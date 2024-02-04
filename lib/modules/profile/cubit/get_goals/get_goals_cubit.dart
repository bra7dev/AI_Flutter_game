import 'package:bloc/bloc.dart';
import 'package:coaching_app/modules/profile/model/get_goals_model.dart';
import 'package:coaching_app/modules/profile/repo/get_goals_repo.dart';
import 'package:meta/meta.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';

part 'get_goals_state.dart';

class GetGoalsCubit extends Cubit<GetGoalsState> {
  GetGoalsCubit(this._repository) : super(GetGoalsState.initial());

  final GetGoalsRepository _repository;

  Future fetchGoals() async {
    emit(state.copyWith(getGoalsStatus: GetGoalsStatus.loading));

    try {
      GetGoalsModel getGoalsModel = await _repository.getGoals();

      if (getGoalsModel.result == ApiResult.success) {
        emit(state.copyWith(
          getGoalsStatus: GetGoalsStatus.success,
          goals: getGoalsModel.data,
        ));
      } else {
        emit(state.copyWith(
            getGoalsStatus: GetGoalsStatus.failure,
            failure: HighPriorityException(getGoalsModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          getGoalsStatus: GetGoalsStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
