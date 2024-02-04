class ChatInput {
  final String message;
  final bool questionTaped;

  ChatInput({required this.message, this.questionTaped= false});

  Map<String, dynamic> toJson() => {
        "model": 'gpt-3.5-turbo',
        "messages": [
          {
            'role': 'user',
            'content': 'Act as a Life and Business Coach. $message',
          }
        ],
        "temperature": 0.7,
      };
}
