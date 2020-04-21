import 'package:flutter/material.dart';
import 'package:sale_garage_platform/components/circle_avatar.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/latest_message.dart';
import 'package:sale_garage_platform/models/message.dart';
import 'package:sale_garage_platform/models/owner.dart';
import 'package:sale_garage_platform/models/screen_data.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';

class ChatRoomListScreen extends StatefulWidget {
  static String id = '/ChatRoomListScreen';

  const ChatRoomListScreen({Key key}) : super(key: key);

  @override
  _ChatRoomListScreenState createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
      ),
      body: StreamBuilder(
        stream: Stream.fromFuture(chatService.getUserChatList()),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<LatestMessage> chatList = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                return _buildChatTile(chatList[index], context);
              },
              itemCount: chatList.length,
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildChatTile(LatestMessage chatInfo, BuildContext context) {
    // [] with 3 object: peer, last message, chatRoomId
    Owner owner = chatInfo.owner;
    Message message = chatInfo.message;
    Widget userPhotoWidget = _buildUserPhotoWidget(owner);
    return InkWell(
      onTap: () async {
        Message msg = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              owner: owner,
            ),
          ),
        );
        setState(() {
          message = msg;
        });
      },
      child: Card(
        child: ListTile(
          leading: userPhotoWidget,
          title: Text(owner.displayName),
          subtitle: Text(
            message.type == 1
                ? message.text
                : message.type == 2 ? '[picture]' : '[item]',
            style: TextStyle(color: Colors.grey[600]),
            maxLines: 2,
          ),
          trailing: Text(dateFormatHm.format(message.timestamp)),
        ),
      ),
    );
  }

  Widget _buildUserPhotoWidget(Owner owner) {
    if (owner == null) {
      return UserCircleAvatar(
        imageURL: null,
        size: 50,
      );
    }
    return UserCircleAvatar(
      imageURL: owner.photoURL,
      size: 50,
    );
  }
}
