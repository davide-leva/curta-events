import 'package:admin/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'Model.dart';

class Device implements Model {
  Device({
    required this.id,
    required this.operator,
    required this.place,
    required this.type,
    required this.icon,
    this.isCaller = false,
    this.isAnswerer = false,
  });

  final String id;
  final String operator;
  final String place;
  final String type;
  final IconData icon;

  bool isCaller;
  bool isAnswerer;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operator': operator,
      'place': place,
      'type': type,
      'icon': icon.codePoint
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      operator: json['operator'],
      place: json['place'],
      type: json['type'],
      icon: _iconDecode(json['icon']),
    );
  }

  void call() {
    SocketService.call(id);
  }

  void answer() {
    SocketService.answer(id);
  }

  static IconData _iconDecode(int x) {
    switch (x) {
      case 58531:
        return Icons.phone_android;
      case 58215:
        return Icons.laptop;
      case 57795:
        return Icons.desktop_windows;
      case 59086:
        return Icons.watch;
      default:
        return Icons.error;
    }
  }
}
