import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sale_garage_platform/configs/db_config.dart';
import 'package:sale_garage_platform/models/owner.dart';

class UserService{
  final Firestore _db = Firestore.instance;

  Future<Owner> getUserByUserId(String userId) async{
    if(userId==null) return null;
    var doc = await _db.collection(tUsers).document(userId).get();
    if(doc.data==null) return null;
    return Owner.fromJson(doc.data);
  }

}