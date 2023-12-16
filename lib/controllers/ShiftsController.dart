import 'package:admin/models/Shift.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:get/get.dart';

import '../services/sync_service.dart';
import '../services/updater.dart';

int sortShift(Shift a, Shift b) {
  int na = a.timeStart.hour * 60 + a.timeStart.minute;
  int nb = b.timeStart.hour * 60 + b.timeStart.minute;

  return (na < 300 ? na + 1440 : na) - (nb < 300 ? nb + 1440 : nb);
}

class ShiftController extends GetxController {
  List<Shift> _shifts = <Shift>[].obs;
  List<Shift> get shifts => _shifts;

  @override
  void onReady() {
    _update();
    Updater.listen(Collection.shifts, _update);
    super.onReady();
  }

  Future<void> _update() async {
    _shifts.assignAll((await Updater.getData(Collection.shifts))
        .map((json) => Shift.fromJson(json)));

    _shifts.sort(sortShift);

    update();
    return;
  }

  Future<void> add(Shift shift) async {
    await CloudService.insert(Collection.shifts, shift);
    await Updater.update(Collection.shifts);
    return;
  }

  Future<void> modify(Shift oldShift, Shift newShift) async {
    await CloudService.update(Collection.shifts, oldShift.id, newShift);
    await Updater.update(Collection.shifts);
    return;
  }

  Future<void> delete(Shift shift) async {
    await CloudService.delete(Collection.shifts, shift.id);
    await Updater.update(Collection.shifts);
    return;
  }
}
