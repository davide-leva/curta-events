import 'dart:async';

import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/DevicesController.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:admin/services/local_storage.dart';
import 'package:admin/services/socket_service.dart';
import 'package:admin/services/updater.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/Device.dart';

enum Collection {
  groups,
  inventory,
  products,
  shop,
  transactions,
  bank,
  parties,
  shifts,
  config,
  devices,
  register,
  backup,
}

enum Connection { pending, auth, web_auth, connected, failed }

enum Ping { pending, received }

class SyncService {
  static final ValueNotifier<Connection> status =
      ValueNotifier<Connection>(Connection.pending);
  static final ValueNotifier<Ping> ping = ValueNotifier<Ping>(Ping.received);
  static final ValueNotifier<String> socketChannel = ValueNotifier<String>("");

  static Future<void> init() async {
    await LocalStorage.init();
    Config.init();
    SocketService.init();

    CloudService.getInstagramFollowers().then((followers) {
      Config.set('followers', "$followers");
    });

    SocketService.setListener(EventType.CALL, (event) {
      DevicesController controller = Get.put(DevicesController());
      controller.setCaller(event.from);
      _callRing();
    });

    SocketService.setListener(EventType.ANSWER, (event) {
      DevicesController controller = Get.put(DevicesController());
      controller.setAnswerer(event.from);
      answerRing();
    });

    SocketService.setListener(EventType.UPDATE, (event) {
      Updater.update(Collection.values.singleWhere(
          (collection) => id(collection) == event.data['collection']));
    });

    SocketService.setListener(EventType.HANDSHAKE, (event) {
      Device device = Device.fromJson(event.data);

      Config.set('operator', device.operator);
      Config.set('place', device.place);
      Config.set('userLevel', device.type);
      Config.set('icon', device.icon.codePoint.toString());

      SyncService.status.value = Connection.connected;
    });

    SocketService.setListener(EventType.REGISTRATION, (event) {
      SyncService.status.value = Connection.auth;
      SyncService.socketChannel.value = event.data['regis'];
    });

    SocketService.setListener(EventType.SETTING, (event) {
      Config.set(event.data['key'], event.data['value']);
    });

    SocketService.setListener(EventType.AUTH, (event) {
      Device device = Device.fromJson(event.data['device']);

      Config.set('operator', device.operator);
      Config.set('place', device.place);
      Config.set('userLevel', device.type);
      Config.set('icon', device.icon.codePoint.toString());
      Config.set('key', event.data['key']);
      Config.set('deviceID', device.id);

      SyncService.status.value = Connection.connected;
    });

    SocketService.setListener(EventType.PING, (event) {
      ping.value = Ping.received;

      Timer.periodic(((event.data['interval'] as int) + 1).seconds, (timer) {
        if (ping.value == Ping.pending) {
          SocketService.init(reconnect: true);
        }
        timer.cancel();
      });

      Timer.periodic(((event.data['interval'] as int) - 1).seconds, (timer) {
        ping.value = Ping.pending;
        timer.cancel();
      });
    });
  }

  static String id(Collection collection) {
    String coll = collection.toString().split('.')[1];

    switch (collection) {
      case Collection.groups:
        return "${Config.get('selectedParty')}:$coll";

      case Collection.inventory:
        return "product:$coll";

      case Collection.parties:
        return "main:$coll";

      case Collection.bank:
        return "main:bank";

      case Collection.devices:
        return "$coll";

      case Collection.register:
        return "$coll";

      case Collection.shifts:
        return "${Config.get('selectedParty')}:$coll";

      case Collection.products:
        return "product:$coll";

      case Collection.shop:
        return "${Config.get('selectedParty')}:$coll";

      case Collection.transactions:
        return "${Config.get('selectedParty')}:$coll";

      case Collection.config:
        return "main:config";

      case Collection.backup:
        return "main:backups";
    }
  }

  static void _callRing() {
    AudioPlayer player = new AudioPlayer();
    player.play(AssetSource("sounds/call.mp3"));
  }

  static void answerRing() {
    AudioPlayer player = new AudioPlayer();
    player.play(AssetSource("sounds/answer.mp3"));
  }
}
