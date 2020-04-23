import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/owner.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Item {
  String id;
  String title;
  String description;
  double price;
  List<String> images = [];
  Owner owner;
  GeoFirePoint location;

  Item(
      {this.title,
      this.description,
      this.price,
      this.images,
      this.owner,
      this.location});

  Future<void> addImage(List<Asset> imgAssets) async {
    List<String> imageURLs = await imageService.uploadImages(imgAssets);
    images.addAll(imageURLs);
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    List<dynamic> urls = json['imageURLs'] ?? [];
    List<String> imgs = [];
    for (var url in urls) {
      imgs.add(url);
    }
    GeoPoint pos =
        json['location'] == null ? null : json['location']['geopoint'];
    print("pos: ${pos==null}");
    return Item(
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'].toDouble(),
      images: imgs,
      owner: json['owner'] == null ? null : Owner.fromJson(json['owner']),
      location: pos == null ? null : GeoFirePoint(pos.latitude, pos.longitude),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'title': title ?? '',
      'description': description ?? '',
      'price': price ?? 0.00,
      'imageURLs': images ?? [],
      'location': location == null ? null : location.data,
    };
    if (owner != null) {
      json['owner'] = owner.toJson();
    }
    return json;
  }

  factory Item.fromFireStore(DocumentSnapshot doc) {
    Item item = Item.fromJson(doc.data);
    item.id = doc.documentID;
    return item;
  }

  @override
  String toString() {
    return '{title: $title,description:$description, price:$price, owner:${owner.toString()}';
  }
}
