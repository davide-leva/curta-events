import 'package:admin/constants.dart';
import 'package:admin/screens/components/action_button.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:flutter/material.dart';

class AddLista extends StatelessWidget {
  AddLista({
    Key? key,
    required this.onGroup,
  }) : super(key: key);

  final TextEditingController _groupNameController = TextEditingController();
  final Function(String groupName) onGroup;

  @override
  Widget build(BuildContext context) {
    return TableButton(
      onPressed: () => showPopUp(
        context,
        "Aggiungi gruppo",
        [
          Container(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kDefaultPadding),
              color: Theme.of(context).cardColor,
            ),
            child: TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                label: Text("Nome gruppo"),
              ),
            ),
          )
        ],
        () => onGroup(_groupNameController.text),
      ),
      icon: Icons.add,
      color: Colors.lightBlue,
    );
  }
}
