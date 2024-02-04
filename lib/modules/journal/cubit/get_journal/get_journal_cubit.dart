import 'package:bloc/bloc.dart';
import 'package:coaching_app/modules/journal/model/get_journal_model.dart';
import 'package:coaching_app/modules/journal/repo/journals_repo.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';

part 'get_journal_state.dart';

class GetJournalCubit extends Cubit<GetJournalState> {
  GetJournalCubit(this._repository) : super(GetJournalState.initial());

  JournalsRepository _repository;

  Future fetchJournal(String date) async {
    emit(state.copyWith(getJournalStatus: GetJournalStatus.loading, updatingStatus: GetJournalStatus.none));

    try {
      GetJournalModel getJournalModel = await _repository.getJournal(date);

      if (getJournalModel.result == ApiResult.success) {
        emit(state.copyWith(
          getJournalStatus: GetJournalStatus.success,
          data: getJournalModel.data,
        ));
      } else {
        emit(state.copyWith(
            getJournalStatus: GetJournalStatus.failure, failure: HighPriorityException(getJournalModel.message)));
      }
    } on BaseFailure catch (e) {
      if (e.message == 'Record Not Found') {
        emit(state.copyWith(
            getJournalStatus: GetJournalStatus.failure, failure: HighPriorityException('Add Journal Entry')));
        // throw 'Add Journal Entry';
      } else {
        emit(state.copyWith(getJournalStatus: GetJournalStatus.failure, failure: HighPriorityException(e.message)));
      }
    } catch (_) {}
  }

  Future<void> updateJournal(int id, String date, int isComplete) async {
    emit(state.copyWith(getJournalStatus: GetJournalStatus.success, updatingStatus: GetJournalStatus.updateLoading));

    try {
      bool response = await _repository.updateJournalTask({'id': id, 'date': date, 'is_complete': isComplete});
      if (response) {
        JournalData? data = state.data;
        data!.hourlyPlanner.firstWhere((element) => element.id == id).isComplete = isComplete;
        emit(state.copyWith(
            data: data, getJournalStatus: GetJournalStatus.success, updatingStatus: GetJournalStatus.updated));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
        getJournalStatus: GetJournalStatus.success,
        updatingStatus: GetJournalStatus.updateFailure,
      ));
    } catch (_) {}
  }
}
