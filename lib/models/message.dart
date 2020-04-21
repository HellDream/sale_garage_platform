import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sale_garage_platform/models/item.dart';

class Message{
  String text;
  DateTime timestamp;
  String senderId;
  String receiverId;
  int type;
  Item item;

  Message({this.text, this.timestamp, this.senderId, this.type, this.receiverId, this.item});

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      type: json['type'] as int,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId']==null? null:json['receiverId'],
      item: json['item']==null? null:Item.fromJson(json['item']),
    );
  }


  factory Message.fromFireStore(DocumentSnapshot doc){
    Message message = Message.fromJson(doc.data);
    return message;
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'senderId': senderId,
      'type':type,
      'receiverId': receiverId,
      'item': item==null?null: item.toJson(),
    };
  }


}