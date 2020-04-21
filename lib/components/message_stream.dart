import 'package:flutter/material.dart';
import 'package:sale_garage_platform/components/chat_bubble.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/message.dart';

class MessageStream extends StatelessWidget {
  final String chatRoomId;

  const MessageStream({Key key, @required this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatService.streamOfMessages(chatRoomId),
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.hasData) {
          List<Message> messages = snapshot.data;
          return Expanded(
            child: ListView.builder(
              reverse: true,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: messages[index],
                );
              },
              itemCount: messages.length,
            ),
          );
        }
        return Container();
      },
    );
  }
}
