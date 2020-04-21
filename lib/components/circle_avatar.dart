import 'package:flutter/material.dart';

class UserCircleAvatar extends StatelessWidget {
  final String imageURL;
  final double size;

  const UserCircleAvatar({Key key, this.imageURL, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(.3),
              offset: Offset(0, 2),
              blurRadius: 5)
        ],
      ),
      child: imageURL != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(imageURL),
            )
          : CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
    );
  }
}
