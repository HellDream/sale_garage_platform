import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final Firestore _db = Firestore.instance;
  FirebaseMessaging _fcm = FirebaseMessaging();

  MessagingService();

  Future<String> getToken() async {
    return await _fcm.getToken();
  }
}
