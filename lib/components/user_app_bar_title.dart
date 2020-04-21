import 'package:flutter/material.dart';
import 'package:sale_garage_platform/models/owner.dart';

import 'circle_avatar.dart';

class UserAppBarTitle extends StatelessWidget {
  final Owner owner;

  const UserAppBarTitle({Key key, this.owner}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        UserCircleAvatar(
          imageURL: owner.photoURL,
          size: 40.0,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          owner.displayName,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
