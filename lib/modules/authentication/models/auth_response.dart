import 'dart:convert';

AuthResponse authResponseFromJson(dynamic json) => AuthResponse.fromJson(json);

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  final String result;
  final String message;
  final User user;
  final String token;

  AuthResponse( {
    required this.result,
    required this.message,
    required this.user,
    required this.token,

  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        result: json["result"],
        message: json["message"],
        user: json["data"] == null ? User.empty : User.fromJson(json["data"]),
    token: json["token"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "data": user.toJson(),
    "token": token,
      };
}

class User {
  String fullName;
  String email;
  String fcmToken;
  String location;
   dynamic profile;
   String personalInfo;

  User({
    required this.fullName,
    required this.email,
    this.profile = '',
    this.fcmToken = '',
    this.location = '',
    this.personalInfo = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json["full_name"],
    email: json["email"],
    profile: json["profile_image"] ?? '',
    location: json["location"] ?? '',
    fcmToken: json["fcm_token"] ?? '',
    personalInfo: json["personal_info"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "email": email,
    "profile_image": profile,
    "location": location,
    "fcm_token": fcmToken,
    "personal_info": personalInfo,
  };

  static User empty = User(
    fullName: '',
    email: '',
    profile: '',
    location: '',
    fcmToken: '',
    personalInfo: '',
  );
}



