import 'package:sale_garage_platform/models/message.dart';
import 'package:sale_garage_platform/models/owner.dart';

class LatestMessage{
  Owner owner;
  Message message;
  String chatRoomId;
  LatestMessage({this.owner,this.message, this.chatRoomId});
}