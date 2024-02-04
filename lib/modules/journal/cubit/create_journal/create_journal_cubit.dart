import 'dart:convert';

import 'package:bloc/bloc.dart';

import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../../../core/storage_service/storage_service.dart';
import '../../model/get_journal_model.dart';
import '../../repo/journals_repo.dart';

part 'create_journal_state.dart';

class CreateJournalCubit extends Cubit<CreateJournalState> {
  CreateJournalCubit(this._repository)
      : super(CreateJournalState.initial());

  JournalsRepository _repository;

  void enableAutoValidateMode() => emit(
    state.copyWith(
      isAutoValidate: true,
      createJournalStatus: CreateJournalStatus.none,
    ),
  );
  Future createJournal(CreateJournalInput journalInput) async {
    emit(state.copyWith(createJournalStatus: CreateJournalStatus.loading));

    try {
      bool res = await _repository.createJournal(journalInput);

      if (res) {
        emit(state.copyWith(
          createJournalStatus: CreateJournalStatus.success,
        ));
      } else {
        emit(state.copyWith(
            createJournalStatus: CreateJournalStatus.failure,
            failure: HighPriorityException('Something went Wrong, try again')));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          createJournalStatus: CreateJournalStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}

class CreateJournalInput {
  final String date;
  String endOfDayReview;
  String improveThings;
  String positiveAffirmation;
  String tomorrowGoal;
  String morningAffirmation;
  String dailyGoal;
  List<HourlyPlanner> hourlyPlanner;

  CreateJournalInput({
    required this.date,
    required this.endOfDayReview,
    required this.improveThings,
    required this.positiveAffirmation,
    required this.tomorrowGoal,
    required this.morningAffirmation,
    required this.dailyGoal,
    required this.hourlyPlanner,
  });

  static CreateJournalInput empty() => CreateJournalInput(
      date: '',
      endOfDayReview: '',
      improveThings: '',
      positiveAffirmation: '',
      tomorrowGoal: '',
      morningAffirmation: '',
      dailyGoal: '',
      hourlyPlanner: []);

  Map<String, dynamic> toJson() => {
        "date": date,
        "end_of_day_review": endOfDayReview,
        "improve_things": improveThings,
        "positive_affirmation": positiveAffirmation,
        "tomorrow_goal": tomorrowGoal,
        "morning_refinement": morningAffirmation,
        "daily_goal": dailyGoal,
        "hourly_planner":
            List<dynamic>.from(hourlyPlanner.map((x) => x.toJson())),
      };

  factory CreateJournalInput.fromJson(Map<String, dynamic> json) =>
      CreateJournalInput(
        date: json["date"]??'',
        endOfDayReview: json["end_of_day_review"]??'',
        improveThings: json["improve_things"] ?? '',
        positiveAffirmation: json["positive_affirmation"] ?? '',
        tomorrowGoal: json["tomorrow_goal"] ?? '',
        morningAffirmation: json["morning_refinement"] ?? '',
        dailyGoal: json["daily_goal"] ?? '',
        hourlyPlanner:json["hourly_planner"]!=null? List<HourlyPlanner>.from(
            json["hourly_planner"].map((x) => HourlyPlanner.fromJson(x))):[],
      );
}
