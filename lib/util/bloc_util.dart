import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:red_browser/bloc/bloc_ad.dart';
import 'package:red_browser/bloc/bloc_clean.dart';
import 'package:red_browser/bloc/bloc_loading.dart';
import 'package:red_browser/bloc/bloc_tab.dart';
import 'package:red_browser/model/gad_model.dart';
import '../bloc/bloc_launch.dart';
import '../util/browser_util.dart';

class BlocUtil {
  static final shared = BlocUtil._internal();
  factory BlocUtil() {
    return shared;
  }
  BlocUtil._internal();

  static void progressingAnimation(BuildContext context) {
    Provider.of<BlocLaunch>(context, listen: false).startProgressAnimation();
  }

  static void launching(BuildContext context) {
    Provider.of<BlocLaunch>(context, listen: false).updateLaunched(false);
  }

  void updateLoadingProgress(BuildContext context, double progress) {
    Provider.of<BlocLoading>(context, listen: false).updateProgress(progress);
  }

  void updateLoadingStatus(BuildContext context, bool isLoading) {
    Provider.of<BlocLoading>(context, listen: false).updateIsLoading(isLoading);
  }

  void updateSearchText(BuildContext context, String searchText) {
    Provider.of<BlocLoading>(context, listen: false).updateSearchText(searchText);
  }

  static void updateCanGoBack(BuildContext context, bool canGoBack) {
    Provider.of<BlocLoading>(context, listen: false).updateCanGoBack(canGoBack);
  }

  static void updateCanGoForward(BuildContext context, bool canGoForward) {
    Provider.of<BlocLoading>(context, listen: false).updateCanGoForward(canGoForward);
  }

  static void tabRefresh(BuildContext context, List<BrowserItem> items) {
    Provider.of<BlocTab>(context, listen: false).tabRefresh(items);
  }

  static void clean(BuildContext context) {
    Provider.of<BlocClean>(context, listen: false).clean();
  }

    static void loadNativeAD(BuildContext context, GADNativeModel? model) {
      Provider.of<BlocAD>(context, listen: false).updateNativeAD(model);
    }
}