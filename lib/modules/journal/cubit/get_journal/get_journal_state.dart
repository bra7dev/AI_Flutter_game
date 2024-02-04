part of 'get_journal_cubit.dart';

enum GetJournalStatus {
  none,
  loading,
  updateLoading,
  updated,
  updateFailure,
  success,
  failure,
}

class GetJournalState {
  final GetJournalStatus getJournalStatus;
  final GetJournalStatus updatingStatus;
  final BaseFailure failure;
  JournalData? data;

  GetJournalState({
    required this.getJournalStatus,
    required this.updatingStatus,
    required this.failure,
    required this.data,
  });

  factory GetJournalState.initial() {
    return GetJournalState(
      getJournalStatus: GetJournalStatus.none,
      updatingStatus: GetJournalStatus.none,
      failure: const BaseFailure(),
      data: null,
    );
  }

  GetJournalState copyWith({
    GetJournalStatus? getJournalStatus,
    GetJournalStatus? updatingStatus,
    BaseFailure? failure,
    JournalData? data,
  }) {
    return GetJournalState(
      getJournalStatus: getJournalStatus ?? this.getJournalStatus,
      updatingStatus: updatingStatus ?? this.updatingStatus,
      failure: failure ?? this.failure,
      data: data ?? this.data,
    );
  }
}
