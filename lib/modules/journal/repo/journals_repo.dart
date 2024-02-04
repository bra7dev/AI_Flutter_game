import 'dart:developer';

import 'package:coaching_app/modules/journal/cubit/create_journal/create_journal_cubit.dart';
import 'package:coaching_app/modules/journal/model/get_journal_model.dart';
import 'package:coaching_app/modules/journal/model/time_slot_model.dart';
import 'package:flutter/foundation.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/api_result.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';

class JournalsRepository {
  final NetworkService _service = sl<NetworkService>();

  Future<GetJournalModel> getJournal(String date) async {
    try {
      var response = await _service.get(
        Endpoints.getJournal,
        queryParameters: {'date': date},
      );

      GetJournalModel getJournalModel =
          await compute(getJournalModelFromJson, response);

      return getJournalModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<bool> createJournal(CreateJournalInput input) async {
    try {
      var response =
          await _service.post(Endpoints.createJournal, data: input.toJson());

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

  Future<List<TimeSlotModel>> getTimeSlots() async {
    try {
      var response = await _service.get(
        Endpoints.getSlots,
      );

      List<TimeSlotModel> tomeSlots =
          await compute(timeSlotModelFromJson, response);

      return tomeSlots;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<bool> updateJournalTask(Map<String, dynamic> queryParameters) async {
    try {
      var response = await _service.get(Endpoints.updateJournalTask,
          queryParameters: queryParameters);

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
