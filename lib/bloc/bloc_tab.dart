

import 'package:flutter/cupertino.dart';
import 'package:red_browser/util/browser_util.dart';

class BlocTab with ChangeNotifier {
  List<BrowserItem> items = BrowserUtil().items;

  tabRefresh(List<BrowserItem> items) {
    this.items = items;
    notifyListeners();
  }
}