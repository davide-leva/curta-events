import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/models/Person.dart';
import 'package:admin/screens/new_lista/components/person_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Pair<T> {
  Pair({
    required this.obj,
    required this.index,
  });

  final T obj;
  final int index;
}

extension IndexList<T> on Iterable<T> {
  Iterable<Pair<T>> get indexed {
    int i = 0;
    return this.map((e) => Pair(obj: e, index: i++));
  }
}

class PersonEntry {
  final Person person;
  final String groupName;
  final int gid;
  final int pid;

  PersonEntry(this.person, this.groupName, this.gid, this.pid);
}

class ResultList extends StatelessWidget {
  ResultList({
    Key? key,
    required this.searchText,
  }) : super(key: key);

  final String searchText;
  final GroupsController _groupsController = Get.put(GroupsController());

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: kDefaultPadding,
      runSpacing: kDefaultPadding,
      alignment: WrapAlignment.center,
      children: searchPerson(_groupsController, searchText)
          .map((entry) => GestureDetector(
                onTap: () {
                  _groupsController.togglePersonEntrance(entry.gid, entry.pid);
                },
                child: PersonCard(
                  person: entry.person,
                  id: PersonID(
                    entry.gid,
                    entry.pid,
                  ),
                  enableAction: false,
                ),
              ))
          .toList(),
    );
  }
}

List<PersonEntry> searchPerson(GroupsController controller, String searchText) {
  if (searchText.length < 3) return List.empty();

  return flatten(
    controller.groups.indexed.map(
      (groupPair) => groupPair.obj.people.indexed.map(
        (personPair) => PersonEntry(
          personPair.obj,
          groupPair.obj.title,
          groupPair.index,
          personPair.index,
        ),
      ),
    ),
  ).where((entry) {
    List<String> words = searchText.toLowerCase().split(' ');

    bool flag = true;
    words.forEach((word) {
      flag = flag &&
          (entry.person.name.toLowerCase().contains(word) ||
              word.contains(entry.person.name.toLowerCase()));
    });

    return flag;
  }).toList();
}
