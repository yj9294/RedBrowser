
import 'dart:async';

import 'bloc_base.dart';

class BlockLaunch extends BlocBase {

  final _controller = StreamController<bool>();
  get _counter => _controller.sink;
  get counter => _controller.stream;

  void launched(bool isLaunched) {
    _counter.add(isLaunched);
  }

  @override
  void dispose() {
    _controller.close();
  }
}