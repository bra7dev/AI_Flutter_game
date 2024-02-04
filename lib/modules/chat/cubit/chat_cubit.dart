import 'package:bloc/bloc.dart';
import 'package:coaching_app/modules/chat/models/chat_entity.dart';
import 'package:coaching_app/modules/chat/models/chat_input.dart';
import 'package:coaching_app/modules/chat/repository/chat_repository.dart';
import 'package:coaching_app/modules/chat/repository/predefined_chat_repository.dart';

import '../models/chat_response.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this.chatRepository, this.predefinedChatRepository) : super(ChatState.initial());
  ChatRepository chatRepository;
  PredefinedChatRepository predefinedChatRepository;

  List<ChatEntity> messages = [];

  Future sendMessage(ChatInput chatInput) async {
    try {
      addMyMessageInList(chatInput);
      emit(state.copyWith(chatStatus: ChatStatus.sending));
      ChatResponse chatResponse = await chatRepository.sendMessage(chatInput);
      messages.last
        ..message = chatResponse.choices.first.message.content
        ..isMe = false
        ..status = 'done';
      emit(state.copyWith(chatStatus: ChatStatus.sent, messages: messages));
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.failure, failureMsg: e.toString()));
    }
  }

  Future sendPreDefinedMessage(ChatInput chatInput, int id) async {
    try {
      addMyMessageInList(chatInput);
      emit(state.copyWith(chatStatus: ChatStatus.sending));
      PredefinedModel predefinedModel = await predefinedChatRepository.getAnswer(id);
      Future.delayed(Duration(seconds: 2), () {
        messages.last
          ..message = predefinedModel.answer
          ..isMe = false
          ..status = 'done';
        emit(state.copyWith(chatStatus: ChatStatus.sent, messages: messages));
      });
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.failure, failureMsg: e.toString()));
    }
  }

  void addMyMessageInList(ChatInput chatInput) {
    messages.add(ChatEntity(message: chatInput.message, isMe: true));
    messages.add(ChatEntity(message: '', isMe: false, status: 'typing'));
    emit(state.copyWith(messages: messages, chatStatus: ChatStatus.messageAdded));
  }
}
