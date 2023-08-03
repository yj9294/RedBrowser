import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_browser/bloc/bloc_tab.dart';
import 'package:red_browser/config/color.dart';
import 'package:red_browser/util/bloc_util.dart';
import 'package:red_browser/util/browser_util.dart';
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                _getBottomView(),
              ],
            ),
          ));
    });
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
    return List<Widget>.from(items.map((e) => _TabRow(e)));
  }

  Widget _getBottomView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CupertinoButton(
            onPressed: newBrowser,
            padding: EdgeInsets.zero,
            child: Image.asset('assets/images/tab_add.png')),
        Row(
          children: [
            const Flexible(child: Center()),
            Container(
              padding: const EdgeInsets.only(right: 20),
              child: CupertinoButton(
                  onPressed: goBack,
                  padding: EdgeInsets.zero,
                  child: const Text('Back')),
            )
          ],
        )
      ],
    );
  }

  void goBack() {
    RouterUtil.pop(context);
  }

  void newBrowser() {
    BrowserUtil().add();
    RouterUtil.pop(context);
  }
}

class _TabRow extends StatefulWidget {
  final BrowserItem item;

  const _TabRow(this.item);

  @override
  State<StatefulWidget> createState() {
    return _TabRowState(item);
  }
}

class _TabRowState extends State<_TabRow> {
  BrowserItem item;

  _TabRowState(this.item);

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
    BrowserUtil().selected(item);
    RouterUtil.pop(context);
  }

  void _delete() {
    BrowserUtil().delete(item);
    BlocUtil.tabRefresh(context, BrowserUtil().items);
  }
}
