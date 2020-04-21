import 'package:flutter/material.dart';
import 'package:sale_garage_platform/components/user_app_bar_title.dart';
import 'package:sale_garage_platform/models/owner.dart';
import 'package:sale_garage_platform/screens/show_list_screen.dart';

class OwnerPostScreen extends StatelessWidget {
  final Owner owner;

  const OwnerPostScreen({Key key, this.owner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
        title: UserAppBarTitle(
          owner: owner,
        ),
      ),
      body: ShowListScreen(
        userId: owner.uid,
      ),
    );
  }
}
