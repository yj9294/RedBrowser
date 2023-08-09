
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:red_browser/model/gad_position.dart';
import 'package:red_browser/util/app_util.dart';
import 'package:red_browser/util/gad_util.dart';

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

      // 加载中进入后台关闭定时器
      if (AppUtil().isEnterBackground) {
        timer.cancel();
        return;
      }

      // 清理完成
      if (progress >= 1.0) {
        timer.cancel();
        GADUtil().show(GADPosition.interstitial, closeHandler: () {
          cleaned = true;
          notifyListeners();
        });
      } else {

        // 更新清理进度
        this.progress = progress;
        notifyListeners();
      }

      if (progress > 0.4 && GADUtil().isLoadedInterstitialAD()) {
        duration = 0.01;
      }

    });

    GADUtil().load(GADPosition.interstitial);
  }
}