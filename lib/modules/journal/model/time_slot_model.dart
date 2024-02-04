

List<TimeSlotModel> timeSlotModelFromJson(dynamic json) => List<TimeSlotModel>.from(json.map((x) => TimeSlotModel.fromJson(x)));


class TimeSlotModel {
  int id;
  String slot;

  TimeSlotModel({
    required this.id,
    required this.slot,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => TimeSlotModel(
    id: json["id"],
    slot: json["slot"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slot": slot,
  };
}
