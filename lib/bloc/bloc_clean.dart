
import 'dart:async';

import 'package:flutter/cupertino.dart';

class BlocClean with ChangeNotifier {
  var progress = 0.0;
  var cleaned = false;

  void clean() {

    // 清理总时长
    var duration = 13.0;

    // 定时器
    Timer.periodic(const Duration(milliseconds: 10), (timer) {

      // 进度更改
      final progress = this.progress + 0.01 / duration;

      // 清理完成
      if (progress >= 1.0) {
        timer.cancel();
        cleaned = true;
        notifyListeners();
      } else {

        // 更新清理进度
        this.progress = progress;
        notifyListeners();
      }
    });
  }
}