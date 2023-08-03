import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/bloc_loading.dart';
import './util/app_util.dart';
import './util/bloc_util.dart';
import './bloc/bloc_launch.dart';
import './page/home_page.dart';
import './page/launch_page.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() {
  runApp(const MyApp());
}

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => BlocLaunch(),
          )
        ],
        child: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AppTrackingTransparency.requestTrackingAuthorization();
    // 监听app应用状态
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return _getMainPage();
  }

  Widget _getMainPage() {
    return Consumer<BlocLaunch>(builder: (context, blocLaunch, child) {
      if (!blocLaunch.launched) {
        return const LaunchPage();
      }
      return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => BlocLoading())],
        child: const HomePage(),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      //进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:
        debugPrint("应用进入前台======");
        AppUtil().isEnterbackground = false;
        BlocUtil.progressingAnimation(context);
        break;
      //应用状态处于闲置状态，并且没有用户的输入事件，
      case AppLifecycleState.inactive:
        debugPrint("应用处于闲置状态，这种状态的应用应该假设他们可能在任何时候暂停 切换到后台会触发======");
        AppUtil().isEnterbackground = true;
        BlocUtil.launching(context);
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        debugPrint("当前页面即将退出======");
        break;
      case AppLifecycleState.hidden:
        debugPrint("应用处于隐藏状态 后台======");
        break;
      // 应用程序处于不可见状态
      case AppLifecycleState.paused:
        debugPrint("应用处于不可见状态 后台======");
        break;
    }
  }
}
