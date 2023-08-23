import 'package:flutter/material.dart';

class GlobalNotifier with ChangeNotifier{
  bool needClean = false;
  void flagClearCache(){
      needClean = true;
      notifyListeners();
  }
  void clearCacheFinish(){
    needClean = false;
  }
}