import 'package:webview_flutter/webview_flutter.dart';

class BrowserUtil {
  static final shared = BrowserUtil._internal();
  factory BrowserUtil() {
    return shared;
  }
  BrowserUtil._internal();

  List<BrowserItem> items = [BrowserItem.navigation()];

  BrowserItem get item {
    return List<BrowserItem>.from(items.where((element) =>  element.isSelect)
    ).first;
  }

  void add() {
    items.insert(0, BrowserItem.navigation());
  }

  void delete(BrowserItem item) {
    if (item.isSelect) {
      items = List<BrowserItem>.from(items.where((element) => element != item));
      items.first.isSelect = true;
    }
  }

  void clean() {
    items = [BrowserItem.navigation()];
  }

  void selected(BrowserItem item) {
    for (var ele in items) {
      ele.isSelect = false;
    }
    item.isSelect = true;
  }

}

class BrowserItem {

  WebViewController controller;
  var isSelect = true;

  Future<bool> get isNavigation async {
    String? url = await controller.currentUrl();
    return url == null || url.isEmpty == true;
  }

  Future<String> get url async {
    String? url = await controller.currentUrl();
    return url ?? "";
  }

  BrowserItem(this.controller);

  BrowserItem.navigation() : controller = WebViewController();

  // 加载url
  void loadUrl(String url) {
    if (url.isUrl()) {
      var uri = Uri.parse(url);
      controller.loadRequest(uri);
    } else {
      url = 'https://www.google.com/search?q=$url';
      loadUrl(url);
    }
  }

  void stopLoad() {
    controller.runJavaScript('window.stop();');
  }
}

extension StringExtension on String {
  bool isUrl() {
    RegExp exp = RegExp('[a-zA-z]+://.*');
    return exp.hasMatch(this);
  }
}