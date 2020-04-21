import 'package:flutter/material.dart';
import 'package:sale_garage_platform/models/screen_data.dart';
import 'package:sale_garage_platform/screens/show_list_screen.dart';
import 'package:provider/provider.dart';

class UserPostScreen extends StatelessWidget {
  static String id = '/UserPostScreen';

  @override
  Widget build(BuildContext context) {
    ScreenData data = Provider.of<ScreenData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
      ),
      body: ShowListScreen(
        userId: data.userId,
      ),
    );
  }
}
