import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_browser/bloc/bloc_ad.dart';
import 'package:red_browser/util/event_util.dart';
import 'package:red_browser/util/gad_util.dart';
import 'package:red_browser/util/router_util.dart';
import '../bloc/bloc_loading.dart';
import './util/app_util.dart';
import './util/bloc_util.dart';
import './bloc/bloc_launch.dart';
import './page/home_page.dart';
import './page/launch_page.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

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
    // 监听广告的生命周期
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));

    AppTrackingTransparency.requestTrackingAuthorization();
    // 监听app应用状态
    WidgetsBinding.instance.addObserver(this);
    // 配置
    GADUtil().requestConfig();
  }

  void _onAppStateChanged(AppState state) {
    switch (state) {
      case AppState.foreground:
        debugPrint('[AD] foreground');
      case AppState.background:
        debugPrint("[AD] background");
    }
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
        providers: [ChangeNotifierProvider(create: (_) => BlocLoading()),
          ChangeNotifierProvider(create: (_) => BlocAD())],
        child: const HomePage(),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {

      // 进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:
        debugPrint("active");
        AppUtil().isEnterBackground = false;
        // 当前没得插屏广告时
        if (!AppUtil().isPresentedAD) {
          // 开始动画
          BlocUtil.progressingAnimation(context);
          // 退到根部
          EventBusUtil().enterForeground.fire(true);
        }

        // 应用状态处于闲置状态，并且没有用户的输入事件，
      case AppLifecycleState.inactive:
        debugPrint("inActive");
        AppUtil().isEnterBackground = true;
        if (!AppUtil().isPresentedAD) {
          BlocUtil.launching(context);
        }
        // 当前app即将退出
      case AppLifecycleState.detached:
        debugPrint("detached");

        // 界面隐藏状态
      case AppLifecycleState.hidden:
        debugPrint("hidden");

        // 应用程序hold didEnterBackground
      case AppLifecycleState.paused:
        debugPrint("hold");
        AppUtil().isEnterBackground = true;
    }
  }
}
