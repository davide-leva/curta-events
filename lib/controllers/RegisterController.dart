import 'package:admin/models/Device.dart';
import 'package:admin/services/data_service.dart';
import 'package:get/get.dart';

import '../services/sync_service.dart';
import '../services/updater.dart';

class RegisterController extends GetxController {
  List<Device> _devices = <Device>[].obs;
  List<Device> get devices => _devices;
  List<String> _online = <String>[].obs;

  @override
  void onReady() {
    _update();
    Updater.listen(Collection.register, _update);
    Updater.listen(Collection.devices, _update);
    super.onReady();
  }

  Future<void> _update() async {
    _devices.assignAll((await Updater.getData(Collection.register)).map((json) {
      Device device = Device.fromJson(json);

      return device;
    }));

    _online.assignAll(
      (await Updater.getData(Collection.devices))
          .map((json) => Device.fromJson(json).id),
    );
  }

  Future<void> modify(Device old, Device newDevice) async {
    await DataService.update(Collection.devices, old.id, newDevice);
    await Updater.update(Collection.register);
  }

  bool isOnline(Device device) {
    return _online.contains(device.id);
  }

  Future<void> delete(Device old) async {
    await DataService.delete(Collection.register, old.id);
    await Updater.update(Collection.register);
    return;
  }
}
