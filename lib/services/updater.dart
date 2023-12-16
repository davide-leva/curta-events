import 'package:admin/services/cloud_service.dart';
import 'package:admin/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Updater {
  static final Map<Collection, ValueNotifier<int>> _notifier = {
    Collection.groups: ValueNotifier<int>(0),
    Collection.products: ValueNotifier<int>(0),
    Collection.shifts: ValueNotifier<int>(0),
    Collection.inventory: ValueNotifier<int>(0),
    Collection.shop: ValueNotifier<int>(0),
    Collection.transactions: ValueNotifier<int>(0),
    Collection.parties: ValueNotifier<int>(0),
    Collection.bank: ValueNotifier<int>(0),
    Collection.devices: ValueNotifier<int>(0),
    Collection.register: ValueNotifier<int>(0),
  };

  static final Map<Collection, List<Map<String, dynamic>>> _data = {
    Collection.groups: [],
    Collection.products: [],
    Collection.shifts: [],
    Collection.inventory: [],
    Collection.shop: [],
    Collection.transactions: [],
    Collection.parties: [],
    Collection.bank: [],
    Collection.devices: [],
    Collection.register: [],
  };

  static Future<void> update(Collection scope, {cloud = true}) async {
    if (cloud) {
      _data[scope]?.assignAll((await CloudService.get(scope)));
    }

    _notifier[scope]?.value++;
    return;
  }

  static Future<void> refresh() async {
    for (Collection scope in Collection.values) {
      await update(scope, cloud: true);
    }
  }

  static void listen(Collection scope, void Function() onUpdate) {
    _notifier[scope]?.addListener(onUpdate);
  }

  static Future<List<Map<String, dynamic>>> getData(Collection scope) async {
    if ((_data[scope] ?? []).isEmpty) {
      _data[scope]?.assignAll((await CloudService.get(scope)));
    }

    return _data[scope] ?? [];
  }
}
