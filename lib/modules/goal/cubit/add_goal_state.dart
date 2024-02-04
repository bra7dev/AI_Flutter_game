part of 'add_goal_cubit.dart';

enum AddGoalStatus {
  none,
  loading,
  success,
  failure,
}

class AddGoalState {
  final AddGoalStatus addGoalStatus;
  final BaseFailure failure;

  AddGoalState({
    required this.addGoalStatus,
    required this.failure,
  });

  factory AddGoalState.initial() {
    return AddGoalState(
      addGoalStatus: AddGoalStatus.none,
      failure: const BaseFailure(),
    );
  }

  AddGoalState copyWith({
    AddGoalStatus? addGoalStatus,
    BaseFailure? failure,
  }) {
    return AddGoalState(
      addGoalStatus: addGoalStatus ?? this.addGoalStatus,
      failure: failure ?? this.failure,
    );
  }
}
