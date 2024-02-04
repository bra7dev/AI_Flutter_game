part of 'chat_cubit.dart';

enum ChatStatus {
  none,
  messageAdded,
  sending,
  sent,
  failure,
}

class ChatState {
  final ChatStatus chatStatus;
  final String failureMsg;
  final List<ChatEntity> messages;

  ChatState({
    required this.chatStatus,
    this.messages = const [],
    required this.failureMsg,
  });

  factory ChatState.initial() {
    return ChatState(chatStatus: ChatStatus.none, failureMsg: '', messages: []);
  }

  ChatState copyWith({
    ChatStatus? chatStatus,
    String? failureMsg,
    List<ChatEntity>? messages,
  }) {
    return ChatState(
      chatStatus: chatStatus ?? this.chatStatus,
      messages: messages ?? this.messages,
      failureMsg: failureMsg ?? this.failureMsg,
    );
  }
}
