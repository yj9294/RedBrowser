import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  static final _shared = EventBusUtil._internal();
  factory EventBusUtil() {
    return _shared;
  }
  EventBusUtil._internal();

  var eventBus = EventBus();

  var enterForeground = EventBus();
}