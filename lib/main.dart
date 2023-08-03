import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/bloc_loading.dart';
import './util/app_util.dart';
import './util/bloc_util.dart';
import './bloc/block_launch.dart';
import './bloc/bloc_provider.dart';
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
      home: BlocProvider(blocs: [BlockLaunch()], child: MainPage()),
      navigatorObservers: [routeObserver],
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  var isLaunched = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AppTrackingTransparency.requestTrackingAuthorization();
    // 监听是否进入主页状态
    BlocUtil.shared.launchStateUpdate(context, (isLaunched) {
      setState(() {
        this.isLaunched = isLaunched;
      });
    });

    // 监听app应用状态
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return _getMainPage();
  }

  Widget _getMainPage() {
    if (!isLaunched) {
      return const LaunchPage();
    }
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BlocLoading())],
      child: const HomePage(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      //进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:
        AppUtil.shared.isEnterbackground = false;
        print("应用进入前台======");
        break;
      //应用状态处于闲置状态，并且没有用户的输入事件，
      case AppLifecycleState.inactive:
        print("应用处于闲置状态，这种状态的应用应该假设他们可能在任何时候暂停 切换到后台会触发======");
        BlocUtil.shared.launching(context);
        AppUtil.shared.isEnterbackground = true;
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        print("当前页面即将退出======");
        break;
      case AppLifecycleState.hidden:
        print("应用处于隐藏状态 后台======");
        break;
      // 应用程序处于不可见状态
      case AppLifecycleState.paused:
        print("应用处于不可见状态 后台======");
        break;
    }
  }
}
