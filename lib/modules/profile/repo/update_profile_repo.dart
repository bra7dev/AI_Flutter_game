import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../constants/api_endpoints.dart';
import '../../../core/api_result.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';
import '../../authentication/models/auth_response.dart';
import '../../authentication/repo/auth_repository.dart';
import '../cubit/update_profile/update_profile_cubit.dart';

class UpdateProfileRepo {
  final NetworkService _networkApiService = sl<NetworkService>();
  final AuthRepository _authRepository = sl<AuthRepository>();

  Future<bool> updateProfileApi(FormData data) async {
    try {
      var response = await _networkApiService.post(
        Endpoints.updateProfile,
        data: data,
      );
      AuthResponse authResponse = await compute(authResponseFromJson, response);

      if (authResponse.result == ApiResult.success) {
        // _authRepository.user.fullName = authResponse.user.fullName;
        // _authRepository.user.location = authResponse.user.location;
        // _authRepository.user.profile = authResponse.user.profile;
        _authRepository.saveUser(authResponse.user);
        print(authResponse.user);

        return true;
      } else {
        throw authResponse.message;
      }
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}
