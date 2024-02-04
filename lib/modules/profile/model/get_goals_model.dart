import 'dart:convert';

GetGoalsModel getGoalsModelFromJson(dynamic json) => GetGoalsModel.fromJson(json);

String getGoalsModelToJson(GetGoalsModel data) => json.encode(data.toJson());

class GetGoalsModel {
  String result;
  String message;
  List<Goal> data;

  GetGoalsModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory GetGoalsModel.fromJson(Map<String, dynamic> json) => GetGoalsModel(
    result: json["result"],
    message: json["message"],
    data: List<Goal>.from(json["data"].map((x) => Goal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Goal {
  int id;
  int goalType;
  String description;

  Goal({
    required this.id,
    required this.goalType,
    required this.description,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json["id"],
    goalType: json["goal_type"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "goal_type": goalType,
    "description": description,
  };
}
