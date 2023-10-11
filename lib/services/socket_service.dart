import 'dart:async';
import 'dart:convert';

import 'package:admin/models/Event.dart';
import 'package:admin/services/sync_service.dart';
import 'package:admin/services/updater.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../controllers/Config.dart';
import '../models/Device.dart';

enum EventType {
  HANDSHAKE,
  REGISTRATION,
  AUTH,
  AUTH_DONE,
  UPDATE,
  SETTING,
  CALL,
  ANSWER,
  ERROR,
}

class SocketService {
  static final Map<EventType, List<StreamSubscription>> _subscriptions = {};
  static final StreamController _inputChannel = StreamController.broadcast();
  static late WebSocketChannel wss;

  static void send(SocketEvent event) {
    wss.sink.add(jsonEncode(event.toJson()));
  }

  static void init() {
    wss = WebSocketChannel.connect(Uri.parse(Config.get('socketEndpoint')));
    wss.ready.then((value) {
      SyncService.cloudState.value = CloudState.online;

      send(SocketEvent(
          from: Config.get('deviceID'),
          to: 'server',
          type: EventType.HANDSHAKE,
          data: {}));
    });

    wss.stream.listen((event) {
      _inputChannel.add(event);
    }, onDone: () {
      SyncService.cloudState.value = CloudState.offline;
      5.seconds.delay(() => init());
    }, cancelOnError: true);
  }

  static void register(String operator, String place) {
    send(
      SocketEvent(
        from: Config.get('deviceID'),
        to: 'server',
        type: EventType.REGISTRATION,
        data: {
          'operator': operator,
          'place': place,
        },
      ),
    );
  }

  static void auth(String regis, Device device) {
    send(
      SocketEvent(
        from: Config.get('deviceID'),
        to: 'server',
        type: EventType.AUTH,
        data: {
          'regis': regis,
          'device': device.toJson(),
        },
      ),
    );
  }

  static void call(String who) {
    send(
      SocketEvent(
        from: Config.get('deviceID'),
        to: who,
        type: EventType.CALL,
        data: {},
      ),
    );
  }

  static void answer(String who) {
    send(
      SocketEvent(
        from: Config.get('deviceID'),
        to: who,
        type: EventType.ANSWER,
        data: {},
      ),
    );
  }

  static void update(Collection collection) {
    send(
      SocketEvent(
        from: Config.get('deviceID'),
        to: 'all',
        type: EventType.UPDATE,
        data: {
          'collection': collection.name,
        },
      ),
    );
  }

  static void setListener(EventType type, void Function(SocketEvent) listener) {
    _subscriptions.update(
      type,
      (subscriptionsList) {
        subscriptionsList.forEach((subscription) => subscription.cancel());
        return [
          _inputChannel.stream.listen((eventData) {
            SocketEvent event = SocketEvent.fromJson(jsonDecode(eventData));
            if (event.type == type) listener(event);
          })
        ];
      },
      ifAbsent: () => [
        _inputChannel.stream.listen((eventData) {
          SocketEvent event = SocketEvent.fromJson(jsonDecode(eventData));
          if (event.type == type) listener(event);
        })
      ],
    );
  }

  static void addListener(EventType type, void Function(SocketEvent) listener) {
    _subscriptions.update(
      type,
      (subscriptionsList) => [
        ...subscriptionsList,
        _inputChannel.stream.listen((eventData) {
          SocketEvent event = SocketEvent.fromJson(jsonDecode(eventData));
          if (event.type == type) listener(event);
        })
      ],
      ifAbsent: () => [
        _inputChannel.stream.listen((eventData) {
          SocketEvent event = SocketEvent.fromJson(jsonDecode(eventData));
          if (event.type == type) listener(event);
        })
      ],
    );
  }

  static void parseBarcode(BarcodeCapture capture,
      {void Function(String code)? onRegis,
      void Function(Device device, String key)? onAdmin}) {
    String? value = capture.barcodes.first.rawValue;

    if (value != null) {
      if (value.length == 134 && value.startsWith('regis-')) {
        onRegis?.call(value);
      }

      try {
        Map<String, dynamic> data = jsonDecode(value);
        onAdmin?.call(Device.fromJson(data), data['key']);
      } finally {}
    }
  }
}
