import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sale_garage_platform/configs/local_notification_config.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/owner.dart';
import 'package:sale_garage_platform/models/screen_data.dart';
import 'package:sale_garage_platform/screens/chat_screen.dart';
import 'package:provider/provider.dart';

class MessagingConfig {
  final BuildContext context;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  MessagingConfig(this.context) {
    setConfigure();
    configLocalNotification();
  }

  void setConfigure() {
    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage $message');
        Provider.of<ScreenData>(context,listen: false).updateReceiveMsg(true);
        showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume $message');
        Owner owner =
            await userService.getUserByUserId(message['data']['senderId']);
        ChatScreen chatScreen = ChatScreen(
          owner: owner,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => chatScreen,
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch $message');
        Owner owner =
            await userService.getUserByUserId(message['data']['senderId']);
        ChatScreen chatScreen = ChatScreen(
          owner: owner,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => chatScreen,
          ),
        );
      },
    );
  }


  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    Owner owner = await userService.getUserByUserId(payload);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          owner: owner,
        ),
      ),
    );
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      LocalNotificationConfig.channelId,
      LocalNotificationConfig.channelName,
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.High,
      priority: Priority.Default,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'].toString(),
        message['notification']['body'].toString(),
        platformChannelSpecifics,
        payload: message['data']['senderId']);
  }
}
