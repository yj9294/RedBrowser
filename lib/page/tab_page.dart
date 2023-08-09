import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:red_browser/bloc/bloc_ad.dart';
import 'package:red_browser/bloc/bloc_tab.dart';
import 'package:red_browser/config/color.dart';
import 'package:red_browser/model/gad_model.dart';
import 'package:red_browser/model/gad_position.dart';
import 'package:red_browser/util/bloc_util.dart';
import 'package:red_browser/util/browser_util.dart';
import 'package:red_browser/util/event_util.dart';
import 'package:red_browser/util/gad_util.dart';
import 'package:red_browser/util/router_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TabPageState();
  }
}

class TabPageState extends State<TabPage> {

  StreamSubscription? _subscription;
  StreamSubscription? _foregroundSubscription;

  @override
  void dispose() {
    _subscription?.cancel();
    _foregroundSubscription?.cancel();
    debugPrint("$this dispose 🔥🔥🔥🔥");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _refreshAD();
    _adObserver();
  }

  bool isNeedShowNative() {
    return DateTime.now().difference(GADUtil().tabImpressionDate).inSeconds
        > 10;
  }

  void _adObserver() {
    _subscription = EventBusUtil().eventBus.on<GADModel?>().listen((model) {
      GADUtil().show(GADPosition.native);
      if (model is GADNativeModel) {
        if (!isNeedShowNative()) {
          debugPrint("[AD] tab 原生广告10s展示间隔 或 预加载数据.");
          return;
        }
        debugPrint("[AD] 当前显示的tab广告ID${model.ad?.responseInfo?.responseId}");
        GADUtil().tabImpressionDate = DateTime.now();
        BlocUtil.loadNativeAD(context, model);
      }
    });

    _foregroundSubscription = EventBusUtil().enterForeground.on<bool>().listen((event) {
      Navigator.pop(context);
    });
  }

  void _refreshAD() async {
    GADUtil().load(GADPosition.native);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BlocTab>(builder: (context, blocTab, child) {
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              backgroundColor: RColor.WHITE_COLOR,
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: _getCollectionView(blocTab.items)),
                _getNativeADView(),
                _getBottomView(),
              ],
            ),
          ));
    });
  }

  Widget _getNativeADView() {
    return Container(
        alignment: Alignment.center,
        width: 328,
        height: 128,
        child: SizedBox(
            width: 328,
            height: 128,
            child: Consumer<BlocAD>(builder: (context, blocAD, child) {
              return (blocAD.nativeModel != null &&
                  blocAD.nativeModel?.ad != null)
                  ? AdWidget(ad: blocAD.nativeModel!.ad!)
                  : const Center();
            })));
  }

  Widget _getCollectionView(List<BrowserItem> items) {
    return Container(
      color: RColor.WHITE_COLOR,
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // 高度随着内容变化
        // shrinkWrap: true,
        childAspectRatio: 158.0 / 200,
        children: _getData(items),
      ),
    );
  }

  List<Widget> _getData(List<BrowserItem> items) {
    return List<Widget>.from(items.map((e) => _TabRow(e, subscription: _subscription)));
  }

  Widget _getBottomView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CupertinoButton(
            onPressed: newBrowser,
            padding: const EdgeInsets.only(top: 30),
            child: Image.asset('assets/images/tab_add.png')),
        Row(
          children: [
            const Flexible(child: Center()),
            Container(
              padding: const EdgeInsets.only(right: 20),
              child: CupertinoButton(
                  onPressed: goBack,
                  padding: const EdgeInsets.only(top: 30),
                  child: const Text('Back')),
            )
          ],
        )
      ],
    );
  }

  void goBack() {
    _subscription?.cancel();
    GADUtil().disAppear(GADPosition.native);
    BlocUtil.loadNativeAD(context, null);
    RouterUtil.pop(context);
  }

  void newBrowser() {
    BrowserUtil().add();
    goBack();
  }
}

class _TabRow extends StatefulWidget {
  final BrowserItem item;
  StreamSubscription? subscription;

  _TabRow(this.item, {this.subscription});

  @override
  State<StatefulWidget> createState() {
    return _TabRowState(item, subscription: subscription);
  }
}

class _TabRowState extends State<_TabRow> {
  BrowserItem item;
  StreamSubscription? subscription;

  _TabRowState(this.item, {this.subscription});

  var isNavigation = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _getIsNavigation();
    super.initState();
  }

  void _getIsNavigation() async {
    final isNavigation = await item.isNavigation;
    setState(() {
      this.isNavigation = isNavigation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(blurRadius: 10, spreadRadius: 1, color: Colors.black12),
        ], color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            !isNavigation
                ? WebViewWidget(controller: item.controller)
                : const Center(),
            MaterialButton(onPressed: _select, child: const Center()),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Center(),
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: _delete,
                              child: BrowserUtil().items.length > 1
                                  ? Image.asset('assets/images/tab_delete'
                                      '.png')
                                  : const Center()))
                    ])
              ],
            )
          ],
        ));
  }

  void _select() {
    subscription?.cancel();
    BrowserUtil().selected(item);
    GADUtil().disAppear(GADPosition.native);
    BlocUtil.loadNativeAD(context, null);
    RouterUtil.pop(context);
  }

  void _delete() {
    BrowserUtil().delete(item);
    BlocUtil.tabRefresh(context, BrowserUtil().items);
  }
}
