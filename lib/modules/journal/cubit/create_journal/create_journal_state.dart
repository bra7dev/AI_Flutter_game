part of 'create_journal_cubit.dart';

enum CreateJournalStatus {
  none,
  loading,
  success,
  failure,
}

class CreateJournalState {
  final CreateJournalStatus createJournalStatus;
  final BaseFailure failure;
  final bool isAutoValidate;

  CreateJournalState({
    required this.createJournalStatus,
    required this.failure,
    required this.isAutoValidate
  });

  factory CreateJournalState.initial() {
    return CreateJournalState(
      createJournalStatus: CreateJournalStatus.none,
      isAutoValidate: false,
      failure: const BaseFailure(),
    );
  }

  CreateJournalState copyWith({
    CreateJournalStatus? createJournalStatus,
    BaseFailure? failure,
    bool? isAutoValidate,
  }) {
    return CreateJournalState(
      createJournalStatus: createJournalStatus ?? this.createJournalStatus,
      isAutoValidate: isAutoValidate ?? this.isAutoValidate,
      failure: failure ?? this.failure,
    );
  }
}
