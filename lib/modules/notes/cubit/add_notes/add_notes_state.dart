part of 'add_notes_cubit.dart';

enum AddNotesStatus {
  none,
  loading,
  success,
  failure,
}

class AddNotesState {
  final AddNotesStatus addNotesStatus;
  final BaseFailure failure;

  AddNotesState({
    required this.addNotesStatus,
    required this.failure,
  });

  factory AddNotesState.initial() {
    return AddNotesState(
      addNotesStatus: AddNotesStatus.none,
      failure: const BaseFailure(),
    );
  }

  AddNotesState copyWith({
    AddNotesStatus? addNotesStatus,
    BaseFailure? failure,
  }) {
    return AddNotesState(
      addNotesStatus: addNotesStatus ?? this.addNotesStatus,
      failure: failure ?? this.failure,
    );
  }
}
