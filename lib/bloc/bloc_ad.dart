import 'package:flutter/material.dart';
import 'package:red_browser/model/gad_model.dart';

class BlocAD extends ChangeNotifier {
  GADNativeModel? nativeModel;

  void updateNativeAD(GADNativeModel? model) {
    nativeModel = model;
    notifyListeners();
  }
}