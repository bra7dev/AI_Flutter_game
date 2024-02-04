import 'dart:convert';

import 'package:coaching_app/modules/goal/cubit/add_goal_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../repo/notes_repo.dart';

part 'add_notes_state.dart';

class AddNotesCubit extends Cubit<AddNotesState> {
  AddNotesCubit(this._repository)
      : super(AddNotesState.initial());

  NotesRepository _repository;

  Future addNewNotes(AddNotesInput input) async {
    emit(state.copyWith(addNotesStatus: AddNotesStatus.loading));

    try {
      bool res = await _repository.addNotes(input.toFormData());

      if (res) {
        emit(state.copyWith(
          addNotesStatus: AddNotesStatus.success,
        ));
      } else {
        emit(state.copyWith(
            addNotesStatus: AddNotesStatus.failure,
            failure: HighPriorityException('Something went Wrong, try again')));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          addNotesStatus: AddNotesStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}

class AddNotesInput {
  final String date;
   String notes;

  AddNotesInput({
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        "date": date,
        "notes": notes,
      };

  factory AddNotesInput.fromJson(Map<String, dynamic> json) {
    return AddNotesInput(date: json["date"]??'', notes: json["notes"]??'');
  }

  FormData toFormData() => FormData.fromMap({
        "date": date,
        "notes": notes,
      });
}
