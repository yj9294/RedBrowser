
import 'package:flutter/cupertino.dart';

class BlocLoading with ChangeNotifier {
  var isLoading = false;
  var progress = 0.0;
  var canGoBack = false;
  var canGoForward = false;
  var searchText = "";

  updateProgress(double progress) {
    this.progress = progress;
    notifyListeners();
  }

  updateIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  updateSearchText(String searchText) {
    this.searchText = searchText;
    notifyListeners();
  }

  updateCanGoBack(bool canGoBack) {
    this.canGoBack = canGoBack;
    notifyListeners();
  }

  updateCanGoForward(bool canGoForward) {
    this.canGoForward = canGoForward;
    notifyListeners();
  }
}