import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sale_garage_platform/configs/db_config.dart';
import 'package:sale_garage_platform/constants/constant.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  Stream<FirebaseUser> user;
  Map<String, dynamic> profileData;

  AuthService() {
    user = _auth.onAuthStateChanged;
  }

  Future<FirebaseUser> googleSignIn() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);

    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    await updateUserData(user);
    return user;
  }

  Future<void> updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection(tUsers).document(user.uid);
    String token = await messagingService.getToken();
    profileData = {
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
      'platform': Platform.operatingSystem,
      'token': token,
    };
    await ref.setData(profileData, merge: true);
  }

  void signOut() async {
    _auth.signOut();
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
  }
}
