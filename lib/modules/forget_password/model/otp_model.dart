
import 'dart:convert';

OtpModel otpModelFromJson(dynamic json) => OtpModel.fromJson(json);

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
  String result;
  String message;
  OtpData data;

  OtpModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
    result: json["result"],
    message: json["message"],
    data: OtpData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data.toJson(),
  };
}

class OtpData {
  String email;
  int token;
  int id;

  OtpData({
    required this.email,
    required this.token,
    required this.id,
  });

  factory OtpData.fromJson(Map<String, dynamic> json) => OtpData(
    email: json["email"],
    token: json["token"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "token": token,
    "id": id,
  };
}
