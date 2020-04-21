import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sale_garage_platform/components/item_tile.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/constants/widget_constants.dart';
import 'package:sale_garage_platform/models/item.dart';
import 'package:sale_garage_platform/models/message.dart';
import 'package:sale_garage_platform/models/screen_data.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<ScreenData>(context).userId;
    if (message.senderId == userId) {
      return _buildSenderBubble(context);
    }
    return _buildReceiverBubble(context);
  }

  Widget _buildReceiverBubble(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .6),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              boxShadow: [
                kBoxShadow,
              ],
            ),
            child: _bubbleDetailWidget(context, Colors.black87),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            dateFormatJm.format(message.timestamp),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _bubbleDetailWidget(context, textColor) {
    if (message.type == 1) {
      return Text(
        message.text,
        style: TextStyle(color: textColor),
      );
    }

    if (message.type == 2) {
      return Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .6),
        child: Image(
          image: CachedNetworkImageProvider(
            message.text,
          ),
        ),
      );
    }

    if (message.type == 3) {
      Item item = message.item;
      return ItemMsgTile(item:item);
    }

    return Container();
  }

  Widget _buildSenderBubble(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .6,),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
              boxShadow: [kBoxShadow],
            ),
            child: _bubbleDetailWidget(context, Colors.white),
          ),
          SizedBox(height: 5,),

          Text(
            dateFormatJm.format(message.timestamp),
            style: TextStyle(color: Colors.grey),
          ),

        ],
      ),
    );
  }
}
