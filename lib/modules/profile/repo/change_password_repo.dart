import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/api_result.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';
import '../../authentication/models/auth_response.dart';
import '../cubit/change_password/change_password_cubit.dart';

class ChangePasswordRepository {
  final NetworkService _service = sl<NetworkService>();

  Future<bool> changePasswordApi(ChangePasswordInput data) async {
    try {
      var response =
          await _service.post(Endpoints.changePassword, data: data.toJson());

      if (response['result'] == ApiResult.success) {
        return true;
      } else {
        throw response['message'];
      }
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}
