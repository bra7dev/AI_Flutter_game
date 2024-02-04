import 'dart:convert';

GetJournalModel getJournalModelFromJson(dynamic json) => GetJournalModel.fromJson(json);

String getJournalModelToJson(GetJournalModel data) => json.encode(data.toJson());

class GetJournalModel {
  String result;
  String message;
  JournalData data;

  GetJournalModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory GetJournalModel.fromJson(Map<String, dynamic> json) => GetJournalModel(
    result: json["result"],
    message: json["message"],
    data: JournalData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data.toJson(),
  };
}

class JournalData {
  Journal journal;
  List<HourlyPlanner> hourlyPlanner;

  JournalData({
    required this.journal,
    required this.hourlyPlanner,
  });

  factory JournalData.fromJson(Map<String, dynamic> json) => JournalData(
    journal: Journal.fromJson(json["journal"]),
    hourlyPlanner: List<HourlyPlanner>.from(json["hourlyPlanner"].map((x) => HourlyPlanner.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "journal": journal.toJson(),
    "hourlyPlanner": List<dynamic>.from(hourlyPlanner.map((x) => x.toJson())),
  };
}

class HourlyPlanner {
  int? id;
  int slotId;
  String slot;
  String task;
  int isComplete;

  HourlyPlanner({
     this.id,
    required this.slotId,
    required this.slot,
    required this.task,
    required this.isComplete,
  });

  factory HourlyPlanner.fromJson(Map<String, dynamic> json) => HourlyPlanner(
    id: json["id"],
    slotId: json["slot_id"],
    slot: json["slot"],
    task: json["task"],
    isComplete: json["is_complete"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slot_id": slotId,
    "slot": slot,
    "task": task,
    "is_complete": isComplete,
  };
}

class Journal {
  int id;
  DateTime date;
  String endOfDayReview;
  String improveThings;
  String positiveAffirmation;
  String tomorrowGoal;
  String morningRefinement;
  String dailyGoal;
  int userId;

  Journal({
    required this.id,
    required this.date,
    required this.endOfDayReview,
    required this.improveThings,
    required this.positiveAffirmation,
    required this.tomorrowGoal,
    required this.morningRefinement,
    required this.dailyGoal,
    required this.userId,
  });

  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    endOfDayReview: json["end_of_day_review"],
    improveThings: json["improve_things"],
    positiveAffirmation: json["positive_affirmation"],
    tomorrowGoal: json["tomorrow_goal"],
    morningRefinement: json["morning_refinement"],
    dailyGoal: json["daily_goal"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "end_of_day_review": endOfDayReview,
    "improve_things": improveThings,
    "positive_affirmation": positiveAffirmation,
    "tomorrow_goal": tomorrowGoal,
    "morning_refinement": morningRefinement,
    "daily_goal": dailyGoal,
    "user_id": userId,
  };
}
