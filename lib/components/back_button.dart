import 'package:flutter/material.dart';

class TopBackBtn extends StatelessWidget {
  final Color color;

  const TopBackBtn({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        color: color==null ? Colors.black.withOpacity(0.6): color,
        iconSize: 20,
        icon: Icon(
          Icons.arrow_back_ios,
        ),
      ),
    );
  }
}
