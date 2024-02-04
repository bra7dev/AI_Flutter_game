import 'dart:developer';

import 'package:coaching_app/modules/profile/model/get_goals_model.dart';
import 'package:flutter/foundation.dart';
import '../../../constants/api_endpoints.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';

class GetGoalsRepository{

  final NetworkService _service = sl<NetworkService>();

  Future<GetGoalsModel> getGoals() async {
    try {
      var response = await _service.get(
        Endpoints.getGoals,
      );

      GetGoalsModel getGoalsModel =
      await compute(getGoalsModelFromJson, response);

      return getGoalsModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}