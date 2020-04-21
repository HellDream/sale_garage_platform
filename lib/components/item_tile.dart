import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sale_garage_platform/models/item.dart';
import 'package:sale_garage_platform/screens/item_detail_screen.dart';

class ItemReminderTile extends StatelessWidget {
  final Item item;
  final VoidCallback dismissCallback;

  const ItemReminderTile({Key key, this.item, this.dismissCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return _buildItemTile(context);
    if (item == null) {
      return SizedBox();
    }
    return Dismissible(
      key: Key(item.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: Card(
        child: ListTile(
          leading: (item.images == null || item.images.length == 0)
              ? Image.asset(
            'images/garage-sale.jpg',
          )
              : CachedNetworkImage(
            imageUrl: item.images.first,
            progressIndicatorBuilder: (context, string, event) =>
                Center(child: CircularProgressIndicator()),
          ),
          title: Text(item.title),
          subtitle: Text(
            item.description.length > 10
                ? item.description.substring(0, 10)
                : item.description,
            style: const TextStyle(fontSize: 10.0),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueAccent,
            ),
            height: 35,
            width: 59,
            child: FlatButton(
              onPressed: () => dismissCallback(),
              child: Text(
                "Sent",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemMsgTile extends StatelessWidget {
  final Item item;

  const ItemMsgTile({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailScreen(item: item),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: _buildImageSection(),
          title: Text(item.title),
          subtitle: Text('\$ ${item.price}', style: TextStyle(color: Colors.red),),
        ),
      ),
    );
  }

  Widget _buildImageSection(){
    if(item.images==null||item.images.length==0){
      return Image.asset('images/garage-sale.jpg', height: 50, width: 50,);
    }
    return CachedNetworkImage(imageUrl: item.images.first,height: 50, width: 50,);
  }
}
