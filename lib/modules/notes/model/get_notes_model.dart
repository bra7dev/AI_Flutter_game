import 'dart:convert';

GetNotesModel getNotesModelFromJson(dynamic json) => GetNotesModel.fromJson(json);

String getNotesModelToJson(GetNotesModel data) => json.encode(data.toJson());

class GetNotesModel {
  String result;
  String message;
  List<Notes> data;

  GetNotesModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory GetNotesModel.fromJson(Map<String, dynamic> json) => GetNotesModel(
    result: json["result"],
    message: json["message"],
    data: List<Notes>.from(json["data"].map((x) => Notes.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Notes {
  DateTime date;
  String note;

  Notes({
    required this.date,
    required this.note,
  });

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
    date: DateTime.parse(json["date"]),
    note: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "notes": note,
  };
}
