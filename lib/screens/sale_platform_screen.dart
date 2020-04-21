import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:sale_garage_platform/configs/messaging_config.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/screen_data.dart';
import 'package:sale_garage_platform/screens/chat_list_screen.dart';
import 'package:sale_garage_platform/screens/user_profile_screen.dart';
import 'package:sale_garage_platform/screens/show_list_screen.dart';
import 'package:sale_garage_platform/screens/post_item.dart';
import 'package:provider/provider.dart';

class SalePlatformScreen extends StatefulWidget {
  static String id = '/SalePlatformScreen';

  @override
  _SalePlatformScreenState createState() => _SalePlatformScreenState();
}

class _SalePlatformScreenState extends State<SalePlatformScreen> {
  int _selectedIndex = 0;

  List<Widget> pages = [ShowListScreen(), UserProfileScreen()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenData data = Provider.of<ScreenData>(context, listen: true);
    data.updateUserId(authService.profileData['uid']);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sale Garage Platform',
        ),
        actions: <Widget>[
          _buildMsgButton(data.receiveMsg)
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            SizedBox(),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, PostScreen.id).whenComplete((){
            setState(() {
              pages[0] = ShowListScreen();
            });
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildMsgButton(bool receiveMsg) {
    print("receive: $receiveMsg");
    Widget msgIcon = IconButton(
      onPressed: () async {
        Provider.of<ScreenData>(context, listen: false).updateReceiveMsg(false);
        Navigator.pushNamed(
          context,
          ChatRoomListScreen.id,
        );
      },
      icon: Icon(
        Icons.message,
        color: Colors.white,
      ),
    );
    if (receiveMsg) {
      return Badge(
        position: BadgePosition.topRight(top: 10, right: 10),
        child: msgIcon,
      );
    } else {
      return msgIcon;
    }
  }
}
