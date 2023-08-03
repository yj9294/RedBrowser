import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_browser/bloc/bloc_clean.dart';
import '../bloc/bloc_tab.dart';
import '../page/clean_alert_page.dart';
import '../page/clean_page.dart';
import '../page/privacy_page.dart';
import '../page/setting.page.dart';
import '../page/tab_page.dart';

class RouterUtil {
  static pop(BuildContext context) {
    Navigator.pop(context);
  }

  static goTabPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MultiProvider(
                  providers: [ChangeNotifierProvider(create: (_) => BlocTab())],
                  child: const TabPage(),
                )));
  }

  static goSettingPage(BuildContext context) {
    Navigator.push(context, TransformPageRoute((context) => SettingPage()));
  }

  static goPrivacy(BuildContext context, PageType type) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PrivacyPage(type)));
  }

  static goCleanAlert(BuildContext context) {
    Navigator.push(context, TransformPageRoute((context) => CleanAlertPage()));
  }

  static goCleanPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => BlocClean())],
          child: const CleanPage(),
        ),
      ),
    );
  }
}

class TransformPageRoute extends PageRoute {
  final WidgetBuilder builder;

  TransformPageRoute(this.builder);

  @override
  String? get barrierLabel => null;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement maintainState
  bool get maintainState => true;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Title(
        color: Theme.of(context).primaryColor, child: builder(context));
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => null;
}
