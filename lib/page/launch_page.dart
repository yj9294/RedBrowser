import 'dart:async';

import 'package:flutter/material.dart';
import '../util/bloc_util.dart';
import '../util/app_util.dart';
import '../component/progress.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});
  @override
  State<StatefulWidget> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  var progress = 0.0;
  var duration = 2.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // 定时器
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {

      // 当前状态在前台的时候才刷新UI 进度
      if (!AppUtil.shared.isEnterbackground) {
        var progress = this.progress + (0.01 / duration);
        if (progress >= 1.0) {
          timer.cancel();
          launched();
          return;
        }
        setState(() {
          this.progress = progress;
        });
      } else {
        setState(() {
          progress = 0.0;
        });
      }
    });
  }

  void launched() {
    BlocUtil.shared.launched(context);
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/launch_bg.png'),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 188, bottom: 156),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/launch_icon.png',
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: ProgressView(progress),
                  )
                ]),
          )),
    );
  }
}
