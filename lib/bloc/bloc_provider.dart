import 'bloc_base.dart';
import 'package:flutter/widgets.dart';

Type _typeOf<T>() => T;

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  const BlocProvider({
    Key? key,
    required this.child,
    required this.blocs,
  }) : super(key: key);
  final Widget child;
  final List<T> blocs;

  @override
  State<StatefulWidget> createState() => _BlocProviderState<T>();

  // 重写of方法
  static List<T> of <T extends BlocBase>(BuildContext context) {
    var provider = context.findAncestorWidgetOfExactType<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> widget = provider as _BlocProviderInherited<T>;
    return widget.blocs;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>>{

  @override
  void dispose() {
    widget.blocs.map((bloc) {
      bloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited(child: widget.child, blocs: widget.blocs);
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key? key,
    required Widget child,
    required this.blocs,
  }) : super(key: key, child: child);
  final List<T> blocs;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}