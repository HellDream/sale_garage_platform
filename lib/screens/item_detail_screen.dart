import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sale_garage_platform/components/back_button.dart';
import 'package:sale_garage_platform/components/circle_avatar.dart';
import 'package:sale_garage_platform/components/image_page_view.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/constants/widget_constants.dart';
import 'package:sale_garage_platform/models/item.dart';
import 'package:sale_garage_platform/models/owner.dart';
import 'package:sale_garage_platform/screens/chat_screen.dart';
import 'package:sale_garage_platform/screens/item_map_screen.dart';
import 'package:sale_garage_platform/screens/owner_posts_Screen.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CachedNetworkImageProvider> images = List.generate(item.images.length,
        (index) => CachedNetworkImageProvider(item.images[index]));
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _buildImageSection(images),
            _buildTitleSection(),
            _buildPriceSection(context),
            _buildOwnerInfo(context),
            Divider(
              thickness: 10,
              color: Colors.grey.shade200,
            ),
            _buildTextSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(List<CachedNetworkImageProvider> images) {
    if (images.length == 0) {
      return _buildDefaultImage();
    }
    return _buildNonDefaultImage(images);
  }

  Widget _buildNonDefaultImage(List<CachedNetworkImageProvider> images) {
    return Container(
      constraints: imageBoxConstraint,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ImagePageView(
            images: images,
          ),
          TopBackBtn(),
        ],
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      constraints: imageBoxConstraint,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Image.asset(
              'images/garage-sale.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
          ),
          TopBackBtn(),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          item.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildOwnerInfo(BuildContext context) {
    Owner owner = item.owner;
    if (owner == null) {
      return SizedBox();
    }
    return ListTile(
      leading: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => OwnerPostScreen(
                owner: owner,
              ),
            ),
          );
        },
        child: UserCircleAvatar(
          imageURL: owner.photoURL,
          size: 50.0,
        ),
      ),
      title: Text(owner.displayName),
      subtitle: Text('contact: ${owner.email}'),
      trailing: owner.uid != authService.profileData['uid']
          ? IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      owner: owner,
                    ),
                    settings: RouteSettings(arguments: item),
                  ),
                );
              },
              icon: Icon(
                Icons.chat,
                color: Colors.grey.shade700,
              ),
            )
          : null,
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 15, 32, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text(
              formatter.format(item.price),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: Colors.red,
              ),
            ),
          ),
          _getLocationIcon(context),
        ],
      ),
    );
  }

  Widget _buildTextSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        item.description,
        softWrap: true,
      ),
    );
  }

  Widget _getLocationIcon(BuildContext context) {
    return item.location == null
        ? SizedBox()
        : InkWell(
            child: Icon(
              Icons.location_on,
              color: Colors.grey.shade700,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ItemMapScreen(
                    geoPoint: item.location,
                  ),
                ),
              );
            },
          );
  }
}
