import 'package:flutter/material.dart';
import 'package:sale_garage_platform/components/item_list.dart';


class ShowListScreen extends StatelessWidget {
  final String userId;
  const ShowListScreen({Key key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ItemGridList(
      userId: userId,
    );
  }
}
