import 'package:admin/models/Backup.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:admin/services/sync_service.dart';
import 'package:get/get.dart';

import '../services/updater.dart';

class BackupController extends GetxController {
  List<Backup> _backups = <Backup>[].obs;
  List<Backup> get backups => _backups;

  @override
  void onReady() {
    _update();
    Updater.listen(Collection.backup, _update);
    super.onReady();
  }

  Future<void> _update() async {
    _backups.assignAll((await Updater.getData(Collection.backup))
        .map((data) => Backup.fromJson(data))
        .toList());

    return;
  }

  Future<void> delete(Backup backup) async {
    await CloudService.delete(Collection.backup, backup.id);
    await Updater.update(Collection.backup);
    return;
  }
}
