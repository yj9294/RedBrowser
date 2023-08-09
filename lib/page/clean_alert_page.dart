import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:red_browser/config/color.dart';
import 'package:red_browser/util/event_util.dart';
import 'package:red_browser/util/router_util.dart';


typedef CleanConfirmHandle = void Function();

class CleanAlertPage extends StatefulWidget {
  CleanConfirmHandle confirm;

  CleanAlertPage(this.confirm);

  @override
  State<StatefulWidget> createState() {
    return _CleanAlertPageState(confirm);
  }
}

class _CleanAlertPageState extends State<CleanAlertPage> {

  StreamSubscription? _subscription;

  CleanConfirmHandle confirm;

  _CleanAlertPageState(this.confirm);

  @override
  void initState() {
    super.initState();
    // 监听app应用进入前台
    _subscription = EventBusUtil().enterForeground.on<bool>().listen((event) {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    debugPrint("$this dispose 🔥🔥🔥🔥");
    super.dispose();
  }

  void goBack() {
    Navigator.pop(context);
  }

  void goClean() {
    Navigator.pop(context);
    confirm();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
        type: MaterialType.transparency,
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: AppBar(
                  backgroundColor: const Color.fromARGB(0x66, 0, 0, 0),
                )),
            backgroundColor: const Color.fromARGB(0x66, 0, 0, 0),
            body: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Stack(alignment: Alignment.center, children: [
                Center(
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: _getContentView(),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 200),
                  child: Image.asset('assets/images/clean_icon.png')
                )
              ]),
            )));
  }

  Widget _getContentView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text("Close Tabs and Clear Data"),
        Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: goClean,
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, top: 15, bottom: 15),
                      decoration: BoxDecoration(
                          color: RColor.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(24)),
                      child: const Text("Confirm",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: goBack,
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 44, right: 44, top: 15, bottom: 15),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 230, 229, 1),
                          borderRadius: BorderRadius.circular(24)),
                      child: const Text("Cancel",
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54))),
                )
              ],
            ))
      ],
    );
  }
}
