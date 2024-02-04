import 'package:coaching_app/modules/chat/models/chat_input.dart';
import 'package:coaching_app/modules/chat/models/chat_response.dart';
import 'package:dio/dio.dart';

import '../../../core/core.dart';

class ChatRepository {
  Future<ChatResponse> sendMessage(ChatInput chatInput) async {
    try {
      var response = await Dio().post('https://api.openai.com/v1/chat/completions',
          data: chatInput.toJson(),
          options: Options(headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer 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',
          }));
      ChatResponse chatResponse = ChatResponse.fromJson(response.data);
      return chatResponse;
    } on DioException catch (error) {
      throw BaseFailure.handleFailure(error);
    } catch (e) {
      throw Exception(e);
    }
  }
}
