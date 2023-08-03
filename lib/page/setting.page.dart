import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'home_page.dart';
import '../page/privacy_page.dart';
import '../util/app_util.dart';
import '../util/browser_util.dart';
import '../util/router_util.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() {
    Navigator.pop(context);
  }

  void newBrowser() {
    BrowserUtil().add();
    RouterUtil.pop(context);
  }

  void share() {
    Navigator.pop(context);
    BrowserUtil().item.url.then((value) {
      if (value.isEmpty) {
        Share.share("https://itunes.apple.com/cn/app/id${AppUtil().appID}");
      } else {
        Share.share(value);
      }
    });
  }

  void copy() {
    Navigator.pop(context);
    BrowserUtil().item.url.then((value) {
      Clipboard.setData(ClipboardData(text: value));
    });
  }

  void rate() {
    Navigator.pop(context);
    LaunchReview.launch(iOSAppId: '${AppUtil().appID}');
  }

  void terms() {
    Navigator.pop(context);
    RouterUtil.goPrivacy(context, PageType.privacy);
  }

  void privacy() {
    Navigator.pop(context);
    RouterUtil.goPrivacy(context, PageType.terms);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              backgroundColor: Colors.transparent,
            )),
        backgroundColor: const Color.fromARGB(0x66, 0, 0, 0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: GestureDetector(
                    onTap: goBack,
                    child: Container(
                      color: Colors.transparent,
                    ))),
            _getContentView()
          ],
        ),
      ),
    );
  }

  Widget _getContentView() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [_getImageView(), _getTextVIew()],
        ),
      ),
    );
  }

  Widget _getImageView() {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CupertinoButton(
              onPressed: newBrowser, child: _getImageViewCell(SettingItem.add)),
          CupertinoButton(
              onPressed: share, child: _getImageViewCell(SettingItem.share)),
          CupertinoButton(
              onPressed: copy, child: _getImageViewCell(SettingItem.copy)),
        ],
      ),
    );
  }

  Widget _getImageViewCell(SettingItem item) {
    return Column(
      children: [
        Image.asset('assets/images/${item.image}.png'),
        Container(
            padding: const EdgeInsets.only(top: 5),
            child: Text(item.title, style: const TextStyle(fontSize: 14)))
      ],
    );
  }

  Widget _getTextVIew() {
    return SafeArea(
        child: Container(
      child: Column(
        children: [
          CupertinoButton(
              onPressed: rate, child: _getTextViewCell(SettingItem.rate)),
          CupertinoButton(
              onPressed: terms, child: _getTextViewCell(SettingItem.terms)),
          CupertinoButton(
              onPressed: privacy, child: _getTextViewCell(SettingItem.privacy)),
        ],
      ),
    ));
  }

  Widget _getTextViewCell(SettingItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.title, style: const TextStyle(fontSize: 16)),
          Image.asset("assets/images/arrow.png")
        ],
      ),
    );
  }
}

enum SettingItem { add, share, copy, rate, terms, privacy }

extension SettingExtension on SettingItem {
  String describeEnum(Object enumEntry) {
    final String description = enumEntry.toString();
    final int indexOfDot = description.indexOf('.');
    assert(indexOfDot != -1 && indexOfDot < description.length - 1);
    return description.substring(indexOfDot + 1);
  }

  String get title {
    switch (describeEnum(this)) {
      case 'rate':
        return "Rate Us";
      case 'terms':
        return "Terms of Users";
      case 'privacy':
        return "Privacy Policy";
      case 'add':
        return "New";
      default:
        return describeEnum(this).capitalize();
    }
  }

  String get image {
    switch (describeEnum(this)) {
      case 'add':
        return "new";
      default:
        return describeEnum(this);
    }
  }
}
