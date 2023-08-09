import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_browser/bloc/bloc_clean.dart';
import 'package:red_browser/util/bloc_util.dart';
import 'package:red_browser/util/browser_util.dart';
import 'package:red_browser/util/event_util.dart';
import 'package:red_browser/util/gad_util.dart';

class CleanPage extends StatefulWidget {
  const CleanPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CleanPage();
  }
}

class _CleanPage extends State<CleanPage> {
  StreamSubscription? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // 监听应用进入前台
    _subscription = EventBusUtil().enterForeground.on<bool>().listen((event) {
      Navigator.pop(context);
    });

    // 开启动画
    BlocUtil.clean(context);

    // 监听改变
    var blocClean = Provider.of<BlocClean>(context, listen: false);
    blocClean.addListener(() {
      if (blocClean.cleaned) {
        BrowserUtil().clean();
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 230, 229, 1)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/clean_title.png'),
            Container(
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Consumer<BlocClean>(
                  builder: (context, blocClean, child) {
                    return Text(
                        'Cleaning...${(blocClean.progress * 100).truncate()}');
                  },
                ))
          ],
        ),
      ),
    );
  }
}
