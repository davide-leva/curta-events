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
}

enum CloudState {
  online,
  offline,
}

enum SocketState { pending, auth, web_auth, connect, connected }

class SyncService {
  static final ValueNotifier<SocketState> socketState =
      ValueNotifier<SocketState>(SocketState.pending);
  static final ValueNotifier<String> socketChannel = ValueNotifier<String>("");
  static final ValueNotifier<CloudState> cloudState =
      ValueNotifier<CloudState>(CloudState.offline);

  static Future<void> init() async {
    await LocalStorage.init();
    Config.init();
    SocketService.init();

    Timer.periodic(10.seconds, (_) {
      CloudService.testConnection().then((isConnected) {
        if (isConnected) {
          cloudState.value = CloudState.online;
        } else {
          cloudState.value = CloudState.offline;
        }
      });
    });

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
          (collection) => collection.name == event.data['collection']));
    });

    SocketService.setListener(EventType.HANDSHAKE, (event) {
      Device device = Device.fromJson(event.data);

      Config.set('operator', device.operator);
      Config.set('place', device.place);
      Config.set('userLevel', device.type);
      Config.set('icon', device.icon.codePoint.toString());
      SyncService.socketState.value = SocketState.connect;
    });

    SocketService.setListener(EventType.REGISTRATION, (event) {
      SyncService.socketState.value = SocketState.auth;
      SyncService.socketChannel.value = event.data['regis'];
    });

    SocketService.setListener(EventType.SETTING, (event) {
      Config.set(event.data['key'], event.data['value']);
    });

    SocketService.setListener(EventType.AUTH, (event) {
      print("TESTTTTTTTTTTTTTT");
      Device device = Device.fromJson(event.data['device']);

      Config.set('operator', device.operator);
      Config.set('place', device.place);
      Config.set('userLevel', device.type);
      Config.set('icon', device.icon.codePoint.toString());
      Config.set('key', event.data['key']);

      SyncService.socketState.value = SocketState.connect;
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
        return "config";
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
