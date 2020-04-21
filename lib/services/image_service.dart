import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> uploadImages(List<Asset> assets) async {
    FirebaseUser user = await _auth.currentUser();
    List<String> uploadUrls = [];
    await Future.wait(
        assets.map((Asset asset) async {
          ByteData byteData = await asset.getByteData(quality: 80);
          List<int> imageData = byteData.buffer.asUint8List();

          StorageReference reference = storage
              .ref().child("jialiu_zhenyu_app")
              .child(user.email)
              .child(DateTime.now().toIso8601String());
          StorageUploadTask uploadTask = reference.putData(imageData);
          StorageTaskSnapshot storageTaskSnapshot;

          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          if (snapshot.error == null) {
            storageTaskSnapshot = snapshot;
            String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
            uploadUrls.add(downloadUrl);
            print('downloadUrl: $downloadUrl');
          } else {
            print('Error from image repo ${snapshot.error.toString()}');
            throw ('This file is not an image');
          }
        }),
        eagerError: true,
        cleanUp: (_) {
          print('eager cleaned up');
        });
    return uploadUrls;
  }

  Future<List<String>> uploadChatImages(
      List<Asset> assets, String chatRoomId) async {
    List<String> uploadUrls = [];
    await Future.wait(
        assets.map((Asset asset) async {
          ByteData byteData = await asset.getByteData(quality: 80);
          List<int> imageData = byteData.buffer.asUint8List();

          StorageReference reference = storage
              .ref().child("jialiu_zhenyu_app")
              .child('chats')
              .child(chatRoomId)
              .child(DateTime.now().toIso8601String());
          StorageUploadTask uploadTask = reference.putData(imageData);
          StorageTaskSnapshot storageTaskSnapshot;

          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          if (snapshot.error == null) {
            storageTaskSnapshot = snapshot;
            String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
            uploadUrls.add(downloadUrl);
            print('downloadUrl: $downloadUrl');
          } else {
            print('Error from image repo ${snapshot.error.toString()}');
            throw ('This file is not an image');
          }
        }),
        eagerError: true,
        cleanUp: (_) {
          print('eager cleaned up');
        });
    return uploadUrls;
  }
}
