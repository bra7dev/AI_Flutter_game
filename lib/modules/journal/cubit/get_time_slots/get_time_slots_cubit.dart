import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:coaching_app/modules/journal/cubit/create_journal/create_journal_cubit.dart';
import 'package:coaching_app/modules/journal/model/time_slot_model.dart';

import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../../../core/storage_service/storage_service.dart';
import '../../../notes/cubit/add_notes/add_notes_cubit.dart';
import '../../repo/journals_repo.dart';

part 'get_time_slots_state.dart';

const _journalDateKey = 'journal';
const _noteDateKey = 'note';

class GetTimeSlotsCubit extends Cubit<GetTimeSlotState> {
  GetTimeSlotsCubit(this._repository, this._storageService)
      : super(GetTimeSlotState.initial());

  JournalsRepository _repository;
  final StorageService _storageService;

  Future<void> addJournalToLocalDB(
      String date, CreateJournalInput journalInput) async {
    await _storageService.setString(
        '${date}_${_journalDateKey}', json.encode(journalInput.toJson()));
  }

  Future<void> addNotesToLocalDB(String date, AddNotesInput notesInput) async {
    await _storageService.setString(
        '${date}_${_noteDateKey}', json.encode(notesInput.toJson()));
  }

  Future<CreateJournalInput?> getLocalStoredJournal(String date) async {
    String localJournal =
        _storageService.getString('${date}_${_journalDateKey}');

    if (localJournal.isNotEmpty) {
      return CreateJournalInput.fromJson(json.decode(localJournal));
    } else {
      return null;
    }
  }

  Future<AddNotesInput?> getLocalStoredNotes(String date) async {
    String localJournal = _storageService.getString('${date}_${_noteDateKey}');

    if (localJournal.isNotEmpty) {
      return AddNotesInput.fromJson(json.decode(localJournal));
    } else {
      return null;
    }
  }

  Future<void> removeJournalFromLocalDB(String date) async {
    await _storageService.remove('${date}_${_journalDateKey}');
  }

  Future<void> removeNoteFromLocalDB(String date) async {
    await _storageService.remove('${date}_${_noteDateKey}');
  }

  Future getTimeSlots(String date) async {
    emit(state.copyWith(status: GetTimeSlotsStatus.loading));

    try {
      List<TimeSlotModel> timeSlots = await _repository.getTimeSlots();
      CreateJournalInput? storedJournal = await getLocalStoredJournal(date);

      AddNotesInput? storedNotes = await getLocalStoredNotes(date);

      if (storedNotes == null) {

        storedNotes = AddNotesInput(date: '', notes: '');

        await addNotesToLocalDB(date, AddNotesInput(date: '', notes: ''));
      }
      if (storedJournal == null) {

        storedJournal =CreateJournalInput.empty();

        await addJournalToLocalDB(date, CreateJournalInput.empty());
      }
      emit(state.copyWith(
          status: GetTimeSlotsStatus.success,
          timeSlots: timeSlots,
          storedJournal: storedJournal,
          storedNotes: storedNotes));
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          status: GetTimeSlotsStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (e) {
      emit(state.copyWith(
          status: GetTimeSlotsStatus.failure,
          failure: HighPriorityException(e.toString())));
    }
  }
}
