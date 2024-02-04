class ChatEntity {
  String message;
  bool isMe;
  String status;

  ChatEntity({required this.message, required this.isMe, this.status = 'none'});

  factory ChatEntity.empty() => ChatEntity(message: '', isMe: false, status: 'none');
}
