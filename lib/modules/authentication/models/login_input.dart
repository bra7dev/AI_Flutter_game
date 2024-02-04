import 'package:dio/dio.dart';

class LoginInput {
  final String email;
  final String password;
  String? androidFcmToken;
  String? iosFcmToken;

  LoginInput({
    required this.email,
    required this.password,
    this.androidFcmToken = "",
    this.iosFcmToken = "",
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "androidFcmToken": androidFcmToken,
        "iosFcmToken": iosFcmToken,
      };

  FormData toFormData() => FormData.fromMap({
        'email': email,
        'password': password,
        'androidFcmToken': androidFcmToken,
        'iosFcmToken': iosFcmToken,
      });
}
