import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/screens/lista/components/result_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as s;
import 'package:get/get.dart';

extension LogicalKeybordKeyComparison on s.LogicalKeyboardKey {
  bool same(s.LogicalKeyboardKey other) {
    return this.keyId == other.keyId;
  }
}

class SearchCard extends StatefulWidget {
  SearchCard({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();
  final GroupsController groupsController = Get.put(GroupsController());

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (!(event is s.KeyDownEvent)) return;

        List<PersonEntry> people =
            searchPerson(widget.groupsController, widget.searchController.text);
        if (people.length != 1) return;

        PersonEntry personEntry = people.first;

        if (event.logicalKey.same(ENTRANCE_KEY)) {
          widget.groupsController
              .togglePersonEntrance(personEntry.gid, personEntry.pid);
        }
      },
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Cerca",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                SizedBox(
                  width: 200,
                  height: Responsive.isDesktop(context) ? 28 : 36,
                  child: Center(
                    child: TextInput(
                      textController: widget.searchController,
                      label: "",
                      onTextLength: () => setState(() {}),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            SizedBox(
              width: double.infinity,
              child: ResultList(
                searchText: widget.searchController.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
