import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:red_browser/bloc/bloc_ad.dart';
import 'package:red_browser/model/gad_model.dart';
import 'package:red_browser/model/gad_position.dart';
import 'package:red_browser/util/event_util.dart';
import 'package:red_browser/util/gad_util.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../util/app_util.dart';
import '../bloc/bloc_loading.dart';
import '../util/bloc_util.dart';
import '../util/router_util.dart';
import '../util/browser_util.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with RouteAware {
  String textValue = "";
  WebViewController? webViewController;
  TextEditingController? editingController;
  var isNavigation = true;
  var tabCount = "";
  StreamSubscription? _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    editingController = null;
    webViewController = null;
    routeObserver.unsubscribe(this);
    _subscription?.cancel();
    debugPrint("$this dispose 🔥🔥🔥🔥");
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    debugPrint("home出现");
    BrowserUtil().item.url.then((value) {
      BlocUtil.shared.updateSearchText(context, value);
    });
    _getState();
    _refreshAD();
  }

  @override
  void didPush() {
    super.didPush();
    debugPrint("home出现");
    BrowserUtil().item.url.then((value) {
      BlocUtil.shared.updateSearchText(context, value);
    });
    _getState();
    _refreshAD();
  }

  @override
  void didPop() {
    super.didPop();
    debugPrint("home消失");
  }

  @override
  void didPushNext() {
    super.didPushNext();
    debugPrint("home消失");
    _dismissAD();
  }

  @override
  void initState() {
    super.initState();
    editingController = TextEditingController();
    _adEvent();
    _refreshAD();
    _getState();
  }

  // 前进后退
  void _refreshWebState() {
    webViewController?.canGoBack().then((canGoBack) {
      return BlocUtil.updateCanGoBack(context, canGoBack);
    });
    webViewController?.canGoForward().then((canGoForward) {
      return BlocUtil.updateCanGoForward(context, canGoForward);
    });
  }

  bool isNeedShowNative() {
     return DateTime.now().difference(GADUtil().homeImpressionDate).inSeconds
         > 10;
  }

  void _refreshAD() async {
    _adEvent();
    GADUtil().load(GADPosition.native);
  }

  void _adEvent() {
    _subscription?.cancel();
    _subscription = EventBusUtil().eventBus.on<GADModel?>().listen((model) {
      GADUtil().show(GADPosition.native);
      if (model is GADNativeModel) {
        if (!isNeedShowNative()) {
          debugPrint("[AD] home 原生广告10s展示间隔 或 预加载的数据");
          return;
        }
        debugPrint("[AD] 当前显示的home广告ID${model.ad?.responseInfo?.responseId}");
        GADUtil().homeImpressionDate = DateTime.now();
        BlocUtil.loadNativeAD(context, model);
      }
    });
    _subscription?.resume();
  }

  void _dismissAD() {
    _subscription?.cancel();
    GADUtil().disAppear(GADPosition.native);
    BlocUtil.loadNativeAD(context, null);
  }

  void _getState() async {
    webViewController = BrowserUtil.shared.item.controller;

    // web view的监听
    webViewController
        ?.setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
      BlocUtil.shared.updateLoadingStatus(context, true);
      BlocUtil.shared.updateSearchText(context, url);
    }, onPageFinished: (url) {
      BlocUtil.shared.updateLoadingStatus(context, false);
    }, onProgress: (progress) {
      _refreshWebState();
      BlocUtil.shared.updateLoadingProgress(context, progress / 100);
      if (progress == 100) {
        BlocUtil.shared.updateLoadingStatus(context, false);
      }
    }, onUrlChange: (url) {
      BlocUtil.shared.updateSearchText(context, url.url ?? "");
    }));

    final isNavigation = await BrowserUtil().item.isNavigation;
    final count = BrowserUtil().items.length;
    final url = await BrowserUtil().item.url;
    if (mounted) {
      setState(() {
        editingController?.text = url;
        this.isNavigation = isNavigation;
        tabCount = "$count";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/home_bg.png'))),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                _searchBox(),
                _ProgressView(),
                Flexible(child: _contentView()),
                _bottomView(),
              ],
            ),
          ),
        )
      ],
    );
  }

  // 搜索框
  Widget _searchBox() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        height: 50,
        padding: const EdgeInsets.all(16),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(child:
              Consumer<BlocLoading>(builder: (context, blocLoading, child) {
            editingController?.text = blocLoading.searchText;
            return TextField(
              minLines: 1,
              style: const TextStyle(fontSize: 14.0),
              controller: editingController,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Search or enter an address'),
              onSubmitted: (text) {
                BlocUtil().updateSearchText(context, text);
              },
            );
          })),
          Consumer<BlocLoading>(builder: (context, blocLoading, child) {
            return Container(
              margin: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                  onTap: () {
                    _search(blocLoading.isLoading);
                  },
                  child: Image.asset(blocLoading.isLoading
                      ? 'assets/images/search_1.png'
                      : 'assets/images/search.png')),
            );
          }),
        ]),
      ),
    );
  }

  // 浏览器界面
  Widget _contentView() {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          child: Container(
            color: Colors.white,
            child: _contentChild(),
          )),
    );
  }

  // 内容界面
  Widget _contentChild() {
    if (!isNavigation) {
      return WebViewWidget(controller: webViewController!);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Image.asset(
            'assets/images/home_icon.png',
          ),
        ),
        GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 4,
          padding: EdgeInsets.zero,
          crossAxisSpacing: 0,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          childAspectRatio: 90.0 / 72.0,
          children: _getData(),
        ),
        Container(
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
                })))
      ],
    );
  }

  // 图标
  List<Widget> _getData() {
    return List<Widget>.from(HomeItemType.values.map((e) => _getRow(e)));
  }

  // 图标Item
  Widget _getRow(HomeItemType item) {
    return MaterialButton(
        onPressed: () {
          _searchNavigation(item);
        },
        child: Column(
          children: [
            Image.asset(item.displayImage),
            Container(
              padding: const EdgeInsets.only(top: 9),
              child: Text(
                item.displayTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            )
          ],
        ));
  }

  // 底部视图
  Widget _bottomView() {
    return Container(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Consumer<BlocLoading>(builder: (context, blocLoading, child) {
            return CupertinoButton(
                onPressed: blocLoading.canGoBack ? _goBack : null,
                child: Image.asset(blocLoading.canGoBack
                    ? 'assets/images/left.png'
                    : 'assets/images/left_1.png'));
          }),
          Consumer<BlocLoading>(builder: (context, blocLoading, child) {
            return CupertinoButton(
                onPressed: blocLoading.canGoForward ? _goForward : null,
                child: Image.asset(blocLoading.canGoForward
                    ? 'assets/images/right.png'
                    : 'assets/images/right_1.png'));
          }),
          CupertinoButton(
              onPressed: _goCleanAlert,
              child: Image.asset('assets/images/clean.png')),
          CupertinoButton(
            onPressed: _goTab,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset('assets/images/tab.png'),
                Text(
                  tabCount,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
          CupertinoButton(
              onPressed: _goSetting,
              child: Image.asset('assets/images/setting.png')),
        ],
      ),
    );
  }

  void _search(bool isLoading) {
    if (!isLoading) {
      if (editingController?.text.isNotEmpty == true) {
        BlocUtil().updateLoadingStatus(context, !isLoading);
        BrowserUtil.shared.item.loadUrl(editingController!.text);
        if (mounted) {
          setState(() {
            isNavigation = false;
          });
        }
      } else {
        AppUtil.alert(context, "Please enter your search content.");
      }
    } else {
      BrowserUtil.shared.item.stopLoad();
      if (mounted) {
        setState(() {
          editingController?.text = "";
        });
      }
    }
  }

  void _searchNavigation(HomeItemType item) {
    BlocUtil.shared.updateLoadingStatus(context, true);
    BlocUtil.shared.updateSearchText(context, item.url);
    editingController?.text = item.url;
    _search(false);
  }

  void _goBack() {
    webViewController?.goBack();
  }

  void _goForward() {
    webViewController?.goForward();
  }

  void _goCleanAlert() {
    RouterUtil.goCleanAlert(context, () {
      RouterUtil.goCleanPage(context);
    });
  }

  void _goTab() {
    _dismissAD();
    RouterUtil.goTabPage(context);
  }

  void _goSetting() {
    RouterUtil.goSettingPage(context);
  }
}

class _ProgressView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProgressViewState();
  }
}

class _ProgressViewState extends State<_ProgressView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Consumer<BlocLoading>(
          builder: (context, blocLoading, child) {
            return LinearProgressIndicator(
              value: blocLoading.progress,
              color: blocLoading.isLoading ? Colors.white : Colors.transparent,
              backgroundColor:
                  blocLoading.isLoading ? Colors.white60 : Colors.transparent,
            );
          },
        ));
  }
}

enum HomeItemType {
  facebook,
  google,
  instagram,
  youtube,
  amazon,
  gmail,
  yahoo,
  twitter
}

extension HomeItemTypeExtension on HomeItemType {
  String get name => describeEnum(this);

  String get url {
    return 'https://www.${describeEnum(this)}.com';
  }

  String get displayTitle {
    return describeEnum(this).capitalize();
  }

  String get displayImage {
    return 'assets/images/${describeEnum(this)}.png';
  }

  String describeEnum(Object enumEntry) {
    final String description = enumEntry.toString();
    final int indexOfDot = description.indexOf('.');
    assert(indexOfDot != -1 && indexOfDot < description.length - 1);
    return description.substring(indexOfDot + 1);
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
