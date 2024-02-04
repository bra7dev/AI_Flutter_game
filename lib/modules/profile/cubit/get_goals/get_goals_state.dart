part of 'get_goals_cubit.dart';

enum GetGoalsStatus {
  none,
  loading,
  success,
  failure,
}

class GetGoalsState {
  final GetGoalsStatus getGoalsStatus;
  final BaseFailure failure;
  final List<Goal> goals;

  GetGoalsState({
    required this.getGoalsStatus,
    required this.failure,
    required this.goals,
  });

  factory GetGoalsState.initial() {
    return GetGoalsState(
        getGoalsStatus: GetGoalsStatus.none,
        failure: const BaseFailure(),
        goals: []
    );
  }

  GetGoalsState copyWith({
    GetGoalsStatus? getGoalsStatus,
    BaseFailure? failure,
    List<Goal>? goals,

  }) {
    return GetGoalsState(
      getGoalsStatus: getGoalsStatus ?? this.getGoalsStatus,
      failure: failure ?? this.failure,
      goals: goals ?? this.goals,
    );
  }
}
