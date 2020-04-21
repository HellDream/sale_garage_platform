import 'package:flutter/material.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/constants/widget_constants.dart';
import 'package:sale_garage_platform/models/message.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class TextInputWidget extends StatelessWidget {
  final chatRoomId;
  final TextEditingController txtController;
  final String peerId;

  const TextInputWidget({
    Key key,
    @required this.chatRoomId,
    this.txtController,
    this.peerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [kBoxShadow],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: () async {
                      List<Asset> images = await MultiImagePicker.pickImages(
                        maxImages: 1, enableCamera: true);
                      List<String> imageURLs = await imageService.uploadChatImages(images, chatRoomId);
                      await onSendImage(imageURLs);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: txtController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "Type Something...",
                        border: InputBorder.none,
                      ),
                      minLines: 1,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                  boxShadow: [kBoxShadow]),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: onSendMessage,
              ))
        ],
      ),
    );
  }

  void onSendMessage() async {
    if (txtController.text.trim() != '') {
      Message message = Message(
        text: txtController.text,
        timestamp: DateTime.now(),
        senderId: authService.profileData['uid'],
        type: 1,
        receiverId: peerId,
      );
      txtController.clear();
      chatService.sendMessage(message, chatRoomId, peerId);
    }
  }

  void onSendImage(List<String> imageURLs) async {
    for(String url in imageURLs){
      Message message = Message(
          text: url,
        timestamp: DateTime.now(),
        senderId: authService.profileData['uid'],
        type: 2,
        receiverId: peerId,
      );
      chatService.sendMessage(message, chatRoomId, peerId);
    }

  }
}
