
import 'package:admin/services/socket_service.dart';

import 'Model.dart';

class SocketEvent implements Model {
  SocketEvent({
    required this.from,
    required this.to,
    required this.type,
    required this.data,
  });

  final String from;
  final String to;
  final EventType type;
  final Map<String, dynamic> data;

  @override
  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'type': type.name,
      'data': data,
    };
  }

  @override
  factory SocketEvent.fromJson(Map<String, dynamic> json) {
    return SocketEvent(
        from: json['from'],
        to: json['to'],
        type: _toType(json['type']),
        data: json['data'] ?? {});
  }

  static EventType _toType(String type) {
    EventType eventType = EventType.ERROR;

    EventType.values.forEach((element) {
      if (type == element.name) {
        eventType = element;
      }
    });

    return eventType;
  }
}
