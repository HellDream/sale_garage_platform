import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sale_garage_platform/configs/db_config.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/latest_message.dart';
import 'package:sale_garage_platform/models/message.dart';
import 'package:sale_garage_platform/models/owner.dart';
class ChatService {
  final Firestore _db = Firestore.instance;

  Stream<List> streamOfLatestChatList() {
    Stream<List> stream = Stream.fromFuture(getUserChatList());
    return stream;
  }

  /// return a [] with 3 object: peer, last message, chatRoomId
  Future<List<LatestMessage>> getUserChatList() async {
    List<LatestMessage> chatLists = [];
    List<dynamic> chatRooms = [];
    // user chatRoom check
    await getChatRooms(authService.profileData['uid'], null, chatRooms);
    for (DocumentReference doc in chatRooms) {
      String chatRoomId = doc.documentID;
      Message message = await getLatestMessage(chatRoomId);
      Owner owner;
      if (message.senderId != authService.profileData['uid']) {
        owner = await userService.getUserByUserId(message.senderId);
      } else {
        owner = await userService.getUserByUserId(message.receiverId);
      }
      if (owner != null) {
        print(owner.toJson());
        chatLists.add(LatestMessage(
            owner: owner, message: message, chatRoomId: chatRoomId));
      }
    }
    print(chatLists.length);
    return chatLists;
  }

  String getChatRoomId(String userId, String peerId) {
    if (userId.hashCode <= peerId.hashCode) {
      return '$userId-$peerId';
    }
    return '$peerId-$userId';
  }

  Stream<List<Message>> streamOfMessages(String chatRoomId) {
    var ref = _db
        .collection(tChats)
        .document(chatRoomId)
        .collection(chatRoomId)
        .orderBy('timestamp', descending: true);
    Stream<List<Message>> messages =
        ref.snapshots().map((list) => list.documents.map((doc) {
              print(doc.metadata.isFromCache);
              return Message.fromFireStore(doc);
            }).toList());
    return messages;
  }

  void sendMessage(Message message, String chatRoomId, String peerId) async {
    var chatRoomDoc = _db.collection(tChats).document(chatRoomId);

    // user chatRoom check
    await _checkExistChatRoom(chatRoomDoc, authService.profileData['uid']);

    // peer chatRoom check
    await _checkExistChatRoom(chatRoomDoc, peerId);
    await chatRoomDoc.setData(message.toJson());
    var ref = chatRoomDoc.collection(chatRoomId);
    await ref.add(message.toJson());
    print('send message!');
  }

  Future<void> getChatRooms(
      String userId, Set<String> chatRoomId, List<dynamic> list) async {
    var doc = await _db.collection(tUserChats).document(userId).get();
    if (doc.data != null) {
      var rooms = doc.data['chatRooms'];
      print('$userId ${rooms.length}');
      list.addAll(rooms);
      if (chatRoomId != null) {
        for (var room in rooms) {
          chatRoomId.add(room.documentID);
        }
      }
    }
  }

  Future<void> _checkExistChatRoom(
      DocumentReference chatRoomDocRef, String uid) async {
    List<dynamic> chatRooms = [];
    Set<String> chatRoomsID = Set();
    // user chatRoom check
    await getChatRooms(uid, chatRoomsID, chatRooms);
    print(chatRooms.length);
    if (!chatRoomsID.contains(chatRoomDocRef.documentID)) {
      updateUserChatRooms(chatRoomDocRef, uid, chatRooms);
    }
  }

  void updateUserChatRooms(DocumentReference chatRoomDocRef, String userId,
      List<dynamic> chatRooms) {
    chatRooms.add(chatRoomDocRef);
    _db
        .collection(tUserChats)
        .document(userId)
        .setData({'chatRooms': chatRooms});
  }

  Future<Message> getLatestMessage(String chatRoomId) async {
    var ref = _db.collection(tChats).document(chatRoomId);
    var doc = await ref.get();
    if (doc.data != null) {
      return Message.fromFireStore(doc);
    }
    var ref2  = _db
        .collection(tChats)
        .document(chatRoomId)
        .collection(chatRoomId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
    var snap = await ref2.first;
    if(snap.documents.length!=0){
      return Message.fromFireStore(snap.documents.first);
    }
    return null;
  }
}
