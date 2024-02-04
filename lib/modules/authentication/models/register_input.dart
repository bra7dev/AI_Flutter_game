import 'package:dio/dio.dart';

class RegisterInput {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  //String? androidFcmToken;
  //String? iosFcmToken;

  RegisterInput({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    //this.androidFcmToken = "",
    //this.iosFcmToken = "",
  });

  Map<String, dynamic> toJson() => {
    "full_name": name,
    "email": email,
    "password": password,
    "password_confirmation": confirmPassword,
    //"AndroidFcmToken": androidFcmToken,
    //"IosFcmToken": iosFcmToken,
  };

  FormData toFormData() => FormData.fromMap({
    "full_name": name,
    "email": email,
    "password": password,
    "password_confirmation": confirmPassword,
    //"AndroidFcmToken": androidFcmToken,
    //"IosFcmToken": iosFcmToken,
  });
}
