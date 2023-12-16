import 'package:admin/models/Device.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:get/get.dart';

import '../services/sync_service.dart';
import '../services/updater.dart';

class DevicesController extends GetxController {
  static List<String> _answerer = <String>[].obs;
  static List<String> _caller = <String>[].obs;

  List<Device> _devices = <Device>[].obs;
  List<Device> get devices => _devices;

  @override
  void onReady() {
    _update();
    Updater.listen(Collection.devices, _update);
    super.onReady();
  }

  Future<void> _update() async {
    _devices.assignAll((await Updater.getData(Collection.devices)).map((json) {
      Device device = Device.fromJson(json);
      if (_answerer.contains(device.id)) device.isAnswerer = true;
      if (_caller.contains(device.id)) device.isCaller = true;

      return device;
    }));
  }

  Future<void> modify(Device old, Device newDevice) async {
    await CloudService.update(Collection.devices, old.id, newDevice);
    await Updater.update(Collection.devices);
    return;
  }

  setCaller(String deviceID) async {
    _caller.add(deviceID);
    await Updater.update(Collection.devices);

    Future.delayed(1.minutes, () async {
      _answerer.remove(deviceID);
      await Updater.update(Collection.devices);
    });
  }

  removeCaller(String deviceID) async {
    _caller.remove(deviceID);
    await Updater.update(Collection.devices);
  }

  setAnswerer(String deviceID) async {
    _answerer.add(deviceID);
    await Updater.update(Collection.devices);

    Future.delayed(10.seconds, () async {
      _answerer.remove(deviceID);
      await Updater.update(Collection.devices);
    });
  }
}
