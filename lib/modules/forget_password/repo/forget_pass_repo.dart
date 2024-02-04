import 'dart:developer';

import '../../../constants/api_endpoints.dart';
import '../../../core/api_result.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';
import '../cubits/reset_password_cubit.dart';

class ForgetPasswordRepository{
  final NetworkService _networkService = sl<NetworkService>();

  Future<String> sendOtp(String email) async {

    try {
      var response = await _networkService.get(
        Endpoints.sentOtpCode,
        queryParameters: {"email": email},
      );

      if(response['result'] == ApiResult.success){
        return response['data']['token'].toString();
      }

      throw response['message'];
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<bool> resetPassword(ResetPasswordInput input) async {
    try {
      var response = await _networkService.post(
        Endpoints.resetPassword,
        queryParameters: input.toJson(),
      );

      if(response['result'] == ApiResult.success){
        return true;
      }
      throw response['message'];
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

}