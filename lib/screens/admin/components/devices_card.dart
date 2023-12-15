import 'package:admin/constants.dart';
import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/RegisterController.dart';
import 'package:admin/models/Device.dart';
import 'package:admin/screens/admin/components/icon_selector.dart';
import 'package:admin/screens/components/button.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevicesCard extends StatefulWidget {
  const DevicesCard({Key? key}) : super(key: key);

  @override
  State<DevicesCard> createState() => _DevicesCardState();
}

class _DevicesCardState extends State<DevicesCard> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    RegisterController _controller = Get.put(RegisterController());
    TextEditingController _operatorController = TextEditingController();
    TextEditingController _placeController = TextEditingController();
    IconData _icon;
    String _type;

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(defaultPadding),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              show = !show;
            }),
            child: Row(
              children: [
                Text(
                  "Dispositivi registrati",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                Icon(Icons.menu),
                SizedBox(
                  width: defaultPadding,
                ),
              ],
            ),
          ),
          show
              ? SizedBox(
                  height: defaultPadding,
                )
              : Container(),
          show
              ? Obx(
                  () => Column(
                    children: List.generate(
                      _controller.devices.length,
                      (index) => _deviceRow(
                          _controller.devices[index], context, _controller, () {
                        _operatorController.text =
                            _controller.devices[index].operator;
                        _placeController.text =
                            _controller.devices[index].place;
                        _type = _controller.devices[index].type;
                        _icon = _controller.devices[index].icon;

                        showPopUp(
                          context,
                          "Modifica dispositivo",
                          [
                            TextInput(
                              textController: _operatorController,
                              label: "Operatore",
                            ),
                            TextInput(
                                textController: _placeController,
                                label: "Postazione"),
                            Container(
                              width: 300,
                              padding: EdgeInsets.only(left: defaultPadding),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownMenu<String>(
                                width: 240,
                                hintText: "Tipo",
                                initialSelection: _type,
                                menuHeight: 300,
                                inputDecorationTheme: InputDecorationTheme(
                                  border: InputBorder.none,
                                  fillColor: Theme.of(context).cardColor,
                                ),
                                dropdownMenuEntries: ["Pr", "Member", "Admin"]
                                    .map<DropdownMenuEntry<String>>(
                                      (type) => DropdownMenuEntry<String>(
                                        value: type.toLowerCase(),
                                        label: type,
                                      ),
                                    )
                                    .toList(),
                                onSelected: (value) {
                                  setState(() {
                                    _type = value as String;
                                  });
                                },
                              ),
                            ),
                            IconSelector(
                              initialSelection: _icon,
                              onChange: (icon) => _icon = icon,
                            ),
                          ],
                          () => _controller.modify(
                            _controller.devices[index],
                            new Device(
                              id: _controller.devices[index].id,
                              operator: _operatorController.text,
                              place: _placeController.text,
                              type: _type,
                              icon: _icon,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

Widget _deviceRow(Device device, BuildContext context,
    RegisterController _controller, Function() onModify) {
  return GestureDetector(
    onTap: () => device.call(),
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Config.get('deviceID') == device.id
            ? Colors.amber.shade600
            : _controller.isOnline(device)
                ? Colors.green
                : Colors.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: defaultPadding),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(device.icon),
            SizedBox(
              width: defaultPadding,
            ),
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  Text("${device.operator} @ ${device.place}"),
                  Text(
                    "${device.type} | ${device.id}",
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                ],
              ),
            ),
            VerticalDivider(
              color: Colors.white,
              width: 40,
            ),
            Container(
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    showPopUp(
                      context,
                      "Conferma",
                      [Text("Sei sicuro di voler eliminare il dispositivo?")],
                      () => _controller.delete(device),
                    );
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                GestureDetector(
                  onTap: onModify,
                  child: Icon(Icons.edit),
                )
              ]),
            )
          ],
        ),
      ),
    ),
  );
}
