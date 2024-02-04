import 'package:coaching_app/components/components.dart';
import 'package:coaching_app/components/custom_appbar.dart';
import 'package:coaching_app/config/config.dart';
import 'package:coaching_app/modules/chat/cubit/chat_cubit.dart';
import 'package:coaching_app/modules/chat/models/chat_entity.dart';
import 'package:coaching_app/modules/chat/models/chat_input.dart';
import 'package:coaching_app/modules/chat/widgets/predefine_tile.dart';
import 'package:coaching_app/modules/chat/widgets/receiver_tile.dart';
import 'package:coaching_app/modules/chat/widgets/sender_tile.dart';
import 'package:coaching_app/utils/display/display_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/app_colors.dart';
import 'models/predefine_question_model.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<PredefinedQuestionModel> predefineQuestions = [
    PredefinedQuestionModel(id: 1, question: 'What is JOIN?', color: Colors.blue),
    PredefinedQuestionModel(id: 2, question: 'How can JOIN help me?', color: Colors.green),
    PredefinedQuestionModel(id: 3, question: 'How do I fill out the JOIN Journal?', color: Colors.orange),
  ];

  void jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.linear,
          duration: Duration(milliseconds: 100)
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    scrollToBottom();
  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state.chatStatus == ChatStatus.sending || state.chatStatus == ChatStatus.sent) {
          Future.delayed(Duration(seconds: 0)).then((value) {
            scrollToBottom();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Chat with AI',
            actions: [
              state.messages.length > 0
                  ? IconButton(
                      onPressed: () {
                        if (state.chatStatus == ChatStatus.sending) {
                          DisplayUtils.showSnackBar(context, 'AI is typing...');
                        } else {
                          showFullScreenPopupMenu(context, predefineQuestions);
                        }
                      },
                      icon: Icon(Icons.more),
                    )
                  : EmptyWidget(),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification && _scrollController.position.extentAfter == 0) {
                      print('TRUE');
                      return true;
                    }
                    print('FALSE');
                    return false;
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    controller: _scrollController,
                    // padding: EdgeInsets.symmetric(vertical: 16),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 16);
                    },
                    itemCount: state.messages.isEmpty ? predefineQuestions.length : state.messages.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (state.messages.isEmpty) {
                        return PredefineTile(
                          chat: ChatEntity(
                            message: predefineQuestions[index].question,
                            isMe: true,
                          ),
                          tileColor: predefineQuestions[index].color,
                          messageId: predefineQuestions[index].id,
                          onTap: () {
                            context.read<ChatCubit>().sendPreDefinedMessage(
                                  ChatInput(
                                    message: predefineQuestions[index].question,
                                    questionTaped: true,
                                  ),
                                  predefineQuestions[index].id,
                                );
                          },
                        );
                      } else {
                        return state.messages[index].isMe
                            ? SenderTile(chat: state.messages[index])
                            : ReceiverTile(chat: state.messages[index]);
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: AppColors.darkGrey1,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: chatController,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.deepOrangeAccent,
                        style: TextStyle(fontSize: 14, color: AppColors.black),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          fillColor: AppColors.white,
                          border: kChatTextFieldBorder,
                          enabledBorder: kChatTextFieldBorder,
                          focusedBorder: kChatTextFieldBorder,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          suffixIcon: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: chatController,
                            builder: (BuildContext context, TextEditingValue value, Widget? child) {
                              return IconButton(
                                icon: SvgPicture.asset(
                                  "assets/images/svg/ic_send_message.svg",
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                      value.text.isNotEmpty && state.chatStatus != ChatStatus.sending
                                          ? Colors.black
                                          : Colors.black54,
                                      BlendMode.srcIn),
                                ),
                                onPressed: value.text.isNotEmpty && state.chatStatus != ChatStatus.sending
                                    ? () {
                                        final String message = chatController.text;
                                        chatController.clear();
                                        ChatInput chatInput = ChatInput(message: message);
                                        context.read<ChatCubit>().sendMessage(chatInput);
                                      }
                                    : null,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showFullScreenPopupMenu(BuildContext context, List<PredefinedQuestionModel> predefineQuestions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: AppColors.darkGrey3,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                predefineQuestions.length,
                (index) => Column(
                  children: [
                    PredefineTile(
                      leftMargin: 0,
                      chat: ChatEntity(
                        message: predefineQuestions[index].question,
                        isMe: true,
                      ),
                      tileColor: predefineQuestions[index].color,
                      messageId: predefineQuestions[index].id,
                      onTap: () {
                        NavRouter.pop(context);
                        context.read<ChatCubit>().sendPreDefinedMessage(
                              ChatInput(
                                message: predefineQuestions[index].question,
                                questionTaped: true,
                              ),
                              predefineQuestions[index].id,
                            );
                      },
                    ),
                    if (predefineQuestions[index] != predefineQuestions.last)
                      SizedBox(
                        height: 12,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

OutlineInputBorder kChatTextFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(color: Colors.transparent),
);
