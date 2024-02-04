import 'dart:developer';

import 'package:coaching_app/modules/goal/cubit/add_goal_cubit.dart';
import 'package:dio/dio.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/api_result.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';

class AddGoalRepository{

  final NetworkService _service = sl<NetworkService>();

  Future<bool> createGoal(FormData input) async {
    try {
      var response = await _service.post(
        Endpoints.createGoal,
        data: input,
      );

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