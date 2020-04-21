import 'package:flutter/material.dart';
import 'package:sale_garage_platform/components/item_card.dart';
import 'package:sale_garage_platform/components/item_tile.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/item.dart';

class ItemList extends StatelessWidget {
  final String userId;

  const ItemList({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userId == null
          ? postService.streamOfItems()
          : postService.streamOfItemsByUserId(userId),
      builder: (context, AsyncSnapshot<List<Item>> snapshot) {
        if (snapshot.hasData) {
          List<Item> itemList = snapshot.data;
          return ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return ItemReminderTile(
                item: itemList[index],
              );
            },
          );
        } else {
          return Center(
            child: Text('fetching...'),
          );
        }
      },
    );
  }
}

class ItemGridList extends StatelessWidget {
  final String userId;

  const ItemGridList({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userId == null
          ? postService.streamOfItems()
          : postService.streamOfItemsByUserId(userId),
      builder: (context, AsyncSnapshot<List<Item>> snapshot) {
        if (snapshot.hasData) {
          List<Item> itemList = snapshot.data;
          return GridView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return ItemCard(
                item: itemList[index],
                dismiss: userId != null,
              );
            },
            padding: EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 8.0 / 9.0,
            ),
          );
        } else {
          return Center(
            child: Text('fetching...'),
          );
        }
      },
    );
  }
}
