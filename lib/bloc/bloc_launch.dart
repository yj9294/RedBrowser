import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:red_browser/util/app_util.dart';

class BlocLaunch extends ChangeNotifier {
  var progress = 0.0;
  var launched = false;

  void updateLaunched(bool launc) {
    launched = launc;
    progress = 0.0;
    notifyListeners();
  }

  void startProgressAnimation() {
    if (!launched) {

      // 重制加载从头开始
      var duration = 3.0;
      progress = 0.0;

      // 定时器
      Timer.periodic(const Duration(milliseconds: 10), (timer) {

        // 进度计算
        final progress = this.progress + 0.01 / duration;

        // 加载中进入后台关闭定时器
        if (AppUtil().isEnterbackground) {
          timer.cancel();
          return;
        }

        // 加载完成
        if (progress >= 1.0) {
          timer.cancel();
          launched = true;
          notifyListeners();
        } else {

          // 进度界面刷新
          this.progress = progress;
          notifyListeners();
        }
      });
    }
  }
}
