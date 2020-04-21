import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sale_garage_platform/models/item.dart';
import 'package:sale_garage_platform/screens/item_detail_screen.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final bool dismiss;

  const ItemCard({Key key, this.item, this.dismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ItemDetailScreen(item: item)),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: (item.images == null || item.images.length == 0)
                    ? Image.asset('images/garage-sale.jpg')
                    : CachedNetworkImage(
                        imageUrl: item.images.first,
                        progressIndicatorBuilder: (context, string, event) =>
                            Center(child: CircularProgressIndicator()),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title.length < 15
                          ? item.title
                          : '${item.title.substring(0, 14)}...',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      formatter.format(item.price),
                      style: theme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
