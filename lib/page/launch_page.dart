import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_browser/bloc/bloc_launch.dart';
import 'package:red_browser/util/app_util.dart';
import 'package:red_browser/util/bloc_util.dart';
import '../component/progress.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});
  @override
  State<StatefulWidget> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  void initState() {
    super.initState();

    // 进入后台时候不进行加载
    if (!AppUtil().isEnterBackground) {
      BlocUtil.progressingAnimation(context);
    }
  }

  @override
  void dispose() {
    debugPrint("$this dispose 🔥🔥🔥🔥");
    super.dispose();
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
                      child: Consumer<BlocLaunch>(
                        builder: (context, blocLaunch, child) {
                          return ProgressView(blocLaunch.progress);
                        },
                      ))
                ]),
          )),
    );
  }
}
