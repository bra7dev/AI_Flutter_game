import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:coaching_app/modules/notes/model/get_notes_model.dart';
import 'package:flutter/foundation.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/api_result.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';

class NotesRepository {
  final NetworkService _service = sl<NetworkService>();

  Future<GetNotesModel> getNotes(String date) async {
    try {
      var response = await _service.get(
        Endpoints.getNotes,
        queryParameters: {'date': date},
      );

      GetNotesModel getNotesModel =
      await compute(getNotesModelFromJson, response);

      return getNotesModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<bool> addNotes(FormData input) async {
    try {
      var response = await _service.post(
        Endpoints.createNotes,
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
