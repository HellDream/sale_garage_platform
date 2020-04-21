import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sale_garage_platform/configs/db_config.dart';
import 'package:sale_garage_platform/configs/db_config.dart';
import 'package:sale_garage_platform/configs/db_config.dart';
import 'package:sale_garage_platform/configs/db_config.dart';
import 'package:sale_garage_platform/configs/db_config.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/item.dart';
import 'package:sale_garage_platform/models/owner.dart';

class PostService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Future<void> createPost(Item item) async {
    FirebaseUser currentUser = await _auth.currentUser();
    if (currentUser == null) return;
    item.owner = Owner.fromJson(authService.profileData);
    Map<String, dynamic> json = item.toJson();
    DocumentReference ref = await _db.collection(tItems).add(json);
    item.id = ref.documentID;
    addItemToUser(ref, authService.profileData['uid']);
  }

  void deletePost(String id) async {
    DocumentReference doc = _db.collection(tItems).document(id);
    await removeItemFromUser(doc);
    await doc.delete();
    print('$id deleted!');
  }

  Stream<List<Item>> streamOfItems() {
    var ref = _db.collection(tItems);
    return ref
        .getDocuments(source: Source.serverAndCache)
        .asStream()
        .map((list) => list.documents.map((doc) {
              return Item.fromFireStore(doc);
            }).toList());
  }

  Future<Item> getItemByDocumentId(String id) async {
    var doc = await _db.collection(tItems).document(id).get();
    return Item.fromFireStore(doc);
  }

  void getItemById(String id, List<Item> items) async{
      Item item = await getItemByDocumentId(id);
      items.add(item);
  }

  Stream<List<Item>> streamOfItemsByUserId(String userId) {
    Stream<List<Item>> stream = _db
        .collection(tUserItems)
        .document(userId)
        .snapshots()
        .asyncMap((snap) async {
      var items = <Item>[];
      if (snap.data == null) return items;
      var itemList = snap.data['items'];
      for (var itemRef in itemList) {
        var doc = await itemRef.get();
        if (doc.data != null) items.add(Item.fromFireStore(doc));
      }
      return items;
    });
    return stream;
  }

  void addItemToUser(DocumentReference ref, String userId) async {
    DocumentSnapshot userItemRef =
        await _db.collection(tUserItems).document(userId).get();
    List<dynamic> refs = [ref];
    Map<String, dynamic> mapData = {'items': refs};
    if (userItemRef.data != null && userItemRef.data['items'] != null) {
      var itemRefs = userItemRef.data['items'];
      itemRefs.add(ref);
      mapData['items'] = itemRefs;
    }
    await userItemRef.reference.setData(mapData);
//    await _db.collection(tUserItems).document(userId).setData(mapData);
  }

  Future<void> removeItemFromUser(DocumentReference doc) async {
    String userId = authService.profileData['uid'];
    var userItemRef = await _db.collection(tUserItems).document(userId).get();
    if (userItemRef.data != null) {
      List<dynamic> itemRefs = userItemRef.data['items'];
      print(itemRefs.length);
      var itemToRemove;
      for (var itemRef in itemRefs) {
        if (itemRef.documentID == doc.documentID) {
          itemToRemove = itemRef;
          break;
        }
      }
      if (itemToRemove != null) {
        itemRefs.remove(itemToRemove);
        _db
            .collection(tUserItems)
            .document(userId)
            .updateData({'items': itemRefs});
      }
    }
  }
}
