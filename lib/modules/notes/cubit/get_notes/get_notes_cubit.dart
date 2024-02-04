import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:coaching_app/modules/notes/model/get_notes_model.dart';
import 'package:coaching_app/modules/notes/repo/notes_repo.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../../../core/storage_service/storage_service.dart';
import '../../../journal/cubit/create_journal/create_journal_cubit.dart';

part 'get_notes_state.dart';

class GetNotesCubit extends Cubit<GetNotesState> {
  GetNotesCubit(this._repository,)
      : super(GetNotesState.initial());

  final NotesRepository _repository;


  Future fetchNotes(String date) async {
    emit(state.copyWith(getNotesStatus: GetNotesStatus.loading));

    try {
      GetNotesModel getNotesModel = await _repository.getNotes(date);
      if (getNotesModel.result == ApiResult.success) {
        emit(state.copyWith(
          getNotesStatus: GetNotesStatus.success,

          notes: getNotesModel.data,
        ));
      } else {
        emit(state.copyWith(
            getNotesStatus: GetNotesStatus.failure,
            failure: HighPriorityException(getNotesModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          getNotesStatus: GetNotesStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
