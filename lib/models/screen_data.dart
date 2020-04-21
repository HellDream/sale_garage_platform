import 'package:flutter/foundation.dart';

class ScreenData extends ChangeNotifier{
  String userId;
  bool receiveMsg = false;
  void updateUserId(String uid){
    userId = uid;
//    notifyListeners();
  }

  void updateReceiveMsg(bool receive){
    receiveMsg = receive;
    notifyListeners();
  }
}