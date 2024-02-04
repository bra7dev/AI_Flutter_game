part of 'get_notes_cubit.dart';

enum GetNotesStatus {
  none,
  loading,
  success,
  failure,
}

class GetNotesState {
  final GetNotesStatus getNotesStatus;
  final BaseFailure failure;
  final List<Notes> notes;

  GetNotesState({
    required this.getNotesStatus,
    required this.failure,
    required this.notes,
  });

  factory GetNotesState.initial() {
    return GetNotesState(
        getNotesStatus: GetNotesStatus.none,
        failure: const BaseFailure(),
        notes: []
    );
  }

  GetNotesState copyWith({
    GetNotesStatus? getNotesStatus,
    BaseFailure? failure,
    List<Notes>? notes,

  }) {
    return GetNotesState(
      getNotesStatus: getNotesStatus ?? this.getNotesStatus,
      failure: failure ?? this.failure,
      notes: notes ?? this. notes,
    );
  }
}