import 'package:admin/models/Group.dart';
import 'package:admin/models/Person.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/sync_service.dart';
import '../services/updater.dart';

List<T> flatten<T>(Iterable<Iterable<T>> list) =>
    [for (var sublist in list) ...sublist];

class SearchEntry {
  SearchEntry({
    required this.groupIndex,
    required this.personIndex,
  });

  int groupIndex;
  int personIndex;
}

class GroupsController extends GetxController {
  List<ListaGroup> _groups = <ListaGroup>[].obs;
  List<ListaGroup> get groups => _groups;

  int get totalPeople => groups.fold(
        0,
        (sum, group) => sum + group.numberOfPeople,
      );

  int get totalEntered => groups.fold(
        0,
        (sum, group) =>
            sum +
            group.people.fold(
              0,
              (_sum, person) => _sum + (person.hasEntered ? 1 : 0),
            ),
      );

  @override
  void onReady() {
    _update();
    Updater.listen(Collection.groups, _update);
    super.onReady();
  }

  Future<void> _update() async {
    _groups.assignAll((await Updater.getData(Collection.groups))
        .map((data) => ListaGroup.fromJson(data))
        .toList());

    _groups.forEach((group) {
      group.people.sort((p1, p2) => p1.name.compareTo(p2.name));
    });
    _groups.sort((g1, g2) => g1.title.compareTo(g2.title));
    _groups.sort((g1, g2) =>
        g1.title == 'Aggiunti' ? 0 : 1 - (g2.title == 'Aggiunti' ? 0 : 1));

    await Updater.update(Collection.transactions, cloud: false);
    return;
  }

  Future<void> add(ListaGroup group) async {
    await CloudService.insert(Collection.groups, group);
    await Updater.update(Collection.groups);
    return;
  }

  Future<void> delete(ListaGroup group) async {
    await CloudService.delete(Collection.groups, group.id);
    await Updater.update(Collection.groups);
    return;
  }

  Future<void> addPerson(int index, String name, {int code = 0}) async {
    ListaGroup group = _groups[index];

    group.numberOfPeople += 1;
    group.people.add(Person(
      name: name,
      hasEntered: false,
      hasPaid: false,
      code: code,
    ));

    await CloudService.update(Collection.groups, group.id, group);
    await Updater.update(Collection.groups);
    return;
  }

  Future<void> removePerson(int groupIndex, int personIndex) async {
    ListaGroup group = _groups[groupIndex];

    group.numberOfPeople -= 1;
    group.people.removeAt(personIndex);

    await CloudService.update(Collection.groups, group.id, group);
    await Updater.update(Collection.groups);
    return;
  }

  Future<void> togglePersonPaid(int groupIndex, int personIndex) async {
    ListaGroup group = _groups[groupIndex];

    if (group.people[personIndex].code == 0)
      group.people[personIndex].hasPaid = !group.people[personIndex].hasPaid;

    await CloudService.update(Collection.groups, group.id, group);
    await Updater.update(Collection.groups);
    return;
  }

  Future<void> togglePersonEntrance(int groupIndex, int personIndex) async {
    ListaGroup group = _groups[groupIndex];

    if (!group.people[personIndex].hasPaid)
      group.people[personIndex].hasPaid = true;

    group.people[personIndex].hasEntered =
        !group.people[personIndex].hasEntered;

    await CloudService.update(Collection.groups, group.id, group);
    await Updater.update(Collection.groups);
    return;
  }

  Future<void> modifyPersonDiscount(
      int groupIndex, int personIndex, double discount) async {
    ListaGroup group = _groups[groupIndex];

    group.people[personIndex].discount = discount;

    await CloudService.update(Collection.groups, group.id, group);
    await Updater.update(Collection.groups);
    return;
  }

  Future<void> modifyPersonName(
      int groupIndex, int personIndex, String name) async {
    ListaGroup group = _groups[groupIndex];

    group.people[personIndex].name = name;

    await CloudService.update(Collection.groups, group.id, group);
    await Updater.update(Collection.groups);
    return;
  }

  SearchEntry? searchBarcode(BarcodeCapture capture) {
    for (int i = 0; i < groups.length; i++) {
      for (int j = 0; j < groups[i].numberOfPeople; j++) {
        if (groups[i].people[j].code ==
            (int.parse(capture.barcodes[0].rawValue ?? "0"))) {
          return SearchEntry(groupIndex: i, personIndex: j);
        }
      }
    }

    return null;
  }

  Future<void> modifyPersonCode(
      int groupIndex, int personIndex, int code) async {
    ListaGroup group = _groups[groupIndex];

    group.people[personIndex].code = code;
    group.people[personIndex].hasPaid = true;

    await CloudService.update(Collection.groups, group.id, group);
    await Updater.update(Collection.groups);
    return;
  }
}
