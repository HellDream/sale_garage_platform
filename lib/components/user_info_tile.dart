import 'package:flutter/material.dart';

class UserInfoTile extends StatelessWidget {
  final String info;
  final IconData icon;
  const UserInfoTile({Key key, this.info, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: ListTile(
        leading: Icon(
          icon,
        ),
        title: Text(
          info,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
