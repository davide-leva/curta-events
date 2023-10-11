import 'package:admin/constants.dart';
import 'package:admin/controllers/Config.dart';
import 'package:admin/screens/components/button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:flutter/material.dart';

class SettingPanel extends StatelessWidget {
  const SettingPanel(
      {required this.settingList,
      required this.panelName,
      this.controllers,
      this.onSave,
      this.readOnly = false});

  final List<String> settingList;
  final String panelName;
  final List<Widget>? controllers;
  final void Function(List<String> parameters)? onSave;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> tecl = List.empty(growable: true);
    List<ConfigEntry> configs = Config.config
        .where((entry) => settingList.contains(entry.key))
        .toList();

    configs.sort((a, _) => settingList.indexOf(a.key));

    List<Widget> configControllers = [
      ...List.generate(configs.length, (index) {
        tecl.add(TextEditingController(text: configs[index].value));

        return Container(
          margin: EdgeInsets.only(bottom: defaultPadding),
          child: TextInput(
            textController: tecl[index],
            label: configs[index].name,
            editable: !readOnly,
          ),
        );
      })
    ];

    controllers?.forEach((controller) {
      configControllers.add(controller);
      configControllers.add(SizedBox(height: defaultPadding));
    });

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            panelName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: configControllers,
          ),
          readOnly
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ActionButton(
                      title: "Salva",
                      onPressed: () {
                        for (int i = 0; i < configs.length; i++) {
                          Config.set(configs[i].key, tecl[i].text);
                        }

                        onSave?.call(tecl.map((e) => e.text).toList());
                      },
                      icon: Icons.save,
                      color: Colors.green,
                    )
                  ],
                )
        ],
      ),
    );
  }
}
