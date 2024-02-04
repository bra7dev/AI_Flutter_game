part of 'get_time_slots_cubit.dart';

enum GetTimeSlotsStatus {
  none,
  loading,
  success,
  failure,
}

class GetTimeSlotState {
  final GetTimeSlotsStatus status;
  final List<TimeSlotModel> timeSlots;
  final CreateJournalInput storedJournal;
  final AddNotesInput storedNotes;
  final BaseFailure failure;

  GetTimeSlotState(
      {required this.timeSlots, required this.failure, required this.status,
        required this.storedNotes,
        required this.storedJournal,});

  factory GetTimeSlotState.initial() {
    return GetTimeSlotState(
        timeSlots: [],
        storedNotes: AddNotesInput(date: '',notes: ''),
        storedJournal: CreateJournalInput.empty(),
        failure: const BaseFailure(),

        status: GetTimeSlotsStatus.none);
  }

  GetTimeSlotState copyWith({
    List<TimeSlotModel>? timeSlots,
    CreateJournalInput? storedJournal,
    AddNotesInput? storedNotes,
    BaseFailure? failure,
    GetTimeSlotsStatus? status,
  }) {
    return GetTimeSlotState(
        timeSlots: timeSlots ?? this.timeSlots,
        storedJournal: storedJournal??this.storedJournal,
        storedNotes: storedNotes??this.storedNotes,
        failure: failure ?? this.failure,
        status: status ?? this.status);
  }
}
