import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/item.dart';
import 'package:sale_garage_platform/models/screen_data.dart';
import 'package:sale_garage_platform/screens/chat_list_screen.dart';
import 'package:sale_garage_platform/screens/login_screen.dart';
import 'package:sale_garage_platform/screens/post_item.dart';
import 'package:sale_garage_platform/screens/sale_platform_screen.dart';
import 'package:sale_garage_platform/screens/user_posts_screen.dart';
import 'package:provider/provider.dart';

import 'configs/messaging_config.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<bool> checkLoginStatus() async {
  FirebaseUser firebaseUser = await _auth.currentUser();
  if (firebaseUser != null) {
    await authService.updateUserData(firebaseUser);
    return true;
  }
  return false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firestore.instance.settings(persistenceEnabled: true);
  bool isLogin = await checkLoginStatus();
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<List<Item>>.value(value: postService.streamOfItems()),
        ChangeNotifierProvider(create: (BuildContext context) {
          return ScreenData();
        }),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      initialRoute: MainEntry.id,
      routes: {
        SalePlatformScreen.id: (context) => SalePlatformScreen(),
        PostScreen.id: (context) => PostScreen(),
        UserPostScreen.id: (context) => UserPostScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatRoomListScreen.id:(context) => ChatRoomListScreen(),
        MainEntry.id:(context) => MainEntry(isLogin: isLogin,),
      },
    ),
  ));
}

class MainEntry extends StatefulWidget {
  static String id = '/';
  const MainEntry({
    Key key,
    @required this.isLogin,
  }) : super(key: key);

  final bool isLogin;

  @override
  _MainEntryState createState() => _MainEntryState();
}

class _MainEntryState extends State<MainEntry> {
  MessagingConfig messagingConfig;

  @override
  void initState() {
    super.initState();
    messagingConfig = MessagingConfig(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isLogin ? SalePlatformScreen() : LoginScreen(),
    );
  }
}
