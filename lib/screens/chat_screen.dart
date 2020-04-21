import 'package:flutter/material.dart';
import 'package:sale_garage_platform/components/circle_avatar.dart';
import 'package:sale_garage_platform/components/item_tile.dart';
import 'package:sale_garage_platform/components/message_stream.dart';
import 'package:sale_garage_platform/components/text_input_widget.dart';
import 'package:sale_garage_platform/components/user_app_bar_title.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/item.dart';
import 'package:sale_garage_platform/models/message.dart';
import 'package:sale_garage_platform/models/owner.dart';
import 'package:sale_garage_platform/models/screen_data.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final Owner owner;

  const ChatScreen({Key key, this.owner}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId;
  TextEditingController _txtController;
  bool _showItem = true;
  Item item;

  @override
  void initState() {
    super.initState();
    _txtController = TextEditingController();
    chatRoomId = chatService.getChatRoomId(
        authService.profileData['uid'], widget.owner.uid);
  }

  @override
  void dispose() {
    _txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    item = ModalRoute.of(context).settings.arguments;
    if (item == null) {
      _showItem = false;
    }
    print("_showItem $_showItem");
//    Provider.of<ScreenData>(context, listen: false).updateReceiveMsg(false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context)
                .pop(await chatService.getLatestMessage(chatRoomId));
          },
        ),
        title: UserAppBarTitle(
          owner: widget.owner,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _showItem
              ? ItemReminderTile(
                  item: item,
                  dismissCallback: () {
                    sendItemMsg();
                    setState(() {
                      _showItem = false;
                    });
                  },
                )
              : SizedBox(),
          MessageStream(
            chatRoomId: chatRoomId,
          ),
          TextInputWidget(
            chatRoomId: chatRoomId,
            txtController: _txtController,
            peerId: widget.owner.uid,
          ),
        ],
      ),
    );
  }

  void sendItemMsg() {
    String id = item.id;
    String peerId = widget.owner.uid;
    String userId = Provider.of<ScreenData>(context, listen: false).userId;
    Message message = Message(
      text: id,
      senderId: userId,
      receiverId: peerId,
      type: 3,
      timestamp: DateTime.now(),
      item: item,
    );
    chatService.sendMessage(message, chatRoomId, peerId);
  }
}
