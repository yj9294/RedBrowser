
import 'dart:async';

import 'package:flutter/cupertino.dart';

class BlocClean with ChangeNotifier {
  var progress = 0.0;
  var cleaned = false;

  void clean() {
    var duration = 3.0;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      final progress = this.progress + 0.01 / duration;
      if (progress >= 1.0) {
        timer.cancel();
        cleaned = true;
        notifyListeners();
      } else {
        this.progress = progress;
        notifyListeners();
      }
    });
  }
}